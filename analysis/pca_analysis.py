#!/usr/bin/env python3
"""PCA sobre resultados de benchmarks de Shin.

Toma un dataset crudo (entradas + `oracleTimeInMicroseconds`) y uno o varios
resultados de benchmark (el "baseline": JSON `{nombreShrinker: [rows]}`), arma la
matriz de variables, calcula un PCA de K componentes y deja plots + CSV/JSON
listos para analisis posteriores.

Variables usadas (por defecto):

    %inputReduction           baseline
    neededReductions          baseline
    totalTime                 baseline (Duration de Pharo -> microsegundos)
    failedReductions          baseline
    inputSize                 dataset (largo del input en caracteres)
    oracleTimeInMicroseconds  dataset (join por `input`)

Ejemplo:

    python3 analysis/pca_analysis.py \
        --dataset datasets/raw-dataset-regex-coverage.json \
        --baseline datasets/results/regex/coverage/ShinShrinkingRegexCoverageBenchmark-ShinDDminPaperShrinker.json \
        --components 5
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any, Sequence

try:
    import matplotlib

    matplotlib.use("Agg")  # headless: genera PNG sin ventana

    import matplotlib.pyplot as plt
    import numpy as np
    import pandas as pd
    from sklearn.cluster import KMeans
    from sklearn.decomposition import PCA
    from sklearn.metrics import silhouette_score
    from sklearn.preprocessing import StandardScaler
except ImportError as error:  # pragma: no cover - solo depende del entorno
    sys.exit(
        f"Faltan dependencias de Python: {error.name} no se pudo importar.\n"
        f"  (estás usando: {sys.executable})\n"
        f"\n"
        f"  Instalalas con:\n"
        f"    bash analysis/setup.sh\n"
        f"\n"
        f"  o manualmente:\n"
        f"    python3 -m venv analysis/.venv\n"
        f"    analysis/.venv/bin/pip install -r analysis/requirements.txt\n"
        f"\n"
        f"  y después corré el análisis con:\n"
        f"    bash analysis/run_pca.sh --dataset <dataset.json> --baseline <baseline.json> -k 5"
    )

# --------------------------------------------------------------------------------------
# Constantes
# --------------------------------------------------------------------------------------

DEFAULT_FEATURES: list[str] = [
    "%inputReduction",
    "neededReductions",
    "totalTime",
    "failedReductions",
    "inputSize",
    "oracleTimeInMicroseconds",
]

FEATURE_UNITS: dict[str, str] = {
    "%inputReduction": "% (nodos del AST)",
    "neededReductions": "reducciones",
    "totalTime": "microsegundos",
    "failedReductions": "reducciones fallidas",
    "inputSize": "caracteres",
    "oracleTimeInMicroseconds": "microsegundos",
}

FEATURE_LABELS: dict[str, str] = {
    "%inputReduction": "%inputReduction",
    "neededReductions": "neededReductions",
    "totalTime": "totalTime (µs)",
    "failedReductions": "failedReductions",
    "inputSize": "inputSize (chars)",
    "oracleTimeInMicroseconds": "oracleTime (µs)",
}

_DURATION_FACTORS: dict[str, float] = {
    "nanosecond": 1e-3,
    "nanoseconds": 1e-3,
    "microsecond": 1.0,
    "microseconds": 1.0,
    "millisecond": 1e3,
    "milliseconds": 1e3,
    "second": 1e6,
    "seconds": 1e6,
    "minute": 6e7,
    "minutes": 6e7,
    "hour": 3.6e9,
    "hours": 3.6e9,
    "day": 8.64e10,
    "days": 8.64e10,
}

_DURATION_RE = re.compile(r"(\d+(?:\.\d+)?)\s*([a-zA-Z]+)")

_ESCAPE_MAP: dict[str, str] = {
    "r": "\r",
    "t": "\t",
    "n": "\n",
    "b": "\b",
    "f": "\f",
    "v": "\v",
    "a": "\a",
    "0": "\0",
    "\\": "\\",
    '"': '"',
    "'": "'",
}


# --------------------------------------------------------------------------------------
# Helpers de parsing
# --------------------------------------------------------------------------------------


def to_float(value: Any) -> float:
    """Convierte a float; devuelve NaN si no es numerico."""
    if value is None:
        return float("nan")
    if isinstance(value, bool):
        return float("nan")
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).strip()
    if not text:
        return float("nan")
    try:
        return float(text)
    except ValueError:
        return float("nan")


def parse_duration_us(value: Any) -> float:
    """Convierte un `Duration` de Pharo ("1 second 137 milliseconds 715 microseconds") a microsegundos."""
    if value is None:
        return float("nan")
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).strip()
    if not text:
        return float("nan")
    total = 0.0
    matched = False
    for amount, unit in _DURATION_RE.findall(text):
        factor = _DURATION_FACTORS.get(unit.lower())
        if factor is None:
            continue
        total += float(amount) * factor
        matched = True
    return total if matched else float("nan")


def unescape(text: str) -> str:
    """Revierte escapes tipo `\\r`, `\\t`, `\\\\` (algunos baselines guardan el input escapado)."""
    if "\\" not in text:
        return text
    out: list[str] = []
    index = 0
    length = len(text)
    while index < length:
        char = text[index]
        if char == "\\" and index + 1 < length:
            nxt = text[index + 1]
            if nxt in _ESCAPE_MAP:
                out.append(_ESCAPE_MAP[nxt])
                index += 2
                continue
        out.append(char)
        index += 1
    return "".join(out)


def normalize(text: str) -> str:
    """Normaliza un input para comparar: unescape + strip."""
    return unescape(text).strip()


# --------------------------------------------------------------------------------------
# Carga de datos y join dataset <-> baseline
# --------------------------------------------------------------------------------------


def load_json(path: Path) -> Any:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def load_dataset(path: Path) -> list[dict[str, Any]]:
    """Dataset crudo: lista de entradas con `input` y (opcionalmente) `oracleTimeInMicroseconds`."""
    data = load_json(path)
    if isinstance(data, dict):
        # Acepta {entrada: {...}} o {shrinkers: [...]}
        if all(isinstance(value, list) for value in data.values()):
            merged: list[dict[str, Any]] = []
            for value in data.values():
                merged.extend(value)
            data = merged
        else:
            data = [dict(value, input=key) for key, value in data.items()]
    if not isinstance(data, list):
        raise SystemExit(f"Dataset invalido (se espera una lista de entradas): {path}")
    return [entry for entry in data if isinstance(entry, dict)]


def load_baseline(path: Path) -> tuple[str, list[dict[str, Any]]]:
    """Baseline de benchmark: `{nombreShrinker: [rows]}` (o una lista de rows).

    Cada corrida es de un unico (dataset, shrinker): si el archivo trae varias claves
    de shrinker se corta, porque(pool)earia shrinking algorithms de datasets distintos.
    """
    data = load_json(path)
    if isinstance(data, list):
        return path.stem, data
    if not isinstance(data, dict):
        raise SystemExit(f"Baseline invalido (se espera un objeto o lista): {path}")
    groups: list[tuple[str, list[dict[str, Any]]]] = [
        (name, rows) for name, rows in data.items() if isinstance(rows, list)
    ]
    if not groups:
        raise SystemExit(f"Baseline sin resultados utilizables: {path}")
    if len(groups) > 1:
        names = ", ".join(name for name, _ in groups)
        raise SystemExit(
            f"El baseline contiene {len(groups)} shrinkers ({names}).\n"
            f"Cada corrida es de un solo (dataset, shrinker): elegí uno."
        )
    return groups[0]


class DatasetIndex:
    """Indice de entradas del dataset por input (exacto y normalizado)."""

    def __init__(self, entries: Sequence[dict[str, Any]]) -> None:
        self.entries = list(entries)
        self.by_raw: dict[str, int] = {}
        self.by_normalized: dict[str, int] = {}
        for position, entry in enumerate(self.entries):
            raw = entry.get("input")
            if not isinstance(raw, str):
                continue
            self.by_raw.setdefault(raw, position)
            self.by_normalized.setdefault(normalize(raw), position)

    def lookup(self, text: str) -> tuple[int | None, str]:
        """Devuelve (posicion en el dataset, metodo de match)."""
        if text in self.by_raw:
            return self.by_raw[text], "exact"
        normalized = normalize(text)
        if normalized in self.by_normalized:
            return self.by_normalized[normalized], "normalized"
        return None, "none"


def match_rows(
    rows: Sequence[dict[str, Any]],
    index: DatasetIndex,
    allow_positional: bool = True,
    min_positional_ratio: float = 0.6,
) -> tuple[dict[int, int], dict[int, str]]:
    """Asocia cada fila del baseline con una entrada del dataset.

    1) match exacto por `input`
    2) match normalizado (unescape + strip)
    3) fallback posicional (las filas del resultado siguen el mismo orden que el dataset)
    """
    matched: dict[int, int] = {}
    method: dict[int, str] = {}

    for position, row in enumerate(rows):
        text = row.get("originalInput")
        if not isinstance(text, str):
            continue
        found, how = index.lookup(text)
        if found is not None:
            matched[position] = found
            method[position] = how

    if allow_positional:
        comparable = min(len(rows), len(index.entries))
        if comparable:
            agreements = 0
            for position in range(comparable):
                result_input = rows[position].get("originalInput")
                dataset_input = index.entries[position].get("input")
                if not isinstance(result_input, str) or not isinstance(dataset_input, str):
                    continue
                if normalize(result_input) == normalize(dataset_input):
                    agreements += 1
            ratio = agreements / comparable
            if ratio >= min_positional_ratio:
                for position in range(comparable):
                    if position not in matched:
                        matched[position] = position
                        method[position] = "positional"

    return matched, method


# --------------------------------------------------------------------------------------
# Matriz de variables
# --------------------------------------------------------------------------------------


def build_frame(
    baseline: tuple[Path, str, list[dict[str, Any]]],
    index: DatasetIndex,
    features: Sequence[str],
    on_missing: str,
    allow_positional: bool,
    min_positional_ratio: float,
    min_match_ratio: float,
) -> tuple[pd.DataFrame, dict[str, Any]]:
    """Arma la matriz de variables uneiendo el baseline (unico shrinker) con el dataset."""
    path, shrinker, rows = baseline
    records: list[dict[str, Any]] = []

    matched, method = match_rows(rows, index, allow_positional, min_positional_ratio)
    by_method: dict[str, int] = {}
    for how in method.values():
        by_method[how] = by_method.get(how, 0) + 1

    total_rows = len(rows)
    match_ratio = (len(matched) / total_rows) if total_rows else 0.0
    match_stats: dict[str, Any] = {
        "match": {
            "baseline": str(path),
            "shrinker": shrinker,
            "rows": total_rows,
            "matched": len(matched),
            "unmatched": total_rows - len(matched),
            "matchRatio": match_ratio,
            "matchMethods": by_method,
        },
        "droppedRows": 0,
        "imputedRows": 0,
        "features": list(features),
    }

    if total_rows and match_ratio < min_match_ratio:
        methods = ", ".join(f"{how}: {count}" for how, count in sorted(by_method.items())) or "ninguno"
        raise SystemExit(
            f"ERROR: solo {len(matched)}/{total_rows} filas ({match_ratio:.0%}) del baseline "
            f"encontraron su entrada en el dataset (umbral: {min_match_ratio:.0%}).\n"
            f"       baseline: {path}\n"
            f"       dataset : (ver --dataset)\n"
            f"       match por: {methods}\n"
            f"       El dataset y el baseline probablemente no corresponden "
            f"(cada dataset es el corpus de una libreria y un tipo de oráculo)."
        )

    for position, row in enumerate(rows):
        if position not in matched:
            continue
        entry = index.entries[matched[position]]
        dataset_input = entry.get("input")
        original_input = row.get("originalInput")
        if isinstance(dataset_input, str):
            input_size = float(len(dataset_input))
        elif isinstance(original_input, str):
            input_size = float(len(original_input))
        else:
            input_size = float("nan")

        records.append(
            {
                "shrinker": shrinker,
                "test": position + 1,
                "sourceFile": path.name,
                "matchMethod": method[position],
                "datasetIndex": matched[position],
                "inputPreview": str(dataset_input if isinstance(dataset_input, str) else (original_input or ""))[:120],
                "%inputReduction": to_float(row.get("%inputReduction")),
                "neededReductions": to_float(row.get("neededReductions")),
                "totalTime": parse_duration_us(row.get("totalTime")),
                "failedReductions": to_float(row.get("failedReductions")),
                "inputSize": input_size,
                "oracleTimeInMicroseconds": to_float(entry.get("oracleTimeInMicroseconds")),
            }
        )

    frame = pd.DataFrame.from_records(records)
    if frame.empty:
        raise SystemExit("No hay filas utilizables: revisa el join entre dataset y baseline.")

    frame = frame[
        ["shrinker", "test", "sourceFile", "matchMethod", "datasetIndex", "inputPreview", *features]
    ].copy()

    # NaNs
    missing_mask = frame[list(features)].isna().any(axis=1)
    missing_rows = int(missing_mask.sum())
    if missing_rows:
        if on_missing == "median":
            imputed = frame[list(features)].apply(
                lambda column: column.fillna(column.median()) if column.notna().any() else column
            )
            frame.loc[:, list(features)] = imputed
            still_missing = frame[list(features)].isna().any(axis=1)
            frame = frame[~still_missing].copy()
            match_stats["imputedRows"] = missing_rows
            match_stats["droppedRows"] = int(still_missing.sum())
        else:
            frame = frame[~missing_mask].copy()
            match_stats["imputedRows"] = 0
            match_stats["droppedRows"] = missing_rows

    # Columnas completamente vacias (no entran al PCA)
    empty_features = [f for f in features if frame[f].isna().all()]
    if empty_features:
        print(f"[AVISO] columnas sin datos, se excluyen del PCA: {', '.join(empty_features)}")
        features = [f for f in features if f not in empty_features]
        frame = frame.drop(columns=empty_features)

    match_stats["features"] = list(features)
    return frame.reset_index(drop=True), match_stats


# --------------------------------------------------------------------------------------
# PCA
# --------------------------------------------------------------------------------------


def run_pca(
    frame: pd.DataFrame,
    features: Sequence[str],
    n_components: int,
    scale: bool,
    log_features: Sequence[str],
) -> tuple[PCA, pd.DataFrame, pd.DataFrame, np.ndarray, dict[str, Any]]:
    matrix = np.array(frame[list(features)].to_numpy(dtype=float), copy=True)

    log_features = [f for f in log_features if f in features]
    transform_info: dict[str, Any] = {}
    for feature in log_features:
        column = matrix[:, features.index(feature)]
        shift = float(np.nanmin(column)) if np.isfinite(column).any() else 0.0
        shift = min(shift, 0.0)
        matrix[:, features.index(feature)] = np.log1p(column - shift)
        transform_info[feature] = {"transform": "log1p", "shift": shift}

    means = matrix.mean(axis=0)
    scales = matrix.std(axis=0, ddof=0)
    if scale:
        matrix = (matrix - means) / np.where(scales == 0, 1.0, scales)
    else:
        matrix = matrix - means

    n_samples, n_features = matrix.shape
    max_components = min(n_samples, n_features)
    if n_components > max_components:
        print(
            f"[AVISO] K={n_components} mayor que min(n={n_samples}, p={n_features})={max_components}; "
            f"se recorta a {max_components}."
        )
        n_components = max_components
    if n_components < 1:
        raise SystemExit("K debe ser >= 1.")

    pca = PCA(n_components=n_components, svd_solver="auto")
    scores = pca.fit_transform(matrix)

    loadings = pd.DataFrame(
        pca.components_.T,
        index=list(features),
        columns=[f"PC{i + 1}" for i in range(n_components)],
    )

    scores_frame = pd.DataFrame(scores, columns=[f"PC{i + 1}" for i in range(n_components)])
    scores_frame.insert(0, "shrinker", frame["shrinker"].to_numpy())
    scores_frame.insert(1, "test", frame["test"].to_numpy())
    scores_frame.insert(2, "sourceFile", frame["sourceFile"].to_numpy())

    meta = {
        "n_samples": int(n_samples),
        "n_features": int(n_features),
        "n_components": int(n_components),
        "scaled": bool(scale),
        "featureMeans": {f: float(means[i]) for i, f in enumerate(features)},
        "featureStdDevs": {f: float(scales[i]) for i, f in enumerate(features)},
        "logTransforms": transform_info,
        "explainedVariance": [float(v) for v in pca.explained_variance_],
        "explainedVarianceRatio": [float(v) for v in pca.explained_variance_ratio_],
        "cumulativeExplainedVariance": [float(v) for v in np.cumsum(pca.explained_variance_ratio_)],
        "singularValues": [float(v) for v in pca.singular_values_],
    }
    return pca, scores_frame, loadings, matrix, meta


# --------------------------------------------------------------------------------------
# Clusterizacion de los casos (sobre el espacio del PCA)
# --------------------------------------------------------------------------------------


def cluster_cases(
    scores: pd.DataFrame,
    scaled_features: np.ndarray,
    frame: pd.DataFrame,
    features: Sequence[str],
    n_clusters: int,
    space: str,
    random_state: int = 42,
) -> dict[str, Any]:
    """Agrupa los casos (una fila = un input del dataset) con KMeans.

    `space='pca'` clusteriza sobre los componentes retenidos; `space='features'` sobre las
    variables estandarizadas.
    """
    if n_clusters <= 0:
        return {}
    n_samples = len(scores)
    if n_clusters >= n_samples:
        raise SystemExit(
            f"--clusters {n_clusters} no puede ser >= al numero de casos ({n_samples})."
        )

    pc_columns = [c for c in scores.columns if c.startswith("PC")]
    matrix = scores[pc_columns].to_numpy(dtype=float) if space == "pca" else scaled_features

    kmeans = KMeans(n_clusters=n_clusters, n_init=10, random_state=random_state)
    labels = kmeans.fit_predict(matrix)

    silhouette = None
    if 1 < n_clusters < n_samples:
        silhouette = float(silhouette_score(matrix, labels))

    # Perfil de cada cluster: media de las variables estandarizadas (z-scores)
    profile_rows = []
    for cluster in range(n_clusters):
        mask = labels == cluster
        profile_rows.append(
            {
                "cluster": f"C{cluster}",
                "size": int(mask.sum()),
                **{feature: float(scaled_features[mask, index].mean()) for index, feature in enumerate(features)},
            }
        )
    profile = pd.DataFrame.from_records(profile_rows).set_index("cluster")

    # Centroides en el plano PC1-PC2 (para el plot)
    centers = []
    for cluster in range(n_clusters):
        mask = labels == cluster
        centers.append(
            (
                float(scores.loc[mask, "PC1"].mean()),
                float(scores.loc[mask, "PC2"].mean()) if "PC2" in scores.columns else 0.0,
            )
        )

    members = []
    for cluster in range(n_clusters):
        mask = labels == cluster
        members.append(
            {
                "cluster": f"C{cluster}",
                "size": int(mask.sum()),
                "tests": [int(value) for value in frame.loc[mask, "test"].tolist()],
                "inputs": [str(value)[:80] for value in frame.loc[mask, "inputPreview"].tolist()]
                if "inputPreview" in frame.columns
                else [],
                "profile": {
                    feature: float(profile.loc[f"C{cluster}", feature]) for feature in features
                },
            }
        )

    return {
        "nClusters": int(n_clusters),
        "space": space,
        "silhouette": silhouette,
        "labels": [int(label) for label in labels],
        "centers": centers,
        "profile": profile,
        "members": members,
    }


# --------------------------------------------------------------------------------------
# Plots
# --------------------------------------------------------------------------------------


def plot_scree(meta: dict[str, Any], outdir: Path, tag: str) -> None:
    ratios = np.asarray(meta["explainedVarianceRatio"]) * 100.0
    cumulative = np.asarray(meta["cumulativeExplainedVariance"]) * 100.0
    positions = np.arange(1, len(ratios) + 1)
    k = meta["n_components"]

    fig, ax = plt.subplots(figsize=(8, 4.6))
    colors = ["#1f77b4" if i < k else "#c9c9c9" for i in range(len(ratios))]
    ax.bar(positions, ratios, color=colors, edgecolor="none", label=f"PC1..PC{k}")
    ax.plot(positions, cumulative, marker="o", color="#d62728", linewidth=1.6, label="Acumulada")
    ax.set_xticks(positions)
    ax.set_xlabel("Componente principal")
    ax.set_ylabel("Varianza explicada (%)")
    ax.set_title(f"Scree plot - {tag}")
    ax.set_ylim(0, 105)
    ax.grid(axis="y", alpha=0.3)
    ax.legend(frameon=False)
    fig.tight_layout()
    fig.savefig(outdir / f"scree_{tag}.png", dpi=150)
    fig.savefig(outdir / f"scree_{tag}.pdf")
    plt.close(fig)


def plot_scores(
    scores: pd.DataFrame,
    loadings: pd.DataFrame,
    meta: dict[str, Any],
    outdir: Path,
    tag: str,
    clusters: dict[str, Any] | None = None,
) -> None:
    components = min(2, meta["n_components"])
    if components < 2:
        print("[AVISO] con K=1 no hay scatter 2D; se omite el plot de scores.")
        return

    x = scores["PC1"].to_numpy()
    y = scores["PC2"].to_numpy()

    fig, ax = plt.subplots(figsize=(8.5, 6.5))

    if clusters:
        labels = np.asarray(clusters["labels"])
        palette = plt.get_cmap("tab10")
        for number, cluster in enumerate(sorted(set(labels.tolist()))):
            mask = labels == cluster
            ax.scatter(
                x[mask],
                y[mask],
                s=90,
                color=palette(number % 10),
                edgecolor="white",
                linewidth=0.9,
                label=f"C{cluster} (n={int(mask.sum())})",
                zorder=3,
            )
        for number, (center_x, center_y) in enumerate(clusters["centers"]):
            ax.scatter(
                [center_x],
                [center_y],
                s=260,
                marker="X",
                color=palette(number % 10),
                edgecolor="black",
                linewidth=1.0,
                zorder=4,
            )
            ax.annotate(
                f"C{number}",
                (center_x, center_y),
                textcoords="offset points",
                xytext=(0, -16),
                fontsize=10,
                fontweight="bold",
                ha="center",
                zorder=5,
            )
    else:
        ax.scatter(x, y, s=70, color="#1f77b4", edgecolor="white", linewidth=0.8, zorder=3)

    # Biplot: flechas con los loadings (correlaciones variable <-> PC)
    for feature in loadings.index:
        load_x = float(loadings.loc[feature, "PC1"])
        load_y = float(loadings.loc[feature, "PC2"])
        ax.annotate(
            "",
            xy=(load_x, load_y),
            xytext=(0, 0),
            arrowprops={"arrowstyle": "->", "color": "#555555", "linewidth": 1.1, "alpha": 0.9},
            zorder=2,
        )
        ax.text(
            load_x * 1.08,
            load_y * 1.08,
            FEATURE_LABELS.get(feature, feature),
            color="#333333",
            fontsize=8,
            ha="center",
            va="center",
        )

    for position in range(len(x)):
        ax.annotate(
            str(int(scores["test"].iloc[position])),
            (x[position], y[position]),
            textcoords="offset points",
            xytext=(5, 5),
            fontsize=7,
            color="#444444",
        )

    ax.axhline(0, color="#cccccc", linewidth=0.8, zorder=1)
    ax.axvline(0, color="#cccccc", linewidth=0.8, zorder=1)

    ratio1 = meta["explainedVarianceRatio"][0] * 100
    ratio2 = meta["explainedVarianceRatio"][1] * 100
    ax.set_xlabel(f"PC1 ({ratio1:.1f}% var. explicada)")
    ax.set_ylabel(f"PC2 ({ratio2:.1f}% var. explicada)")
    if clusters:
        ax.set_title(f"Casos del dataset en el plano PCA, agrupados en {clusters['nClusters']} clusters - {tag}")
    else:
        ax.set_title(f"Scores PCA + biplot - {tag}")

    all_x = list(x) + [0.0] + [float(loadings.loc[f, "PC1"]) for f in loadings.index]
    all_y = list(y) + [0.0] + [float(loadings.loc[f, "PC2"]) for f in loadings.index]
    x_min, x_max = min(all_x), max(all_x)
    y_min, y_max = min(all_y), max(all_y)
    margin_x = 0.18 * max(x_max - x_min, 1e-9)
    margin_y = 0.18 * max(y_max - y_min, 1e-9)
    ax.set_xlim(x_min - margin_x, x_max + margin_x)
    ax.set_ylim(y_min - margin_y, y_max + margin_y)
    ax.grid(alpha=0.25, zorder=0)
    if clusters:
        ax.legend(frameon=False, fontsize=8, loc="best")

    fig.tight_layout()
    fig.savefig(outdir / f"scores_pc1_pc2_{tag}.png", dpi=150)
    fig.savefig(outdir / f"scores_pc1_pc2_{tag}.pdf")
    plt.close(fig)


def plot_heatmap(
    data: pd.DataFrame,
    outdir: Path,
    filename: str,
    title: str,
    value_format: str = "{:.2f}",
    row_labels: Sequence[str] | None = None,
) -> None:
    matrix = data.to_numpy(dtype=float)
    height = max(3.0, 0.35 * matrix.shape[0] + 2.0)
    width = max(4.5, 1.4 * matrix.shape[1] + 2.5)
    fig, ax = plt.subplots(figsize=(width, height))

    limit = float(np.nanmax(np.abs(matrix))) if matrix.size else 1.0
    limit = limit if limit > 0 else 1.0
    image = ax.imshow(matrix, cmap="RdBu_r", vmin=-limit, vmax=limit, aspect="auto")

    ax.set_xticks(np.arange(matrix.shape[1]))
    ax.set_xticklabels(list(data.columns), rotation=45, ha="right")
    ax.set_yticks(np.arange(matrix.shape[0]))
    ax.set_yticklabels(list(row_labels if row_labels is not None else data.index))

    for i in range(matrix.shape[0]):
        for j in range(matrix.shape[1]):
            value = matrix[i, j]
            if not np.isfinite(value):
                continue
            color = "white" if abs(value) > 0.6 * limit else "#222222"
            ax.text(j, i, value_format.format(value), ha="center", va="center", fontsize=8, color=color)

    ax.set_title(title)
    fig.colorbar(image, ax=ax, shrink=0.85)
    fig.tight_layout()
    fig.savefig(outdir / filename, dpi=150)
    fig.savefig(outdir / filename.replace(".png", ".pdf"))
    plt.close(fig)


# --------------------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Calcula y plottea un PCA sobre resultados de benchmarks de Shin.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--dataset",
        required=True,
        type=Path,
        help="Dataset crudo (JSON con 'input' y 'oracleTimeInMicroseconds').",
    )
    parser.add_argument(
        "--baseline",
        required=True,
        action="append",
        type=Path,
        help="Resultado de benchmark (JSON {shrinker: [rows]}) de un unico shrinker. "
        "Cada corrida es de un (dataset, shrinker).",
    )
    parser.add_argument(
        "-k",
        "--components",
        type=int,
        default=2,
        help="Cantidad de componentes principales a calcular (K).",
    )
    parser.add_argument(
        "--outdir",
        type=Path,
        default=Path("analysis/out"),
        help="Carpeta donde se guardan PNG/PDF/CSV/JSON.",
    )
    parser.add_argument(
        "--features",
        default=",".join(DEFAULT_FEATURES),
        help="Variables a usar, separadas por coma.",
    )
    parser.add_argument(
        "--log-features",
        default="",
        help="Variables a transformar con log1p antes del PCA (ej: totalTime,oracleTimeInMicroseconds).",
    )
    parser.add_argument(
        "--no-scale",
        action="store_true",
        help="No estandarizar (z-score) las variables antes del PCA.",
    )
    parser.add_argument(
        "--on-missing",
        choices=["drop", "median"],
        default="drop",
        help="Que hacer con filas con valores faltantes.",
    )
    parser.add_argument(
        "--no-positional-fallback",
        action="store_true",
        help="Desactiva el match posicional (filas del resultado en el mismo orden que el dataset).",
    )
    parser.add_argument(
        "--min-positional-ratio",
        type=float,
        default=0.6,
        help="Coincidencia minima (0-1) para aceptar el match posicional.",
    )
    parser.add_argument(
        "--min-match-ratio",
        type=float,
        default=0.5,
        help="Fraccion minima de filas del baseline que deben matchear contra el dataset; "
        "si no se alcanza, el script aborta (el dataset y el baseline no se corresponden).",
    )
    parser.add_argument(
        "--clusters",
        type=int,
        default=3,
        help="Cantidad de clusters (KMeans) para agrupar los casos del dataset en el espacio del PCA. "
        "0 desactiva la clusterizacion.",
    )
    parser.add_argument(
        "--cluster-space",
        choices=["pca", "features"],
        default="pca",
        help="Espacio donde se calcula el KMeans: 'pca' (componentes retenidos) o "
        "'features' (variables estandarizadas).",
    )
    parser.add_argument(
        "--random-state",
        type=int,
        default=42,
        help="Semilla del KMeans (para reproducibilidad).",
    )
    parser.add_argument(
        "--tag",
        default=None,
        help="Sufijo de los archivos generados (por defecto se deriva del baseline).",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)

    features = [f.strip() for f in args.features.split(",") if f.strip()]
    unknown = [f for f in features if f not in DEFAULT_FEATURES]
    if unknown:
        raise SystemExit(f"Variables desconocidas: {', '.join(unknown)}")
    log_features = [f.strip() for f in args.log_features.split(",") if f.strip()]

    if len(args.baseline) > 1:
        raise SystemExit(
            "Se permite un solo --baseline (cada corrida es de un dataset + un shrinker). "
            "Para comparar shrinkers, corré el script de nuevo con otro --outdir/--tag."
        )

    for path in [args.dataset, *args.baseline]:
        if not path.exists():
            raise SystemExit(f"No existe el archivo: {path}")

    outdir = args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    dataset_entries = load_dataset(args.dataset)
    index = DatasetIndex(dataset_entries)
    print(f"[dataset] {args.dataset}: {len(dataset_entries)} entradas")

    shrinker, rows = load_baseline(args.baseline[0])
    print(f"[baseline] {args.baseline[0].name} :: {shrinker}: {len(rows)} filas")

    frame, match_stats = build_frame(
        (args.baseline[0], shrinker, rows),
        index,
        features,
        args.on_missing,
        not args.no_positional_fallback,
        args.min_positional_ratio,
        args.min_match_ratio,
    )
    match = match_stats["match"]
    print(
        f"[join] {match['matched']}/{match['rows']} filas con match "
        f"({match['matchRatio']:.0%}, metodos={match['matchMethods']})"
    )
    if match_stats["droppedRows"]:
        print(f"[join] {match_stats['droppedRows']} filas descartadas por valores faltantes")
    if match_stats["imputedRows"]:
        print(f"[join] {match_stats['imputedRows']} filas imputadas con la mediana")

    pca, scores, loadings, scaled_matrix, meta = run_pca(
        frame,
        features,
        args.components,
        not args.no_scale,
        log_features,
    )

    tag = args.tag or args.baseline[0].stem.replace("ShinShrinking", "").replace("Benchmark-", "")
    tag = re.sub(r"[^A-Za-z0-9_.-]+", "_", tag)

    # Clusterizacion de los casos del dataset en el espacio del PCA
    clusters = cluster_cases(
        scores,
        scaled_matrix,
        frame,
        features,
        args.clusters,
        args.cluster_space,
        args.random_state,
    )
    if clusters:
        scores.insert(3, "cluster", [f"C{label}" for label in clusters["labels"]])
        frame = frame.assign(cluster=[f"C{label}" for label in clusters["labels"]])
        profile = clusters["profile"]
        profile.to_csv(outdir / f"cluster_profile_{tag}.csv")
        clusters_frame = pd.DataFrame(
            {
                "test": frame["test"].to_numpy(),
                "cluster": frame["cluster"].to_numpy(),
                "input": frame["inputPreview"].to_numpy(),
            }
        )
        clusters_frame.to_csv(outdir / f"case_clusters_{tag}.csv", index=False)

    frame.to_csv(outdir / f"pca_data_{tag}.csv", index=False)
    scores.to_csv(outdir / f"pca_scores_{tag}.csv", index=False)
    loadings.to_csv(outdir / f"pca_loadings_{tag}.csv")

    plot_scree(meta, outdir, tag)
    plot_scores(scores, loadings, meta, outdir, tag, clusters)
    plot_heatmap(
        loadings,
        outdir,
        f"loadings_heatmap_{tag}.png",
        f"Loadings (variables x componentes) - {tag}",
    )
    plot_heatmap(
        scores[[c for c in scores.columns if c.startswith("PC")]],
        outdir,
        f"scores_heatmap_{tag}.png",
        f"Scores (tests x componentes) - {tag}",
        row_labels=[f"#{r.test}" for r in scores.itertuples()],
    )
    if clusters:
        plot_heatmap(
            clusters["profile"].drop(columns=["size"]),
            outdir,
            f"cluster_profile_heatmap_{tag}.png",
            f"Perfil de los clusters (z-scores de cada variable) - {tag}",
            row_labels=[f"{name} (n={int(size)})" for name, size in clusters["profile"]["size"].items()],
        )

    summary = {
        "dataset": str(args.dataset),
        "baseline": str(args.baseline[0]),
        "tag": tag,
        "features": features,
        "featureUnits": {f: FEATURE_UNITS.get(f, "") for f in features},
        "matchStats": match_stats,
        "pca": meta,
        "clusters": (
            {
                "nClusters": clusters["nClusters"],
                "space": clusters["space"],
                "silhouette": clusters["silhouette"],
                "members": clusters["members"],
            }
            if clusters
            else None
        ),
        "loadings": loadings.to_dict(orient="index"),
        "scores": scores.to_dict(orient="records"),
        "outputs": sorted(p.name for p in outdir.glob(f"*{tag}*")),
    }
    with (outdir / f"pca_summary_{tag}.json").open("w", encoding="utf-8") as handle:
        json.dump(summary, handle, indent=2, ensure_ascii=False)

    print(f"[pca] K={meta['n_components']} sobre {meta['n_samples']} muestras x {meta['n_features']} variables")
    for i, ratio in enumerate(meta["explainedVarianceRatio"], start=1):
        print(f"      PC{i}: {ratio * 100:6.2f}%  (acumulado {meta['cumulativeExplainedVariance'][i - 1] * 100:6.2f}%)")
    if clusters:
        silhouette = clusters["silhouette"]
        silhouette_text = f"{silhouette:.3f}" if silhouette is not None else "n/d"
        print(
            f"[clusters] {clusters['nClusters']} clusters sobre '{clusters['space']}' "
            f"(silhouette={silhouette_text})"
        )
        for member in clusters["members"]:
            print(f"      {member['cluster']}: n={member['size']:>3} casos {member['tests']}")
    print(f"[out] {outdir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
