#!/usr/bin/env bash
# Wrapper del analisis PCA: usa el venv de analysis/.venv (ver analysis/setup.sh).
# Uso:  bash analysis/run_pca.sh --dataset <dataset.json> --baseline <baseline.json> -k 5
set -euo pipefail

# Los archivos generados quedan escribibles por cualquier usuario del equipo
# (no hace falta un chmod manual despues).
umask 000

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$HERE/.venv"

if [ ! -x "$VENV/bin/python" ]; then
    echo "El venv no existe. Ejecutá primero:  bash $HERE/setup.sh" >&2
    exit 1
fi

exec "$VENV/bin/python" "$HERE/pca_analysis.py" "$@"
