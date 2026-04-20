# Slurm Job Array

A Slurm job array submits many independent tasks with a single `sbatch` command. Each task gets its own
`$SLURM_ARRAY_TASK_ID`, which is used as a random seed so every run produces independent Monte Carlo samples.

## Pipeline

Three batch scripts chained with `--dependency=afterok`:

    sbatch_pre_array.sh  →  sbatch_monte_carlo_pi_array.sh  →  sbatch_post_array.sh

Run the whole pipeline in one command:

``` bash
bash run_array_pipeline.sh
```

Or step by step to see what the runner does:

``` bash
PRE=$(sbatch --parsable sbatch_pre_array.sh)
MAIN=$(sbatch --parsable --dependency=afterok:${PRE} sbatch_monte_carlo_pi_array.sh)
sbatch --dependency=afterok:${MAIN} --export=ALL,ARRAY_JOB_ID=${MAIN} sbatch_post_array.sh
```

## Monitor

``` bash
squeue --me                       # see <jobid>_1 ... <jobid>_10
sacct -j <MAIN> --format=JobID,State,ExitCode,Elapsed
```

Each array task writes `results/mc_pi_<jobid>_<taskid>.txt` (`hits n` on one line). The post job reduces them
automatically.

## Reduce manually

``` bash
reduce-mc-pi-results results/mc_pi_<jobid>_*.txt
```

## Throttling

Large arrays can strain the scheduler. Cap the number of concurrently running tasks with `%M`:

    #SBATCH --array=1-1000%50    # 1000 tasks, at most 50 running at once

Open `sbatch_monte_carlo_pi_array.sh` and experiment with the array size and seed range.
