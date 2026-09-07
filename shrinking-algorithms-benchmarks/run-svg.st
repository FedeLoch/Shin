| shrinkerClasses benchmark report |

Metacello new
    baseline: 'Shin';
    repository: 'github://FedeLoch/Shin:main';
	onConflictUseIncoming;
    load.

shrinkerClasses := {
    Smalltalk at: #ShinGRABRShrinker.
    Smalltalk at: #ShinDDminFuzzingBookShrinker.
    Smalltalk at: #ShinDDminPaperShrinker.
    Smalltalk at: #ShinNautilusShrinker.
    Smalltalk at: #ShinHDDShrinker.
    Smalltalk at: #ShinVulcanShrinker
}.

benchmark := (Smalltalk at: #ShinShrinkingSVGCoverageBenchmark) for: shrinkerClasses.
report := benchmark bench.

report saveAsFile: 'ShinShrinkingSVGCoverageBenchmark.json'