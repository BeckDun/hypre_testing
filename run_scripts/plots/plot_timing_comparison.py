#!/usr/bin/env python3

import matplotlib.pyplot as plt
import re
import numpy as np

def parse_results_file(filename):
    data = []
    
    with open(filename, 'r') as f:
        content = f.read()
    
    # Find all matches in order and pair them up
    all_nx_matches = re.findall(r'\(nx, ny, nz\) = \((\d+), (\d+), (\d+)\)', content)
    all_setup_matches = re.findall(r'PCG Setup:\s+wall clock time = ([\d.]+) seconds', content)
    all_solve_matches = re.findall(r'PCG Solve:\s+wall clock time = ([\d.]+) seconds', content)
    
    # Match them up based on order
    min_len = min(len(all_nx_matches), len(all_setup_matches), len(all_solve_matches))
    for i in range(min_len):
        nx, ny, nz = all_nx_matches[i]
        problem_size = int(nx) * int(ny) * int(nz)
        setup_time = float(all_setup_matches[i])
        solve_time = float(all_solve_matches[i])
        
        data.append({
            'problem_size': problem_size,
            'setup_time': setup_time,
            'solve_time': solve_time,
            'total_time': setup_time + solve_time
        })
    
    return sorted(data, key=lambda x: x['problem_size'])

def plot_timing_comparison():
    """Create timing comparison graphs."""
    
    # Parse each results file
    cpu_data = parse_results_file('cpu_results')
    gpu_data = parse_results_file('gpu_results')
    split_data = parse_results_file('split_results')
    
    # Create subplots
    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 5))
    
    # Plot setup times
    if cpu_data:
        sizes = [d['problem_size'] for d in cpu_data]
        times = [d['setup_time'] for d in cpu_data]
        ax1.loglog(sizes, times, 'o-', label='CPU', color='blue')
    
    if gpu_data:
        sizes = [d['problem_size'] for d in gpu_data]
        times = [d['setup_time'] for d in gpu_data]
        ax1.loglog(sizes, times, 's-', label='GPU', color='red')
    
    if split_data:
        sizes = [d['problem_size'] for d in split_data]
        times = [d['setup_time'] for d in split_data]
        ax1.loglog(sizes, times, '^-', label='Split', color='green')
    
    ax1.set_xlabel('Problem Size')
    ax1.set_ylabel('Setup Time (s)')
    ax1.set_title('Setup Time')
    ax1.legend()
    ax1.grid(True)
    
    # Plot solve times
    if cpu_data:
        sizes = [d['problem_size'] for d in cpu_data]
        times = [d['solve_time'] for d in cpu_data]
        ax2.loglog(sizes, times, 'o-', label='CPU', color='blue')
    
    if gpu_data:
        sizes = [d['problem_size'] for d in gpu_data]
        times = [d['solve_time'] for d in gpu_data]
        ax2.loglog(sizes, times, 's-', label='GPU', color='red')
    
    if split_data:
        sizes = [d['problem_size'] for d in split_data]
        times = [d['solve_time'] for d in split_data]
        ax2.loglog(sizes, times, '^-', label='Split', color='green')
    
    ax2.set_xlabel('Problem Size')
    ax2.set_ylabel('Solve Time (s)')
    ax2.set_title('Solve Time')
    ax2.legend()
    ax2.grid(True)
    
    # Plot total times
    if cpu_data:
        sizes = [d['problem_size'] for d in cpu_data]
        times = [d['total_time'] for d in cpu_data]
        ax3.loglog(sizes, times, 'o-', label='CPU', color='blue')
    
    if gpu_data:
        sizes = [d['problem_size'] for d in gpu_data]
        times = [d['total_time'] for d in gpu_data]
        ax3.loglog(sizes, times, 's-', label='GPU', color='red')
    
    if split_data:
        sizes = [d['problem_size'] for d in split_data]
        times = [d['total_time'] for d in split_data]
        ax3.loglog(sizes, times, '^-', label='Split', color='green')
    
    ax3.set_xlabel('Problem Size')
    ax3.set_ylabel('Total Time (s)')
    ax3.set_title('Total Time')
    ax3.legend()
    ax3.grid(True)
    
    plt.tight_layout()
    plt.savefig('timing_comparison.png', dpi=300, bbox_inches='tight')
    plt.show()

if __name__ == "__main__":
    plot_timing_comparison()
