# PCA sobre resultados de benchmarks

`pca_analysis.py` toma un **dataset crudo** (entradas + `oracleTimeInMicroseconds`) y uno o
varios **resultados de benchmark** (el *baseline*: `{nombreShrinker: [rows]}`), arma la matriz de
variables, calcula un **PCA de K componentes** y deja plots + CSV/JSON listos para análisis
posteriores.

## Instalación

```bash
bash analysis/setup.sh
```

Crea `analysis/.venv` (Python ≥ 3.10, con numpy / pandas / scikit-learn / matplotlib) usando el
Homebrew Python. Ojo: el `/usr/bin/python3` de Xcode (3.9) **no** tiene matplotlib, y el Homebrew
no tiene pandas (la instalación global está bloqueada por PEP 668), por eso el venv es la vía
recomendada.

## Uso

```bash
bash analysis/run_pca.sh \
    --dataset  datasets/raw-dataset-regex-coverage.json \
    --baseline datasets/results/regex/coverage/ShinShrinkingRegexCoverageBenchmark-ShinDDminPaperShrinker.json \
    --components 5 \
    --outdir analysis/out
```

`run_pca.sh` es solo un wrapper que usa `analysis/.venv/bin/python`; equivalente a:

```bash
analysis/.venv/bin/python analysis/pca_analysis.py --dataset ... --baseline ... -k 5
```

Cada corrida es de **un (dataset, shrinker)**: `--dataset` y `--baseline` siempre se pasan
explícitamente y el baseline debe traer una sola clave de shrinker. Los datasets son el corpus
de una librería y un tipo de oráculo distintos (NeoJSONReader, RSSVGPath, RxMatcher, Microdown,
Roassal × coverage/performance), así que **nunca** se mezclan.

Opciones principales:

| Flag | Qué hace |
| --- | --- |
| `--dataset` | Dataset crudo (JSON con `input` y `oracleTimeInMicroseconds`). Obligatorio. |
| `--baseline` | Resultado de benchmark (JSON `{shrinker: [rows]}`) de **un** shrinker. Obligatorio. |
| `-k/--components` | Cantidad de componentes principales (K). Si excede `min(n, p)` se recorta avisando. |
| `--outdir` | Carpeta de salida (default `analysis/out`). |
| `--features` | Variables a usar, separadas por coma. |
| `--log-features` | Variables a aplicar `log1p` antes del PCA (ej. `totalTime,oracleTimeInMicroseconds`). |
| `--no-scale` | No estandarizar (z-score) las variables. |
| `--on-missing` | `drop` (default) o `median` para filas con valores faltantes. |
| `--no-positional-fallback` | Desactiva el match posicional dataset↔baseline. |
| `--min-positional-ratio` | Coincidencia mínima (0-1) para aceptar el match posicional (default `0.6`). |
| `--min-match-ratio` | Fracción mínima de filas del baseline que deben matchear contra el dataset (default `0.5`). Si no se alcanza, el script **aborta**: el dataset y el baseline no se corresponden. |
| `--clusters` | Cantidad de clusters (KMeans) para **agrupar los casos del dataset** en el espacio del PCA. `0` desactiva la clusterización (default `3`). |
| `--cluster-space` | `pca` (default): KMeans sobre los componentes retenidos. `features`: sobre las variables estandarizadas. |
| `--random-state` | Semilla del KMeans para reproducibilidad (default `42`). |

## Variables del PCA

| Variable | Origen | Nota |
| --- | --- | --- |
| `%inputReduction` | baseline | Porcentaje de nodos del AST reducidos (`percentageInputReduced:`). |
| `neededReductions` | baseline | Reducciones aplicadas para llegar al mínimo. |
| `totalTime` | baseline | `Duration` de Pharo parseada a **microsegundos** (`"1 second 137 milliseconds 715 microseconds"`). |
| `failedReductions` | baseline | Reducciones fallidas. |
| `inputSize` | dataset | Largo del input en **caracteres** (no nodos del AST: es una medida distinta a `%inputReduction`). |
| `oracleTimeInMicroseconds` | dataset | Tiempo del oráculo, **solo existe en el dataset** (se hace join por `input`). |

## Join dataset ↔ baseline

El `oracleTimeInMicroseconds` no está en el baseline, así que se une por `input`. El match es, en
orden:

1. **exacto** — `originalInput == input`;
2. **normalizado** — con *unescape* de `\r`, `\t`, `\\`, … y `strip` (algunos baselines guardan el
   input escapado, p. ej. microdown y json);
3. **posicional** — si las filas del resultado siguen el mismo orden que el dataset y coinciden en
   al menos `--min-positional-ratio` de las posiciones.

El script informa cuántos rows se unieron por cada método y cuántas quedaron sin match (se
descartan del PCA).

Si el porcentaje de filas con match queda por debajo de `--min-match-ratio` (50% por default) el
script **aborta antes de calcular el PCA**, porque eso indica que el dataset y el baseline no son
el mismo corpus:

```
ERROR: solo 2/67 filas (3%) del baseline encontraron su entrada en el dataset (umbral: 50%).
       baseline: .../microdown/coverage/ShinShrinkingMicrodownCoverageBenchmark-ShinCDDShrinker.json
       dataset : (ver --dataset)
       match por: exact: 1, normalized: 1
       El dataset y el baseline probablemente no corresponden (cada dataset es el corpus de una
       libreria y un tipo de oráculo).
```

## Clusterización de los casos

Cada punto del PCA es **un caso (input) del dataset**. Con `--clusters N` el script corre KMeans
sobre el espacio del PCA y arma los grupos:

- el scatter `scores_pc1_pc2_*.png` colorea cada caso por cluster, con los centroides marcados;
- `case_clusters_<tag>.csv`: cluster de cada caso (con su input);
- `cluster_profile_<tag>.csv`: media de cada variable (z-score) por cluster;
- `cluster_profile_heatmap_<tag>.png/.pdf`: perfil de los clusters en heatmap;
- `pca_summary_<tag>.json` → `clusters`: miembros de cada cluster, perfil y **silhouette score**.

Ejemplo (regex coverage, 13 casos, 3 clusters):

```
[clusters] 3 clusters sobre 'pca' (silhouette=0.654)
      C0: n= 10 casos [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
      C1: n=  2 casos [12, 13]
      C2: n=  1 casos [1]
```

## Salidas (`analysis/out/`)

| Archivo | Contenido |
| --- | --- |
| `scree_<tag>.png/.pdf` | Varianza explicada por PC (barras) + acumulada, resaltando las K. |
| `scores_pc1_pc2_<tag>.png/.pdf` | Casos del dataset en el plano PC1–PC2, coloreados por cluster (si se clusterizó) + **biplot** con las flechas de las variables. |
| `loadings_heatmap_<tag>.png/.pdf` | Heatmap de loadings (variables × componentes). |
| `scores_heatmap_<tag>.png/.pdf` | Heatmap de scores (tests × componentes). |
| `case_clusters_<tag>.csv` | Cluster asignado a cada caso del dataset. |
| `cluster_profile_<tag>.csv` | Media (z-score) de cada variable por cluster. |
| `cluster_profile_heatmap_<tag>.png/.pdf` | Heatmap del perfil de los clusters. |
| `pca_data_<tag>.csv` | Matriz de variables unida (features + metadatos del join). |
| `pca_scores_<tag>.csv` | Scores de cada muestra en los K componentes. |
| `pca_loadings_<tag>.csv` | Loadings (variables × componentes). |
| `pca_summary_<tag>.json` | Todo lo anterior en JSON: varianza explicada, medias/desviaciones, estadísticas del join, scores y loadings. |

## Permisos compartidos

El repo está configurado para que **todos los usuarios puedan editar todos los archivos**:

- `analysis/run_pca.sh` y `analysis/setup.sh` arrancan con `umask 000`, así que los archivos
  que generan (outputs en `analysis/out/`, el venv) quedan escribibles por cualquiera sin
  necesidad de un `chmod` posterior.
- El repo git tiene `core.sharedRepository=0666`, para que git escriba su index, sus refs y
  sus objetos con permisos abiertos.

No hace falta correr `chmod` a mano después de agregar archivos.
