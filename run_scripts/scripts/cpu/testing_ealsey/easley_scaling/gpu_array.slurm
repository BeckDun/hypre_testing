#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --partition=l40s
#SBATCH --gpus-per-node=3
#SBATCH --time=00:10:00
#SBATCH --job-name=hypre_gpu_sweep
#SBATCH --output=logs/gpu_s%a_%A.out
#SBATCH --array=0-8

mkdir -p logs

# Sweep parameters
SOLVERS=(0 1 2)
NGPUS=(1 2 3)

# Decompose array index -> (solver, ngpu)
SOLVER_IDX=$(( SLURM_ARRAY_TASK_ID / ${#NGPUS[@]} ))
NG_IDX=$(( SLURM_ARRAY_TASK_ID % ${#NGPUS[@]} ))

SOLVER=${SOLVERS[$SOLVER_IDX]}
NG=${NGPUS[$NG_IDX]}

# Pick a 1D processor grid Px*Py*Pz = NG (one rank per GPU)
case $NG in
    1) PX=1; PY=1; PZ=1 ;;
    2) PX=2; PY=1; PZ=1 ;;
    3) PX=3; PY=1; PZ=1 ;;
    4) PX=2; PY=2; PZ=1 ;;
    8) PX=2; PY=2; PZ=2 ;;
esac

# Human-readable symlink
OUTFILE="logs/gpu_solver${SOLVER}_ng${NG}.out"

echo "=== Solver $SOLVER | NGPU=$NG | Grid=${PX}x${PY}x${PZ} ==="

cd $HOME/hypre_testing/src/build/test

srun -n $NG -G $NG ./ij -solver $SOLVER -125pt -n 128 128 128 \
    -P $PX $PY $PZ \
    -memory_device -exec_device -exec2_device
