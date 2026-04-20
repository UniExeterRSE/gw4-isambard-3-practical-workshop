#!/bin/bash
# Submit the job-array pipeline: pre -> array -> post.
# Run on the login node: bash run_array_pipeline.sh
# Each stage only starts when the previous one succeeds (afterok).
set -euo pipefail

PRE_JOB_ID=$(sbatch --parsable sbatch_pre_array.sh)
echo "Pre:  ${PRE_JOB_ID}"

MAIN_JOB_ID=$(sbatch --parsable \
    --dependency=afterok:${PRE_JOB_ID} \
    sbatch_monte_carlo_pi_array.sh)
echo "Main: ${MAIN_JOB_ID} (array -- waits for ${PRE_JOB_ID})"

POST_JOB_ID=$(sbatch --parsable \
    --dependency=afterok:${MAIN_JOB_ID} \
    --export=ALL,ARRAY_JOB_ID=${MAIN_JOB_ID} \
    sbatch_post_array.sh)
echo "Post: ${POST_JOB_ID} (waits for all array tasks in ${MAIN_JOB_ID})"

echo
echo "Pipeline queued. Monitor with: squeue --me"
