<p align="center">
  <a href="https://github.com/FedeLoch/Shin/actions/workflows/ci.yml"><img src="https://github.com/FedeLoch/Shin/actions/workflows/ci.yml/badge.svg" alt="CI Status"/></a>
  <a href="https://github.com/FedeLoch/Shin"><img src="https://img.shields.io/github/last-commit/FedeLoch/Shin" alt="Last Commit"/></a>
  <a href="https://github.com/FedeLoch/Shin"><img src="https://img.shields.io/github/license/FedeLoch/Shin" alt="License"/></a>
</p>

# Shin — Input Minimization Library for Pharo

Shin provides **state-of-the-art shrinking implementations** for Pharo. It takes a potentially large input that triggers the behavior of interest and produces a much smaller input that still reproduces the same behavior.

Shin is **grammar-aware**: it can parse inputs into a concrete syntax tree and reduce the tree, so the minimized output always stays valid according to the grammar. It ships with implementations of several well-known shrinking algorithms, a set of pluggable oracles, and tooling to benchmark them against each other.

## Getting Started

### Installation

Load the latest stable version using Metacello:

```st
Metacello new
    baseline: 'Shin';
    repository: 'github://FedeLoch/Shin:main';
    onConflictUseIncoming;
    load.
```

### Minimal example

The quickest way to shrink a string is to use the classic `ddmin` shrinker with a boolean oracle:

```st
shrinker := ShinDDminPaperShrinker new.
shrinker oracle: (ShinBooleanInputOracle from: [ :string | string includes: $e ]).

(shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') "=> 'e'"
```

## How it works

Shin separates three orthogonal concerns:

1. **Shrinker** — the reduction algorithm that iteratively tries to remove or simplify parts of the input.
2. **Oracle** — decides whether a given candidate input still triggers the behavior of interest.
3. **Grammar** — (optional, for tree-based shrinkers) describes the input language so reductions stay syntactically valid.

A typical pipeline:

```
original input ──▶ parse ──▶ tree ──▶ minimize (guided by the oracle) ──▶ smaller tree ──▶ emit ──▶ minimized input
```

For convenience, the `ShinShrinker` base class exposes two entry points:

- `shrink: anInput` — returns the minimized input.
- `profiledShrink: anInput` — returns a dictionary with statistics (original/minimized input, elapsed time, number of needed and failed reductions, `%` of problem preservation and input reduction, original/minimized bound).

## Shrinkers

Shin provides the following shrinkers. Tree-based ones are grammar-aware.

| Shrinker | Type | Description |
| --- | --- | --- |
| `ShinDDminPaperShrinker` | Character/string | Classic delta-debugging `ddmin` from the original [delta-debugging paper](https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf). |
| `ShinDDminPaperCustomShrinker` | Character/string | `ddmin` variant with custom recursion/statistics callbacks. |
| `ShinDDminFuzzingBookShrinker` | Character/string | `ddmin` variant following Zeller's "The Fuzzing Book". |
| `ShinHDDShrinker` | Grammar tree | Hierarchical Delta Debugging — applies `ddmin` level by level over the parse tree. |
| `ShinGRABRShrinker` | Grammar tree | Grammar-based reduction that replaces subtrees with grammar-derived smaller candidates. |
| `ShinNautilusShrinker` | Grammar tree | Reward-based reduction inspired by Nautilus, repeatedly minimizing the "worst" node. |
| `ShinVulcanShrinker` | Grammar tree | Combines a main reducer (HDD) with auxiliary reducers: identifier replacement, subtree reduction, and tree-based Linear Example-based Edition (LEE). |

Other building blocks include the abstract `ShinGrammarShrinker`, the `ShinSimplifyGrammar*` strategies, and the `ShinVulcanAuxiliaryReducer` hierarchy (`ShinIdentifierReplacement`, `ShinSubTreeReducer`, `ShinTreeBasedLEE`).

Subclasses of `ShinShrinker` can be configured with:
- `maxIterations:` — cap on the number of reduction rounds (default `1000`).
- `oracle:` — the oracle used to validate candidates.
- `grammar:` — the grammar used to parse/validate inputs (tree-based shrinkers).

## Oracles

An oracle decides whether a candidate input still reproduces the target behavior. `ShinInputOracle` is the abstract base class; the following implementations are provided:

| Oracle | Description |
| --- | --- |
| `ShinBooleanInputOracle` | Runs a boolean block on the input (e.g. "does it raise an error?"). |
| `ShinDivideZeroOracle` | Detects division-by-zero in arithmetic expressions. |
| `ShinExecutionTimeOracle` | Checks execution time against a threshold. |
| `ShinThresholdOracle` | Base class that accepts an input if its bound is above a fraction (`threshold`, default `0.95`) of the original bound. |
| `ShinCoverageOracle` | Preserves code-coverage properties (uses `C2CoverageCollector` to instrument methods). |
| `ShinMethodCallsOracle` | Preserves the set of methods called by the execution. |
| `ShinFeedbackTableOracle` | Compares a feedback table against the baseline. |

### Grammar-based shrinking

For tree-based shrinkers, provide a grammar and an oracle. For example, minimizing an arithmetic expression that contains a division by zero:

```st
shrinker := ShinVulcanShrinker new.
shrinker grammar: AritExpressionGrammar new.
shrinker oracle: ShinDivideZeroOracle new.

input := '((8500/(208000*80))+(165468468)*(423-12)*(999/(12+88)))/(((145*4)-580)*3)+((456)*12)-(89/(45+(12*8)))+(77*14)'.
minimized := shrinker shrink: input.
```

## Running benchmarks

Shin provides ready-to-use benchmark classes per input language (regex, SVG, JSON, Microdown, arithmetic expressions). Each one sets its own grammar and test corpus — simply pick one, add the shrinker classes you want to compare, and run it:

```st
bench := ShinShrinkingRegexBenchmark new.
bench shrinkers: { ShinHDDShrinker. ShinGRABRShrinker. ShinNautilusShrinker }.
report := bench bench.
```

To benchmark a shrinker on your own corpus, subclass `ShinShrinkingBenchmark` and populate `grammar` and `tests` (a list of `ShinShrinkerTest` instances built with `input:oracle:`) in `#initialize`.

```st
report plotInputReduction.       "plot % input reduction across tests"
report plotProblemPreservation.  "plot % problem preservation"
report plotTotalTime.            "plot elapsed time (log scale)"
report plotNeededReductions.     "plot number of needed reductions"
report plotFailedReductions.     "plot number of failed reductions"
report saveAsFile: 'results.json'.
```

Plots are built with [Roassal](https://github.com/ObjectProfile/Roassal3) and benchmark results can be exported as JSON.

## Requirements

- Pharo (current stable release supported by the CI workflow).
- [Roassal](https://github.com/ObjectProfile/Roassal3) — used for benchmark plot generation.

## State of the Art

- Delta debugging: [Zeller 1999](https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf)
- Hierarchical Delta Debugging (HDD): [Misherghi & Su](https://www.cs.ucr.edu/~hhsu/papers/asplos06-hdd.pdf)
- Nautilus: [Astrauskas et al.](https://github.com/RUB-SysSec/Nautilus)
- Vulcan: [FuzzBench](https://github.com/purseclab/Vulcan)
- Perser
- The Fuzzing Book: [Zeller et al.](https://www.fuzzingbook.org/)

## License

This project is licensed under the terms shown in the [repository](https://github.com/FedeLoch/Shin).