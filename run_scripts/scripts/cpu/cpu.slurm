#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=64
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=hypre_ij_array
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4
#SBATCH --output=hybrid_%j.out

module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1
module list
export HYPRE_EXEC_POLICY=HOST
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

cd $HOME/hypre_testing/src/build/test



srun -n 4 -G 4 ./ij  -solver 1 -125pt -n 128 128 128 -P 2 2 1 -hybrid
