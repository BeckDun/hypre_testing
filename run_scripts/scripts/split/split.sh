#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=64
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=hypre_hybrid_128
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4
#SBATCH --output=$HOME/hypre_testing/run_scripts/scripts/hybrid/slurm_%j.log

# Load required modules
module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

echo "Loaded modules:"
module list

# Set OpenMP threads for CPU setup phase
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"

# Navigate to the test directory
cd $HOME/hypre_testing/src/build/test

# Create output directory
mkdir -p $HOME/hypre_testing/run_scripts/scripts/hybrid


srun --cpu-bind=cores --gpu-bind=closest \
     -n 4 -G 4 \
     ./ij \
    -dbg 1 \
    -poutdat 3 \
    -solver 1 \
    -125pt \
    -n 128 128 128 \
    -P 2 2 1 \
    -hybrid \
    > $HOME/hypre_testing/run_scripts/scripts/hybrid/hybrid_128.out 2>&1

