<p align="center">
  <a href="https://github.com/FedeLoch/Shin/actions/workflows/ci.yml"><img src="https://github.com/FedeLoch/Shin/actions/workflows/ci.yml/badge.svg" alt="CI Status"/></a>
  <a href="https://github.com/FedeLoch/Shin"><img src="https://img.shields.io/github/last-commit/FedeLoch/Shin" alt="Last Commit"/></a>
  <a href="https://github.com/FedeLoch/Shin"><img src="https://img.shields.io/github/license/FedeLoch/Shin" alt="License"/></a>
</p>

# Shin — Input Minimization Library for Pharo

Shin is a framework for **input minimization** (also called *test-case reduction* or *shrinking*) in [Pharo](https://pharo.org). It takes a potentially large input that triggers the behavior of interest and, guided by an **oracle**, produces a much smaller input that still reproduces the same behavior.

Shin is **grammar-aware**: it parses inputs into a concrete syntax tree and reduces the tree, so the minimized output is always syntactically valid according to the grammar.

## Highlights

- **State-of-the-art shrinking algorithms** — Vulcan-style reducers (main reducer + auxiliary reducers: identifier replacement, subtree reduction, tree-based linear example-based edition), Nautilus-style reward-based reduction, GRABR grammar-based reduction, alongside the classics: delta debugging (`ddmin`) and hierarchical delta debugging (HDD).
- **Grammar-driven** — shrinkers operate on the parse tree and use `UME`-based grammars, so every candidate stays valid.
- **Pluggable oracles** — boolean, divide-by-zero, method-call, execution-time, threshold, coverage, and feedback-table oracles.
- **Built-in datasets & benchmarks** — ready-to-use corpora for six input languages (regular expressions, SVG paths, arithmetic expressions, JSON, Microdown, Roassal graphs) with automated comparison, plot generation, and JSON export.
- **Runnable examples** — the test suites double as self-contained usage examples for every shrinker.

## Getting Started

### Installation

```st
Metacello new
    baseline: 'Shin';
    repository: 'github://FedeLoch/Shin:main';
    onConflictUseIncoming;
    load.
```

### Minimal example

Shrink a string with the classic `ddmin` shrinker and a boolean oracle:

```st
shrinker := ShinDDminPaperShrinker new.
shrinker oracle: (ShinBooleanInputOracle from: [ :string | string includes: $e ]).

(shrinker shrink: 'asqjjkqsbdvieqvsbdoivbq') "=> 'e'"
```

## How it works

Shin separates three orthogonal concerns:

1. **Shrinker** — the reduction algorithm that iteratively removes or simplifies parts of the input.
2. **Oracle** — decides whether a candidate input still triggers the behavior of interest.
3. **Grammar** — describes the input language so tree-based reductions stay syntactically valid.

A typical pipeline:

```
original input ──▶ parse ──▶ tree ──▶ minimize (guided by the oracle) ──▶ smaller tree ──▶ emit ──▶ minimized input
```

The `ShinShrinker` base class exposes two entry points:

- `shrink: anInput` — returns the minimized input.
- `profiledShrink: anInput` — returns a dictionary with validation metrics: `originalInput`, `minimizedInput`, `totalTime`, `neededReductions`, `failedReductions`, `%problemPreservation`, `%inputReduction`, `originalBound` and `minimizedBound`.

## Shrinkers

### State-of-the-art

| Shrinker | Description |
| --- | --- |
| `ShinVulcanShrinker` | Vulcan-style reducer: a main reducer (HDD by default) combined with auxiliary reducers — identifier replacement, subtree reduction, and tree-based LEE — iterated until no improvement is found. |
| `ShinSubTreeReducer` | Reduces subtrees by replacing them with smaller grammar-valid candidates of the same symbol. |
| `ShinIdentifierReplacement` | Normalizes identifiers by unifying leaves that share a parent symbol while preserving the behavior. |
| `ShinTreeBasedLEE` | Tree-based linear example-based edition: removes windows of nodes at a given tree level while the behavior is preserved. |
| `ShinNautilusShrinker` | Nautilus-inspired reduction that repeatedly minimizes the node with the worst "reward". |
| `ShinGRABRShrinker` | Grammar-based reduction with backtracking: explores grammar-derived replacement candidates, from smaller to larger, restarting after each successful reduction. |

### Classic

| Shrinker | Description |
| --- | --- |
| `ShinDDminPaperShrinker` | Delta debugging `ddmin` from the original [delta-debugging paper](https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf). |
| `ShinDDminPaperCustomShrinker` | `ddmin` variant with custom recursion/statistics callbacks. |
| `ShinDDminFuzzingBookShrinker` | `ddmin` complement-based variant following "The Fuzzing Book". |
| `ShinHDDShrinker` | Hierarchical delta debugging — applies `ddmin` at each level of the parse tree. |

Other building blocks include the abstract `ShinGrammarShrinker`, the `ShinSimplifyGrammar*` reversal strategies, and the `ShinVulcanAuxiliaryReducer` base class.

Shrinker subclasses can be configured with:

- `oracle:` — the oracle used to validate candidates (required).
- `grammar:` — the grammar for parsing inputs (tree-based shrinkers).
- `maxIterations:` — cap on reduction rounds (default `1000`).
- `Vulcan` specific: `mainReducer:`, `setWindowSize:`.

## Oracles

An oracle decides whether a candidate input still reproduces the target behavior. Two flavors are provided:

### Behavioral oracles (bug/metric hunt)

| Oracle | Description |
| --- | --- |
| `ShinBooleanInputOracle` | Runs a boolean block on the input, e.g. "does the input contain `$e`?" |
| `ShinDivideZeroOracle` | Detects division by zero when evaluating the input (arithmetic expressions). |
| `ShinMethodCallsOracle` | Computes the number of methods called by the execution (via `PBAnalyzer`) and keeps candidates above a `threshold` fraction of the original. |
| `ShinExecutionTimeOracle` | Measures execution time (with `microsecondsToRun`) and keeps candidates above a `threshold` fraction of the original time. |

### Preservation oracles (keep the whole behavior)

| Oracle | Description |
| --- | --- |
| `ShinCoverageOracle` | Preserves code coverage — percentage, nodes and methods — using `C2CoverageCollector` instrumentation. |
| `ShinFeedbackTableOracle` | Preserves the absolute improvement computed from a profiling feedback table. |
| `ShinThresholdOracle` | Base class for threshold-based oracles (default `threshold: 0.95`). |

## Grammar-based shrinking example

Provide a grammar and an oracle, then shrink. Here, minimize an arithmetic expression that still contains a division by zero:

```st
shrinker := ShinVulcanShrinker new.
shrinker grammar: AritExpressionGrammar new.
shrinker oracle: ShinDivideZeroOracle new.

input := '((8500/(208000*80))+(165468468)*(423-12)*(999/(12+88)))/(((145*4)-580)*3)+((456)*12)-(89/(45+(12*8)))+(77*14)'.
minimized := shrinker shrink: input.
```

You can measure how well it worked with `profiledShrink:`:

```st
results := shrinker profiledShrink: input.
results at: '%inputReduction'.     "percentage of nodes removed"
results at: '%problemPreservation'. "how much of the original behavior is kept"
```

## Datasets & benchmarks

Shin ships with built-in datasets covering six input languages, each paired with a grammar and an oracle. Every dataset is exposed as a subclass of `ShinShrinkingBenchmark`:

| Benchmark (dataset) | Language | Grammar | Oracle |
| --- | --- | --- | --- |
| `ShinShrinkingRegexBenchmark` | Regular expressions | `GncRegexGrammar` | `ShinMethodCallsOracle` |
| `ShinShrinkingRegexCoverageBenchmark` | Regular expressions | `GncRegexGrammar` | `ShinCoverageOracle` |
| `ShinShrinkingAExprBenchmark` | Arithmetic expressions | `AritExpressionGrammar` | `ShinDivideZeroOracle` |
| `ShinShrinkingSVGBenchmark` | SVG paths | `SvgPathGrammar` | `ShinExecutionTimeOracle` |
| `ShinShrinkingSVGCoverageBenchmark` | SVG paths | `SvgPathGrammar` | `ShinCoverageOracle` |
| `ShinShrinkingGraphCoverageBenchmark` | Roassal graph DSL | `RoassalGraphGrammar` | `ShinCoverageOracle` |
| `ShinShrinkingJSONCoverageBenchmark` | JSON documents | `JSONGrammar` | `ShinCoverageOracle` |
| `ShinShrinkingMicrodownCoverageBenchmark` | Microdown documents | `ExtendedMarkdownGrammar` | `ShinCoverageOracle` |

### Running a comparison

Pick a dataset, choose the shrinkers to compare, and run the benchmark:

```st
bench := ShinShrinkingRegexBenchmark new.
bench shrinkers: { ShinDDminPaperShrinker. ShinHDDShrinker. ShinGRABRShrinker. ShinNautilusShrinker. ShinVulcanShrinker }.
report := bench bench.
```

`ShinShrinkingBenchmark` runs each shrinker over every test in the corpus and produces an aggregated `ShinShrinkingBenchmarkReport`:

```st
report plotInputReduction.       "% input reduction, compared per shrinker"
report plotProblemPreservation.  "% problem preservation"
report plotTotalTime.            "elapsed time (log scale)"
report plotNeededReductions.     "number of needed reductions"
report plotFailedReductions.     "number of failed reductions"
report saveAsFile: 'results.json'.
```

Plots are rendered with [Roassal](https://github.com/ObjectProfile/Roassal3), and results can be exported as JSON.

To benchmark a shrinker on your own corpus, subclass `ShinShrinkingBenchmark` and populate `grammar` and `tests` (a list of `ShinShrinkerTest` instances built with `input:oracle:`) in `#initialize`.

## Examples & tests

The test suites double as runnable examples for every shrinker and oracle combination:

| Test class | Shows |
| --- | --- |
| `ShinDDTest` | `ddmin` on plain strings with boolean oracles. |
| `ShinHDDTest` | HDD on arithmetic expressions and SVG paths, including an execution-time oracle. |
| `ShinVulcanTest` | Vulcan reduction and its individual auxiliary reducers (identifier replacement, tree-based LEE). |
| `ShinGrammarBasedShrinkerTest` / `ShinStrategyShrinkerTest` / `ShinArithExpressionShrinkerTest` | Grammar-based and strategy-specific reduction. |

## Requirements

- Pharo (current stable release, as exercised by the CI workflow).
- [Roassal](https://github.com/ObjectProfile/Roassal3) — benchmark plot generation.

## Project structure

```
Shin/
├── BaselineOfShin/     # Metacello baseline
└── Shin/
    ├── ShinShrinker*   # Shrinker base class and algorithms
    ├── Shin*Oracle*    # Oracle implementations
    ├── Shin*Shrinkers  # State-of-the-art and classic reducers
    ├── Shin*Benchmark  # Built-in datasets and reporting
    └── Shin*Test       # Runnable examples and shrinker-test harness
```

## Related work

Shin re-implements and generalizes published reduction techniques, including:

- Delta debugging — [Zeller (ICSE 1999)](https://www.cs.purdue.edu/homes/xyzhang/fall07/Papers/delta-debugging.pdf).
- Hierarchical delta debugging — [Misherghi & Su (ASPLOS 2006)](https://www.cs.ucr.edu/~hhsu/papers/asplos06-hdd.pdf).
- Example-based reduction and tree-based linear example-based edition (LEE).
- Grammar-based reducers inspired by [Nautilus](https://github.com/nautilus-fuzz/nautilus) and Vulcan.

## License

This project is licensed under the terms shown in the [repository](https://github.com/FedeLoch/Shin).