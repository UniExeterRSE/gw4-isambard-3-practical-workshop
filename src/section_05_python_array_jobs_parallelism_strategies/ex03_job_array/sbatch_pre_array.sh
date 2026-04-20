#!/bin/bash
#SBATCH --job-name=mc_pi_pre_array
#SBATCH --output=mc_pi_pre_array_%j.out
#SBATCH --ntasks=1
#SBATCH --time=00:01:00

mkdir -p results
echo "Results directory ready."
