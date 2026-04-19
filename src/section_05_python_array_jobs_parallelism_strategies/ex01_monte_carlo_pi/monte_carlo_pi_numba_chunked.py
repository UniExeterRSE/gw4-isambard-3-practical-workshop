# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# %% [markdown]
# # Monte Carlo Pi: Numba Chunked
#
# Chunked variant of the scalar Numba kernel intended to expose SIMD
# vectorisation.  Instead of generating one point at a time, each outer
# iteration pre-fills two fixed-size buffers (xs, ys) and then evaluates them in
# a separate inner loop.  The arithmetic inner loop has no RNG-state dependency
# between iterations, so LLVM *should* auto-vectorise it.
#
# On the NVIDIA Grace CPU (Neoverse V2) there are 4 × 128-bit SVE lanes, giving
# 8 float64 values per cycle.  CHUNK = 8 matches this width exactly.
#
# ## Observed results on Grace
#
# Surprisingly, the chunked approach gives only ~5 % over the plain scalar kernel
# (`numba`), and adding `parallel=True` to the chunked wrapper (`numba-chunked-par`)
# gives no further improvement.  By contrast, `parallel=True` on the plain scalar
# prange wrapper (`numba-parallel`) yields ~4× speedup even at a single thread.
#
# The likely cause is that Numba's parfor transformer can vectorise the simple
# scalar kernel body once it is inlined into the parallel wrapper, but the
# `if d == 2` branch and the fixed-size buffer allocations in the chunked kernel
# break the pattern matching that parfor relies on.  The lesson: keep inner
# kernels simple and let `parallel=True` + Numba's LLVM backend do the
# vectorisation, rather than manually restructuring the loop.

# %%
from __future__ import annotations

import numpy as np
from numba import get_num_threads, njit, prange, set_num_threads

from .monte_carlo_pi_common import (
    ExperimentConfig,
    ExperimentResult,
    parse_config,
    print_results,
    summarise_result,
    timed_count,
)

VARIANT_NAME = "numba-chunked"

# 4 × 128-bit SVE lanes × float64 = 8 values per cycle on Grace.
CHUNK = 8


@njit("i8(i8, i8, i8)", cache=True)
def count_hits_kernel_chunked(n: int, d: int, seed: int) -> int:
    np.random.seed(seed)
    hits = np.int64(0)
    if d == 2:
        # Fast path: fixed-size buffers let LLVM vectorise the arithmetic loop.
        xs = np.empty(CHUNK)
        ys = np.empty(CHUNK)
        for _ in range(n // CHUNK):
            for i in range(CHUNK):
                xs[i] = np.random.uniform(-1.0, 1.0)
                ys[i] = np.random.uniform(-1.0, 1.0)
            for i in range(CHUNK):  # no RNG dependency — LLVM vectorises with SVE
                hits += xs[i] * xs[i] + ys[i] * ys[i] <= 1.0
        for _ in range(n % CHUNK):
            x = np.random.uniform(-1.0, 1.0)
            y = np.random.uniform(-1.0, 1.0)
            if x * x + y * y <= 1.0:
                hits += 1
    else:
        for _ in range(n):
            rsq = 0.0
            for _ in range(d):
                x = np.random.uniform(-1.0, 1.0)
                rsq += x * x
            if rsq <= 1.0:
                hits += 1
    return hits


@njit("i8(i8, i8, i8, i8)", cache=True, parallel=True)
def count_hits_parallel_chunked(n: int, d: int, base_seed: int, nthreads: int) -> int:
    """Distribute n samples across nthreads; each thread gets an independent RNG stream."""
    hits = np.int64(0)
    q = n // nthreads
    r = n % nthreads
    for tid in prange(nthreads):
        n_this = q + (1 if tid < r else 0)
        hits += count_hits_kernel_chunked(n_this, d, base_seed + tid)
    return hits


def count_hits(config: ExperimentConfig) -> int:
    return int(count_hits_kernel_chunked(config.n, config.d, config.seed))


def count_hits_par(config: ExperimentConfig) -> int:
    set_num_threads(config.num_threads)
    return int(count_hits_parallel_chunked(config.n, config.d, config.seed, config.num_threads))


def run_experiment(config: ExperimentConfig) -> ExperimentResult:
    hits, elapsed_s = timed_count(count_hits, config)
    return summarise_result(
        variant=VARIANT_NAME,
        hits=hits,
        n=config.n,
        d=config.d,
        elapsed_s=elapsed_s,
        num_threads=1,
        mpi_processes=1,
    )


def run_experiment_parallel(config: ExperimentConfig) -> ExperimentResult:
    hits, elapsed_s = timed_count(count_hits_par, config)
    return summarise_result(
        variant="numba-chunked-par",
        hits=hits,
        n=config.n,
        d=config.d,
        elapsed_s=elapsed_s,
        num_threads=get_num_threads(),
        mpi_processes=1,
    )


def main() -> None:
    config = parse_config("Monte Carlo Pi using a chunked Numba JIT kernel.")
    print_results(config, [run_experiment(config), run_experiment_parallel(config)])


if __name__ == "__main__":
    main()
