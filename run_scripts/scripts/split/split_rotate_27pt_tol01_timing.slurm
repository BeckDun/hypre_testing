#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=pcg_cpu_gpu_rotate
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4
#SBATCH --array=0-6

module list

cd $HOME/hypre/src/build/test

# Define matrix sizes to test
declare -a SIZES=("64 64 64" "128 128 128" "256 256 256" "320 320 320" "384 384 384" "448 448 448" "512 512 512")

# Get the matrix size for this array job
MATRIX_SIZE=${SIZES[$SLURM_ARRAY_TASK_ID]}

# Create output directory for results
mkdir -p $HOME/hypre_results

# Run the solver with the specified matrix size
echo "Running ij solver with matrix size: $MATRIX_SIZE"
srun --cpu-bind=cores --gpu-bind=closest \
     -n 4 -G 4 \
     ./ij \
    -dbg 1 \
    -poutdat 3 \
    -solver 1 \
    -rotate 0.01 \
    -27pt \
    -n $MATRIX_SIZE \
    -P 2 2 1 \
    -setup_host_solve_device > $HOME/hypre_results/split_output_${SLURM_ARRAY_TASK_ID}.log 2>&1

echo "Job completed for matrix size: $MATRIX_SIZE"