#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=64
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=hypre_ij_array
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=1
#SBATCH --array=0-6
#SBATCH --output=$HOME/hypre_testing/run_scripts/scripts/cpu/openmp_results/slurm_%A_%a.log

module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1
module list
export HYPRE_EXEC_POLICY=HOST
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

cd $HOME/hypre_testing/src/build/test

mkdir -p $HOME/hypre_testing/run_scripts/scripts/cpu/openmp_results

# Define problem sizes
sizes=("64 64 64" "128 128 128" "256 256 256" "320 320 320" "384 384 384" "448 448 448" "512 512 512")

# Select the size for this array task
sz="${sizes[$SLURM_ARRAY_TASK_ID]}"
base=$(echo $sz | awk '{print $1}')

# Run HYPRE test
srun -n 4 ./ij -solver 1 -125pt -n $sz -P 2 2 1 -memory_host -exec_host -exec2_host \
    > $HOME/hypre_testing/run_scripts/scripts/cpu/openmp_results/openmp_${base}.out 2>&1

