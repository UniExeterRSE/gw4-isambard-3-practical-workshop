#!/bin/bash
#SBATCH --job-name=mc_pi_post_array
#SBATCH --output=mc_pi_post_array_%j.out
#SBATCH --ntasks=1
#SBATCH --time=00:02:00

# shellcheck disable=SC2312
eval "$(pixi shell-hook --environment hpc)"

# ARRAY_JOB_ID is passed via --export by run_array_pipeline.sh
reduce-mc-pi-results results/mc_pi_${ARRAY_JOB_ID}_*.txt
