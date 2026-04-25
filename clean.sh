#!/usr/bin/env bash
set -e

SRC="$HOME/nest"
INSTALL_PREFIX="$SRC"
BASHRC="$HOME/.bashrc"

echo "This will remove:"
echo "  - $SRC/nest-simulator  (source)"
echo "  - $SRC/nest-build      (build artifacts)"
echo "  - $SRC/nest-venv       (build-time venv)"
echo "  - $INSTALL_PREFIX/bin, lib, include, share  (installed files)"
echo "  - NEST entries in $BASHRC"
echo ""
read -p "Continue? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

echo "Removing source, build, and venv..."
rm -rf "$SRC/nest-simulator" "$SRC/nest-build" "$SRC/nest-venv"

echo "Removing installed files..."
rm -rf "$INSTALL_PREFIX/bin" "$INSTALL_PREFIX/lib" \
       "$INSTALL_PREFIX/include" "$INSTALL_PREFIX/share"

echo "Cleaning up $BASHRC..."
PYTHON_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
sed -i "\|export PATH=\"$INSTALL_PREFIX/bin:|d" "$BASHRC"
sed -i "\|export LD_LIBRARY_PATH=\"$INSTALL_PREFIX/lib:|d" "$BASHRC"
sed -i "\|export PYTHONPATH=\"$INSTALL_PREFIX/lib/python${PYTHON_VER}|d" "$BASHRC"

echo "Done. Run 'source ~/.bashrc' to apply changes to your current shell."
