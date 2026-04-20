#!/bin/bash
#SBATCH --job-name=mc_pi_array
#SBATCH --output=mc_pi_array_%A_%a.out
#SBATCH --array=1-10
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:05:00

NUM_THREADS=4
export NUMBA_NUM_THREADS=${NUM_THREADS}

module reset

# shellcheck disable=SC2312
eval "$(pixi shell-hook --environment hpc)"

monte-carlo-pi-numba-parallel \
    -d 2 \
    -n 1000000 \
    -t ${NUM_THREADS} \
    -s ${SLURM_ARRAY_TASK_ID} \
    --save results/mc_pi_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.txt
