#!/bin/bash
#SBATCH --partition=bgmp       ### Partition (like a queue in PBS)
#SBATCH --job-name=compare_qc     ### Job Name
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=1     ### Number of tasks to be launched per Node
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --error=compare_qc.err          ### File in which to store job error messages

file="29_4E_fox_S21_L008_R2_001.fastq.gz"

echo $file

conda activate QAA
module load fastqc

dataDir="/projects/bgmp/shared/2017_sequencing/demultiplexed"
myDir="/projects/bgmp/clafranc/bioinfo/Bi622/QAA"

f1="11_2H_both_S9_L008_R1_001.fastq.gz"
f2="11_2H_both_S9_L008_R2_001.fastq.gz"
f3="29_4E_fox_S21_L008_R1_001.fastq.gz"
f4="29_4E_fox_S21_L008_R2_001.fastq.gz"


/usr/bin/time -v ./mean_phred.py -f $dataDir/$file -l 101 -p "29_4E_fox_S21_L008_R2_001"

/usr/bin/time -v fastqc $dataDir/$file -o $myDir/fastqc_output