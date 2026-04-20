# Exercise 4: Wrong Environment — Wrong Pixi Environment

## The scenario

Your batch script does activate a pixi environment — so Python and most packages load successfully. But you forgot to
specify `--environment hpc`. The default pixi env loads, which ships conda-forge OpenMPI. At runtime, the Cray system
exposes its MPICH via `LD_LIBRARY_PATH`. The two MPI libraries have incompatible ABIs — mpi4py was compiled against
OpenMPI’s ABI but the runtime attempts to use Cray MPICH — and the job crashes.

## Submit it

``` bash
sbatch sbatch_wrong_env_pixi_wrong.sh
```

## What do you see?

Read the output file once the job finishes:

``` bash
cat wrong_env_pixi_wrong_<jobid>.out
```

Look for an error such as:

    OSError: libmpi.so: cannot open shared object file

or an MPI initialisation crash, an `ImportError` from `mpi4py`, or a segfault at MPI startup. The exact message depends
on which MPI symbols the dynamic linker resolves first, but the root cause is the same: ABI mismatch between the
OpenMPI-linked `mpi4py` and the Cray MPICH at runtime.

## Questions

1.  The pixi env *is* loaded — so why does MPI fail?
2.  What is the difference between `pixi shell-hook` and `pixi shell-hook --environment hpc`?
3.  Look at `pyproject.toml` — what does the `[tool.pixi.feature.hpc]` section do?
4.  Why does the Cray system need a special MPI configuration?

## Key insight

The workshop project defines two pixi environments:

| Environment | MPI package                          | Intended use                        |
|-------------|--------------------------------------|-------------------------------------|
| `default`   | `openmpi` (conda-forge)              | Local development, non-MPI testing  |
| `hpc`       | `mpich=external_*` (build stub only) | Running on Cray Isambard 3 with MPI |

In the `hpc` environment, `mpich=external_*` is a link-only stub — it satisfies mpi4py’s compile-time dependency and
ensures mpi4py is built against the MPICH ABI. At job runtime, Cray MPICH is injected via `LD_LIBRARY_PATH`, which
provides a compatible implementation.

Without `--environment hpc`, mpi4py was compiled against OpenMPI’s ABI. The Cray MPICH injected at runtime is MPICH-ABI,
not OpenMPI-ABI — and the mismatch causes a crash at MPI initialisation.

## How to fix

Specify the `hpc` environment explicitly when activating pixi:

``` bash
# shellcheck disable=SC2312
eval "$(pixi shell-hook --environment hpc)"
```

This is the pattern used in all the MPI batch scripts in
`src/section_05_python_array_jobs_parallelism_strategies/ex01_monte_carlo_pi/`.

## Notes

This is a subtle trap: the pixi env loads cleanly, Python starts, and the error only appears when mpi4py tries to
initialise MPI. The symptom can look like a missing library, a segfault, or a cryptic MPI error — none of which
immediately point to “wrong pixi environment”. Checking `pixi env list` or inspecting which `libmpi.so` is on
`LD_LIBRARY_PATH` are useful first steps when debugging MPI failures on Cray systems.

The `external_*` build string in `pixi.lock` is the key indicator that the `hpc` environment is correctly configured.
