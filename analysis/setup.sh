#!/usr/bin/env bash
# Crea el venv de Python para el analisis PCA y instala sus dependencias.
# Uso:  bash analysis/setup.sh
set -euo pipefail

# El venv queda escribible por cualquier usuario del equipo (no hace falta
# un chmod manual despues).
umask 000

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$HERE/.venv"

# Homebrew primero: el python de Xcode (/usr/bin/python3) no tiene numpy/matplotlib.
PYTHON=""
for candidate in /opt/homebrew/bin/python3 python3.13 python3.12 python3; do
    if command -v "$candidate" >/dev/null 2>&1; then
        if "$candidate" -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null; then
            PYTHON="$candidate"
            break
        fi
    fi
done

if [ -z "$PYTHON" ]; then
    echo "ERROR: no encontre un Python >= 3.10 (necesario para numpy/pandas/scikit-learn)." >&2
    echo "       Instalalo con 'brew install python' o desde python.org." >&2
    exit 1
fi

echo "[setup] interprete: $PYTHON ($("$PYTHON" -V 2>&1))"

if [ ! -d "$VENV" ]; then
    echo "[setup] creando venv en $VENV"
    "$PYTHON" -m venv "$VENV"
else
    echo "[setup] reusando venv $VENV"
fi

"$VENV/bin/python" -m pip install --quiet --upgrade pip
"$VENV/bin/python" -m pip install --quiet -r "$HERE/requirements.txt"

echo "[setup] listo. Verificacion:"
"$VENV/bin/python" - <<'PY'
import matplotlib, numpy, pandas, sklearn
print(f"  numpy {numpy.__version__} | pandas {pandas.__version__} | "
      f"scikit-learn {sklearn.__version__} | matplotlib {matplotlib.__version__}")
PY
echo
echo "[setup] corré el analisis con:"
echo "  $HERE/run_pca.sh --dataset <dataset.json> --baseline <baseline.json> -k 5"
