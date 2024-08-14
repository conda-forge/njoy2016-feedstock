#!/bin/bash

cmake ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_BUILD_TYPE=Release
make -j "${CPU_COUNT}"
make install
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make test
fi
