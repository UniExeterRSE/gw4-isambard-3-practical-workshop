#!/bin/bash
#SBATCH --job-name=wrong_env_pixi_wrong
#SBATCH --output=wrong_env_pixi_wrong_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:02:00

module reset
module load PrgEnv-gnu

# Note: --environment hpc is intentionally omitted here.
# The default pixi env loads, which has OpenMPI instead of the external MPICH
# stub. At runtime, Cray MPICH is exposed via LD_LIBRARY_PATH, but mpi4py was
# compiled against OpenMPI's ABI — the ABI mismatch causes the job to crash.

# shellcheck disable=SC2312
eval "$(pixi shell-hook)"

# shellcheck disable=SC2154
export LD_LIBRARY_PATH="${MPICH_DIR}/lib-abi-mpich:${LD_LIBRARY_PATH}"

srun python -m section_05_python_array_jobs_parallelism_strategies.ex01_monte_carlo_pi.monte_carlo_pi_mpi_hybrid \
    -d 2 -n 200000
