# Section 5: Python Example + Array Jobs + Parallelism Strategies

**Section type: Active.** The section has three parts (A, B, C), each following the Present → Demo → Hands-on →
Discussion rhythm. Part C (parallelism strategies comparison) is more conceptual and may be lighter on hands-on time.

This section covers a prepared Monte Carlo Pi example, ways to run repeated simulations, and a stretch path into MPI
execution.

## Exercises

- **ex01** `ex01_monte_carlo_pi/` → `01-monte-carlo-pi.md` — Python Monte Carlo Pi: pure Python, NumPy, Numba, Numba
  parallel, and hybrid MPI + threaded Numba variants side by side
- **ex02** `ex02_monte_carlo_pi_c/` → `02-monte-carlo-pi-c.md` — C MPI+OpenMP stretch: same problem in a compiled
  language; build with `bash make.sh`, then `sbatch sbatch_monte_carlo_pi_mpi_hybrid_c.sh`

## Files

- `ex01_monte_carlo_pi/01-monte-carlo-pi.md` — walkthrough for the Python Monte Carlo Pi examples
- `ex01_monte_carlo_pi/monte_carlo_pi_pure_python.py` — pure Python baseline
- `ex01_monte_carlo_pi/monte_carlo_pi_numpy.py` — NumPy vectorised variant
- `ex01_monte_carlo_pi/monte_carlo_pi_numba.py` — Numba JIT variant
- `ex01_monte_carlo_pi/monte_carlo_pi_numba_parallel.py` — Numba `parallel=True` and `prange` variant
- `ex01_monte_carlo_pi/monte_carlo_pi_mpi_hybrid.py` — hybrid MPI + threaded Numba variant; `-n` is samples **per
  thread** (total = MPI ranks × threads × n)
- `ex01_monte_carlo_pi/monte_carlo_pi_parallel_strategies.py` — summary runner importing the non-MPI variants, with the
  hybrid result appended when launched under `mpiexec`
- `ex01_monte_carlo_pi/monte_carlo_pi_common.py` — shared maths, CLI parsing, and result formatting
- `ex01_monte_carlo_pi/hybrid-MPI.md` — thread-related environment variables for hybrid runs
- `ex02_monte_carlo_pi_c/02-monte-carlo-pi-c.md` — C MPI+OpenMP stretch walkthrough; `-n` is also samples per thread
- `ex02_monte_carlo_pi_c/monte_carlo_pi_mpi_hybrid.c` — C source
- `__init__.py` — makes the section importable as `section_05_python_array_jobs_parallelism_strategies`
- `../../pyproject.toml` — root Python package metadata plus Pixi workspace configuration
