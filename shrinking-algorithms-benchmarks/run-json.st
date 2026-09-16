| shrinkerClasses benchmark report |

Metacello new
    baseline: 'Shin';
    repository: 'github://FedeLoch/Shin:main';
	onConflictUseIncoming;
    load.

Metacello new
    baseline: 'Ume';
    repository: 'github://FedeLoch/Ume:main';
	onConflictUseIncoming;
    load.

shrinkerClasses := {
    Smalltalk at: #ShinDDminFuzzingBookShrinker.
    Smalltalk at: #ShinDDminPaperShrinker.
    Smalltalk at: #ShinNautilusShrinker.
    Smalltalk at: #ShinHDDShrinker.
    Smalltalk at: #ShinVulcanShrinker.
    Smalltalk at: #ShinGRABRShrinker.
}.

shrinkerClasses do: [ :aShrinkerClass |
    benchmark := (Smalltalk at: #ShinShrinkingJSONCoverageBenchmark) for: {aShrinkerClass}.
    report := benchmark bench.

    report saveAsFile: 'ShinShrinkingJSONCoverageBenchmark-', aShrinkerClass name, '.json'
].