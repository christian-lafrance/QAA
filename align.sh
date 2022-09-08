#!/bin/bash
#SBATCH --partition=bgmp       ### Partition (like a queue in PBS)
#SBATCH --job-name=mus_align      ### Job Name
#SBATCH --nodes=1               ### Number of nodes needed for the job
#SBATCH --ntasks-per-node=1     ### Number of tasks to be launched per Node
#SBATCH --account=bgmp      ### Account used for job submission
#SBATCH --cpus-per-task=10
#SBATCH --error=mus_align.err          ### File in which to store job error messages

conda activate QAA

readsDir="/projects/bgmp/shared/2017_sequencing/demultiplexed"
myDir="/projects/bgmp/clafranc/bioinfo/Bi622/QAA"

f1="11_2H_both_S9_L008_R1_001.fastq.gz"
f2="11_2H_both_S9_L008_R2_001.fastq.gz"
f3="29_4E_fox_S21_L008_R1_001.fastq.gz"
f4="29_4E_fox_S21_L008_R2_001.fastq.gz"

tools_dir="/projects/bgmp/clafranc/miniconda3/envs/bgmp_py310/bin"

/usr/bin/time -v STAR --runThreadN 8 \
--runMode genomeGenerate \
--genomeDir  $myDir/mouse_v107_GRCm39_db \
--genomeFastaFiles $myDir/Mus_musculus.GRCm39.dna.primary_assembly.fa \
--sjdbGTFfile $myDir/Mus_musculus.GRCm39.107.gtf

/usr/bin/time -v STAR --runThreadN 8 --runMode alignReads \
--outFilterMultimapNmax 3 \
--outSAMunmapped Within KeepPairs \
--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--readFilesCommand zcat \
--readFilesIn $readsDir/$f1 $readsDir/$f2 \
--genomeDir $myDir/mouse_v107_GRCm39_db \
--outFileNamePrefix mouse_ens107_GRCm39_both

/usr/bin/time -v STAR --runThreadN 8 --runMode alignReads \
--outFilterMultimapNmax 3 \
--outSAMunmapped Within KeepPairs \
--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--readFilesCommand zcat \
--readFilesIn $readsDir/$f3 $readsDir/$f4 \
--genomeDir $myDir/mouse_v107_GRCm39_db \
--outFileNamePrefix mouse_ens107_GRCm39_fox

./parse_sam.py -f mouse_ens107_GRCm39_both_Aligned.out.sam

./parse_sam.py -f mouse_ens107_GRCm39_foxAligned.out.sam

./parse_sam.py -f /projects/bgmp/clafranc/bioinfo/Bi621/PS/PS8/Danio_rerio.GRCz11.dna.ens104.STAR_2.7.1a_alignedAligned.out.sam


htseq-count --stranded=yes -c 11_2H_both_stranded_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_11_2H_both_Aligned.out.sam Mus_musculus.GRCm39.107.gtf

htseq-count --stranded=yes -c 29_4E_fox_stranded_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_29_4E_fox_Aligned.out.sam Mus_musculus.GRCm39.107.gtf

htseq-count --stranded=reverse -c 11_2H_both_reverse_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_11_2H_both_Aligned.out.sam Mus_musculus.GRCm39.107.gtf

htseq-count --stranded=reverse -c 29_4E_fox_reverse_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_29_4E_fox_Aligned.out.sam Mus_musculus.GRCm39.107.gtf

#samtools module load
# samtools view -b file.sam > file.bam #convert to BAM
# samtools sort file.bam > sorted_file.bam
# samtools index sorted_file.bam 
# samtools view bam 1 > chr1.sam