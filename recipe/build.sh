#!/bin/bash

# The regression tests compare against reference tapes generated on x86_64 with a
# 1e-9 relative tolerance. On AArch64, GCC contracts a*b+c into fused multiply-add
# by default, which changes rounding enough to fail those comparisons.
if [[ "${target_platform}" == "linux-aarch64" || "${target_platform}" == "osx-arm64" ]]; then
    export FFLAGS="${FFLAGS} -ffp-contract=off"
fi

cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_BUILD_TYPE=Release -S "${SRC_DIR}" -B build
cmake build -LH
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure
fi
