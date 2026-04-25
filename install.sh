#!/usr/bin/env bash
set -e

# VARS
SRC="$HOME/nest"
INSTALL_PREFIX="$SRC"
BUILD_DIR="$SRC/nest-build"
REPO_URL="https://github.com/nest/nest-simulator.git"

# DEPENDENCIES
echo "[1/6] Installing system dependencies..."
sudo apt update
sudo apt install -y \
  build-essential cmake git \
  libgsl-dev \
  libopenmpi-dev openmpi-bin \
  python3-dev python3-venv python3-pip \
  libreadline-dev libncurses-dev \
  libboost-all-dev


echo "[2/6] Setting up Python environment..."
python3 -m venv "$SRC/nest-venv"
source "$SRC/nest-venv/bin/activate"

pip install --upgrade pip
pip install cython numpy scipy matplotlib

echo "[3/6] Cloning NEST..."
cd "$SRC"
if [ ! -d "nest-simulator" ]; then
  git clone "$REPO_URL"
fi

echo "[4/6] Configuring build..."
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cmake ../nest-simulator \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
  -Dwith-python=ON \
  -Dwith-mpi=ON

echo "[5/6] Building..."
make -j$(nproc)

echo "[6/6] Installing..."
make install

echo "Updating environment variables..."

BASHRC="$HOME/.bashrc"

add_to_bashrc() {
  local line="$1"
  grep -qxF "$line" "$BASHRC" || echo "$line" >> "$BASHRC"
}

add_to_bashrc "export PATH=\"$INSTALL_PREFIX/bin:\$PATH\""
add_to_bashrc "export LD_LIBRARY_PATH=\"$INSTALL_PREFIX/lib:\$LD_LIBRARY_PATH\""

PYTHON_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
add_to_bashrc "export PYTHONPATH=\"$INSTALL_PREFIX/lib/python${PYTHON_VER}/site-packages:\$PYTHONPATH\""

echo "Done. Restart your shell or run: source ~/.bashrc"
echo "Test with: python3 -c 'import nest; print(nest.__version__)'"
