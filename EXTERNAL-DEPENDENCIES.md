# External Dependencies of the `Shin` package

This file tracks the external (non-`Shin`, non-base-Pharo) classes referenced by
the `Shin` package. It exists so the dependencies can be re-added to
`BaselineOfShin` (or moved to another home) and tracked over time.

> Status: `BaselineOfShin` currently declares **no** dependencies. Loading
> `Shin` alone succeeds at compile time, but any code path touching a missing
> class fails at runtime.

---

## 1. Ume package — `github://FedeLoch/Ume:main`

> Note: `BaselineOfUme` itself depends on `Shin`, so adding `baseline: 'Ume'`
> to `BaselineOfShin` would create a load cycle.

### Referenced by core `Shin` classes

| Class | Why |
| --- | --- |
| `UmeGrammarParser` | `ShinShrinker.class.st:25` (`accept:from:`), `ShinGrammarShrinker.class.st:65` (`parse:from:`) — used to build the AST for grammar-based shrinking |
| `UmeTest`, `UmeEvalSuccess` | `ShinFeedbackTableOracle.class.st:46` — builds feedback-table oracle cases |

### Referenced by the `Shrinker Tests` (CI scope)

| Class | Where |
| --- | --- |
| `AritExpressionGrammar` | `ShinStrategyShrinkerTest.class.st:18`, `ShinArithExpressionShrinkerTest.class.st:18`, `ShinSimplifyGrammarAlternateReductionTest.class.st:13/26/39`, `ShinSimplifyGrammarSubtreeReducerTest.class.st:13/27`, `ShinVulcanTest.class.st:24/33/72/86`, `ShinHDDTest.class.st:19` |
| `SvgPathGrammar` | `ShinStrategyShrinkerTest.class.st:130/144`, `ShinVulcanTest.class.st:44/100/114`, `ShinHDDTest.class.st:93/106` |
| `SVGRunner` | `ShinStrategyShrinkerTest.class.st:127`, `ShinHDDTest.class.st:103` |
| `UmeGrammarParser` | `ShinArithExpressionShrinkerTest.class.st:45`, `ShinSimplifyGrammarAlternateReductionTest.class.st:15/28/41`, `ShinSimplifyGrammarSubtreeReducerTest.class.st:15/29` |

### Referenced only by benchmark classes (not run by CI)

| Class | Where |
| --- | --- |
| `AritExpressionGrammar` | `ShinShrinkingAExprBenchmark.class.st:13` |
| `SvgPathGrammar`, `SVGRunner` | `ShinShrinkingSVGBenchmark.class.st:14/15`, `ShinShrinkingSVGCoverageBenchmark.class.st:14/17` |
| `ExtendedMarkdownGrammar` | `ShinShrinkingMicrodownCoverageBenchmark.class.st:14` |
| `JSONGrammar` | `ShinShrinkingJSONCoverageBenchmark.class.st:14` |
| `RoassalGraphGrammar`, `UmeRoassalGrapher` | `ShinShrinkingGraphCoverageBenchmark.class.st:14/17` |

---

## 2. Gnocco — `github://Alamvic/gnocco:release/src`

| Class | Where |
| --- | --- |
| `GncRegexGrammar` (defined in `Gnocco-Benchmarks`) | `ShinStrategyShrinkerTest.class.st:110`, `ShinVulcanTest.class.st:57` |

---

## 3. PBA — `github://FedeLoch/PBA:main`

| Class | Where |
| --- | --- |
| `PBAProgram` | `ShinFeedbackTableOracle.class.st:43`, `ShinMethodCallsOracle.class.st:19` |
| `PBAnalyzer`, `PBAMethodProfiler` | `ShinMethodCallsOracle.class.st:51` |

---

## 4. Coverage2 — package bundled in the Ume repo (also `pharo-mooc/Coverage2`)

| Class | Where |
| --- | --- |
| `C2CoverageCollector` | `ShinCoverageOracle.class.st:57` |

---

## 5. Other libraries — benchmarks / report only

| Library | Used by |
| --- | --- |
| Microdown (`Microdown parse:`, `Microdown package`) | `ShinShrinkingMicrodownCoverageBenchmark.class.st:16/17` |
| NeoJSON (`NeoJSONReader`, `NeoJSONWriter`) | `ShinShrinkingJSONCoverageBenchmark.class.st:16/17`, `ShinShrinkingBenchmarkReport.class.st:138` |
| Roassal (`RSChart`) | `ShinShrinkingBenchmarkReport.class.st:22` |

## 6. Base Pharo image

| Library | Where |
| --- | --- |
| RxMatcher (`asRegex`) | `ShinStrategyShrinkerTest.class.st:112` |