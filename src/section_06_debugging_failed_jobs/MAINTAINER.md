# Section 6: Maintainer Notes

This document records the steps needed to verify that Section 6 is working correctly on GW4 Isambard 3 (Grace CPU
partition). Each exercise is intentionally broken — the maintainer’s job is to confirm each job fails in the expected
way, understand the fix, and verify the fix restores correct behaviour.

``` sh
cd src/section_06_debugging_failed_jobs
```

## TL;DR — submit all jobs at once

Run from `src/section_06_debugging_failed_jobs/`:

``` sh
# ex01 — oversubscription (binary from sec5/ex02; expected: non-monotonic timings, no error)
(cd ../section_05_python_array_jobs_parallelism_strategies/ex02_monte_carlo_pi_c && bash make.sh)
(cd ex01_oversubscription && sbatch sbatch_oversubscription.sh)

# ex02 — wrong env module (same binary; expected: libgomp.so.1 error on first srun)
(cd ex02_wrong_env_module && sbatch sbatch_wrong_env_module.sh)

# ex03 — pixi missing (expected: command not found)
(cd ex03_wrong_env_pixi_missing && sbatch sbatch_wrong_env_pixi_missing.sh)

# ex04 — pixi wrong env (expected: MPI ABI mismatch / import error)
(cd ex04_wrong_env_pixi_wrong && sbatch sbatch_wrong_env_pixi_wrong.sh)

# ex05 — OOM matmul (binary from sec3/ex04; expected: OUT_OF_MEMORY / exit code 137)
(cd ../section_03_first_batch_job_slurm/ex04_matmul && bash make.sh && cp matmul_naive ../../section_06_debugging_failed_jobs/ex05_oom_matmul/)
(cd ex05_oom_matmul && sbatch sbatch_oom_matmul.sh)

# ex06 — MPI topology (same binary as ex01/ex02; requires 4-node allocation)
(cd ex06_mpi_topology && sbatch sbatch_mpi_topology.sh)

# ex07 — race condition C (build locally; expected: wrong answers, exit code 1)
(cd ex07_race_condition && bash make.sh && sbatch sbatch_race_condition.sh)
# ex07 — race condition Numba (expected: wrong answers from prange race)
(cd ex07_race_condition && sbatch sbatch_race_condition_numba.sh)
```

Then monitor with `squeue --me` and inspect outputs as described in each section below.

## Prerequisites

- `monte_carlo_pi_mpi_hybrid` binary — built from
  `src/section_05_python_array_jobs_parallelism_strategies/ex02_monte_carlo_pi_c/` via `bash make.sh`. The TL;DR block
  above builds it in-place; the Slurm scripts rely on it being on `PATH`, so either add that directory to `PATH` before
  submitting (`export PATH="../section_05_python_array_jobs_parallelism_strategies/ex02_monte_carlo_pi_c:$PATH"` from
  inside this directory) or copy the binary to each exercise directory.
- `matmul_naive` binary — built from `src/section_03_first_batch_job_slurm/ex04_matmul/` via `bash make.sh`. The TL;DR
  block above copies it into `ex05_oom_matmul/` so `./matmul_naive` resolves.
- `race_condition` binary — built locally in `ex07_race_condition/` via `bash make.sh`.
- Pixi `hpc` environment — run `pixi install --environment hpc` once if not already done.

## ex01 — Oversubscription

Submit:

``` sh
cd ex01_oversubscription
sbatch sbatch_oversubscription.sh
```

**Expected failure:** the job completes without error (exit code 0), but the timings across all 15 `(nproc, nthreads)`
configurations are non-monotonic. Configurations with many threads are not faster; the pure-MPI config (144 ranks, 1
thread) may be the fastest. There is no crash — the bug is a performance problem, not a correctness error.

**How to verify it is broken:** check `oversubscription_<JOBID>.out`. Look for the 15 `=== N_PROC=…, N_THREADS=… ===`
blocks. Wall-clock times should not decrease as `nthreads` grows; often the high-thread configs are notably slower.

**The fix (maintainer reference):** the `srun` call is missing `--cpus-per-task="${nthreads}"`. Without it, Slurm does
not reserve the extra cores for each rank, so threads compete for the same hardware threads.

**Verification after fix:** rerun with `--cpus-per-task="${nthreads}"` added to the `srun` line. Timings should be
roughly flat across all 15 configs (total work is constant).

## ex02 — Wrong Environment Module

Submit:

``` sh
cd ex02_wrong_env_module
sbatch sbatch_wrong_env_module.sh
```

**Expected failure:** the job fails on the first `srun` with a shared-library error. Look in
`wrong_env_module_<JOBID>.out` for a line such as:

    error while loading shared libraries: libgomp.so.1: cannot open shared object file: No such file or directory

The job exits with a non-zero code immediately after the first `srun`.

**How to verify it is broken:** `sacct -j <JOBID> --format=State,ExitCode` should show `FAILED` and a non-zero exit
code. The error message about `libgomp` (or similar OpenMP library) should appear in the output file.

**The fix (maintainer reference):** add `module load PrgEnv-gnu` after `module reset`. The script calls `module reset`
but omits the GNU programming environment, so the OpenMP runtime is not in `LD_LIBRARY_PATH`.

**Verification after fix:** all three `=== N_PROC=…, N_THREADS=… ===` blocks complete and print `pi_hat` values close to
3.14159.

## ex03 — Pixi Missing

Submit:

``` sh
cd ex03_wrong_env_pixi_missing
sbatch sbatch_wrong_env_pixi_missing.sh
```

**Expected failure:** the job fails immediately with a command-not-found error. Look in
`wrong_env_pixi_missing_<JOBID>.out` for:

    monte-carlo-pi-summary: command not found

or a similar shell error. The job exits with a non-zero code.

**How to verify it is broken:** the output file should be short (just the error line) and `sacct` should show a non-zero
exit code.

**The fix (maintainer reference):** add `eval "$(pixi shell-hook --environment hpc)"` before the
`monte-carlo-pi-summary` call. The script calls `module reset` but never activates the Pixi environment, so the
entry-point command is not on `PATH`.

**Verification after fix:** the output file prints a Monte Carlo pi results table (all variants, `pi_hat` ≈ 3.14159).

## ex04 — Pixi Wrong Environment

Submit:

``` sh
cd ex04_wrong_env_pixi_wrong
sbatch sbatch_wrong_env_pixi_wrong.sh
```

**Expected failure:** the job fails with an MPI library error. Look in `wrong_env_pixi_wrong_<JOBID>.out` for messages
such as:

    OSError: ...
    ImportError: ...

or an ABI-mismatch traceback in mpi4py. The exact wording varies with the Cray MPICH version, but any `mpi`-related
error on import or init is the expected symptom.

**How to verify it is broken:** a Python traceback should appear and the job exits non-zero. `sacct` shows `FAILED`.

**The fix (maintainer reference):** change `pixi shell-hook` to `pixi shell-hook --environment hpc`. The default Pixi
environment contains OpenMPI; the `hpc` environment links against the external Cray MPICH stub. Using the wrong
environment produces an ABI mismatch at runtime.

**Verification after fix:** `srun python -m …` completes all 4 ranks and prints `pi_hat` ≈ 3.14159.

## ex05 — Out-of-Memory Matmul

Submit:

``` sh
cd ex05_oom_matmul
sbatch sbatch_oom_matmul.sh
```

**Expected failure:** the job is terminated by the OOM killer before producing any output from the program. Check with:

``` sh
sacct -j <JOBID> --format=JobID,State,ExitCode,MaxRSS
```

Expected: `State=OUT_OF_MEMORY` (or `FAILED`), `ExitCode=137`. The output file `oom_matmul_<JOBID>.out` should contain
the `=== Running matmul_naive … ===` header but nothing from the program itself.

**How to verify it is broken:** `sacct` `State` column shows `OUT_OF_MEMORY` or `ExitCode` is `137`.

**The fix (maintainer reference):** any one of the following restores the job:

- Add `#SBATCH --mem=32G` to give the job enough memory.
- Increase `--cpus-per-task` (e.g. to 12) so Slurm proportionally allocates more memory per task.
- Add `#SBATCH --exclusive` to get the full node’s memory.

**Verification after fix:** the output file prints elapsed time and GFLOPS from `matmul_naive`.

## ex06 — MPI Topology

Submit:

``` sh
cd ex06_mpi_topology
sbatch sbatch_mpi_topology.sh
```

Note: this exercise requires a 4-node allocation (`#SBATCH --nodes=4`). Skip verification if only a single node is
available.

**Expected failure:** the job completes but the rank-to-node mapping is uneven. In `mpi_topology_<JOBID>.out`, the
`=== Rank → node mapping ===` section should show some hostnames repeated (2 ranks on one node) while others appear once
(1 rank). The overall wall time is worse than a balanced configuration because the oversubscribed nodes dominate.

**How to verify it is broken:** count the hostnames in the mapping block. With 6 ranks across 4 nodes you expect an
uneven split (e.g. 2 + 2 + 1 + 1). If Slurm happens to spread them evenly, try again or increase node count.

**The fix (maintainer reference):** change `nproc` to a multiple of 4 (e.g. 4, 8, or 12) and add
`--ntasks-per-node=$((ntasks/4))` to the `srun` calls so each node receives the same number of ranks.

**Verification after fix:** the hostname mapping shows each of the 4 nodes appearing the same number of times; timing
improves.

## ex07 — Race Condition

### C binary

Build and submit:

``` sh
cd ex07_race_condition
bash make.sh
sbatch sbatch_race_condition.sh
```

**Expected failure:** in `race_condition_<JOBID>.out`, all three runs print:

    correct?   NO — race condition detected!

and the job exits with code 1. The `got` value differs between runs (non-deterministic).

**How to verify it is broken:** all three `=== Run N ===` blocks should show `NO — race condition detected!` and
differing `got` values.

**The fix (maintainer reference):** add `reduction(+:hits)` to the `#pragma omp parallel for` line in
`race_condition.c`, then rebuild with `bash make.sh`.

**Verification after fix:** all three runs print `correct?   yes` and exit code 0.

### Numba script

Submit:

``` sh
sbatch sbatch_race_condition_numba.sh
```

**Expected failure:** in `race_condition_numba_<JOBID>.out`, at least one of the three runs prints:

    correct? NO — race condition detected!

The `got` value varies across runs (non-deterministic).

**How to verify it is broken:** look for `NO` in any run line. Note: some Numba versions may auto-reduce in simple
cases; if all runs return correct answers, try a newer Numba or a larger N/M (see note in “Common failure modes”).

**The fix (maintainer reference):** replace `counts[0] += row_hits` with a scalar accumulator (`total += row_hits` where
`total` is a plain Python `int64` inside the function, then return it). This removes the shared-array write that causes
the race.

**Verification after fix:** all three runs print `correct? yes` with a consistent `got` value.

## Common failure modes

| Symptom | Likely cause |
|----|----|
| `monte_carlo_pi_mpi_hybrid: command not found` (ex01/ex02/ex06) | Binary not built or not on PATH; build from `src/section_05_python_array_jobs_parallelism_strategies/ex02_monte_carlo_pi_c/` with `bash make.sh` |
| `matmul_naive: command not found` (ex05) | Binary not built or not copied; build from `src/section_03_first_batch_job_slurm/ex04_matmul/` with `bash make.sh` then copy to `ex05_oom_matmul/` |
| ex01 job fails instead of silently underperforming | Binary missing or module not loaded; check the binary is on PATH and `PrgEnv-gnu` is active |
| ex03 job succeeds instead of failing | Shell is sourcing `.envrc` (direnv active in the job); check whether `pixi shell-hook` is being evaluated unexpectedly |
| ex04 fails with wrong error message | Cray MPICH version may vary; look for any `mpi` keyword in the traceback rather than an exact string |
| ex06 shows even rank distribution | Slurm placed 6 ranks evenly — can happen on some scheduler states; try resubmitting or increasing `nproc` to 7 |
| ex07 C gives correct answer on every run | Compiler may have elided the race at high optimisation; try recompiling with `-O0` or increasing N and M |
| ex07 Numba always returns correct answer | Numba version may auto-reduce simple `prange` patterns; try a newer version or larger N/M to expose the race |
