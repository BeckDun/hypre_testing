#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --partition=l40s
#SBATCH --gpus-per-node=1
#SBATCH --time=00:10:00
#SBATCH --job-name=hypre_sweep
#SBATCH --output=logs/cpu_s%a_%A.out
#SBATCH --array=0-17

mkdir -p logs

# Sweep parameters
SOLVERS=(0 1 2)
NPROCS=(1 2 4 8 16 32)

# Decompose array index -> (solver, nproc)
SOLVER_IDX=$(( SLURM_ARRAY_TASK_ID / ${#NPROCS[@]} ))
NP_IDX=$(( SLURM_ARRAY_TASK_ID % ${#NPROCS[@]} ))

SOLVER=${SOLVERS[$SOLVER_IDX]}
NP=${NPROCS[$NP_IDX]}

# Pick a processor grid Px*Py*Pz = NP
case $NP in
    1)  PX=1; PY=1; PZ=1 ;;
    2)  PX=2; PY=1; PZ=1 ;;
    4)  PX=2; PY=2; PZ=1 ;;
    8)  PX=2; PY=2; PZ=2 ;;
    16) PX=4; PY=2; PZ=2 ;;
    32) PX=4; PY=4; PZ=2 ;;
esac

# Rename output for clarity (symlink to readable name)
OUTFILE="logs/cpu_solver${SOLVER}_np${NP}.out"
ln -sf "cpu_s${SOLVER_IDX}_${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}.out" "$OUTFILE" 2>/dev/null || true

echo "=== Solver $SOLVER | NP=$NP | Grid=${PX}x${PY}x${PZ} ==="

export CUDA_VISIBLE_DEVICES=""
export OPENMPI_GPU_SUPPORT_ENABLED=0

cd $HOME/hypre_testing/src/build/test

srun -n $NP ./ij -solver $SOLVER -125pt -n 128 128 128 \
    -P $PX $PY $PZ \
    -memory_host -exec_host -exec2_host \
    -memory_location 0 -exec_policy 0
