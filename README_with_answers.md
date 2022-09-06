# RNA-seq Quality Assessment Assignment - Bi 622 (Summer 2022)

Be sure to upload all relevant materials by the deadline and **double check** to be sure that your off-line repository is up-to-date with your on-line repository. Answers to the questions should be submitted in your final report as a `pdf`.

## Objectives
The objectives of this assignment are to use existing tools for quality assessment and adaptor trimming, compare the quality assessments to those from your own software, and to demonstrate your ability to summarize other important information about this RNA-Seq data set.

### Data: 
Each of you will be working with 2 of the demultiplexed file pairs. For all steps below, process the two libraries separately. Library assignments are here: ```/projects/bgmp/shared/Bi622/QAA_data_assignments.txt```

The demultiplexed, gzipped .fastq files are here: ```/projects/bgmp/shared/2017_sequencing/demultiplexed/```

### Do not move, copy, or unzip these data!

```
______                    _                                                               
|  _  \                  | |                                                              
| | | |___    _ __   ___ | |_   _ __ ___   _____   _____      ___ ___  _ __  _   _        
| | | / _ \  | '_ \ / _ \| __| | '_ ` _ \ / _ \ \ / / _ \    / __/ _ \| '_ \| | | |       
| |/ / (_) | | | | | (_) | |_  | | | | | | (_) \ V /  __/_  | (_| (_) | |_) | |_| |_      
|___/ \___/  |_| |_|\___/ \__| |_| |_| |_|\___/ \_/ \___( )  \___\___/| .__/ \__, ( )     
                                                        |/            | |     __/ |/      
                                                                      |_|    |___/        
                              _         _   _                          _       _        _ 
                             (_)       | | | |                        | |     | |      | |
  ___  _ __   _   _ _ __  _____ _ __   | |_| |__   ___  ___  ___    __| | __ _| |_ __ _| |
 / _ \| '__| | | | | '_ \|_  / | '_ \  | __| '_ \ / _ \/ __|/ _ \  / _` |/ _` | __/ _` | |
| (_) | |    | |_| | | | |/ /| | |_) | | |_| | | |  __/\__ \  __/ | (_| | (_| | || (_| |_|
 \___/|_|     \__,_|_| |_/___|_| .__/   \__|_| |_|\___||___/\___|  \__,_|\__,_|\__\__,_(_)
                               | |                                                        
                               |_|                                                        
```

### Do not move, copy, or unzip these data!

# Part 1 – Read quality score distributions

1. Using ```FastQC``` via the command line on Talapas, produce plots of quality score distributions for R1 and R2 reads. Also, produce plots of the per-base N content, and comment on whether or not they are consistent with the quality score plots.  


```
The per-base N content is consistent with the per base quality
scores. There are more N's at the beginning of the sequence, and the
beginning of the sequence also has lower quality scores on average
```

2. Run your quality score plotting script from your Demultiplexing assignment. (Make sure you're using the "running sum" strategy!!) Describe how the ```FastQC``` quality score distribution plots compare to your own. If different, propose an explanation. Also, does the runtime differ? If so, why?

```
The plots generated from my python script and FastQC are very similar with
no obvious differences. FastQC was much faster, probably due to significant
optimization and being written in a faster programming language. 
```

3. Comment on the overall data quality of your two libraries.
```
The two libraries follow a similar trend, low in the beginning, highest in 
the middle, and slowly drops off at the end. R2 is lower in general than
R1 for both libraries. The 29_4E_fox_S21_L008 library has slighly higher
per-base quality scores on average. 
```

# Part 2 – Adaptor trimming comparison

4. Create a new conda environment called ```QAA``` and install ```cutadapt``` and ```Trimmomatic```. Google around if you need a refresher on how to create conda environments. Recommend doing this in an interactive session, not the login node! Make sure you check your installations with:
    - ```cutadapt --version``` (should be 4.1)
    -  ```trimmomatic -version``` (should be 0.39)

5. Using ```cutadapt```, properly trim adapter sequences from your assigned files. Be sure to read how to use ```cutadapt```. Use default settings. What proportion of reads (both R1 and R2) were trimmed?

```
cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o TRIMMED_29_4E_fox_S21_L008_R1_001 -p TRIMMED_29_4E_fox_S21_L008_R2_001.fastq \
/projects/bgmp/shared/2017_sequencing/demultiplexed/29_4E_fox_S21_L008_R1_001.fastq.gz \
/projects/bgmp/shared/2017_sequencing/demultiplexed/29_4E_fox_S21_L008_R2_001.fastq.gz -j 10
```

```
   71676772 TRIMMED_11_2H_both_S9_L008_R1_001.fastq
   71676772 TRIMMED_11_2H_both_S9_L008_R2_001.fastq
    Read 1 with adapter:                 874,706 (4.9%)
    Read 2 with adapter:               1,016,991 (5.7%)

   19309732 TRIMMED_29_4E_fox_S21_L008_R1_001.fastq
   19309732 TRIMMED_29_4E_fox_S21_L008_R2_001.fastq
    Read 1 with adapter:                 361,886 (7.5%)
    Read 2 with adapter:                 400,819 (8.3%)    
```

    <details>
    <summary>Try to determine what the adapters are on your own. If you cannot (or if you do, and want to confirm), click here to see the actual adapter sequences used.</summary>
  
    R1: ```AGATCGGAAGAGCACACGTCTGAACTCCAGTCA```
    
    R2: ```AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT```
    </details>

    - *Sanity check*: Use your Unix skills to search for the adapter sequences in your datasets and confirm the expected sequence orientations. Report the commands you used, the reasoning behind them, and how you confirmed the adapter sequences.

6. Use ```Trimmomatic``` to quality trim your reads. Specify the following, in this order:
    - LEADING: quality of 3
    - TRAILING: quality of 3
    - SLIDING WINDOW: window size of 5 and required quality of 15
    - MINLENGTH: 35 bases

    Be sure to output compressed files and clear out any intermediate files.

7. Plot the trimmed read length distributions for both R1 and R2 reads (on the same plot). You can produce 2 different plots for your 2 different RNA-seq samples. There are a number of ways you could possibly do this. One useful thing your plot should show, for example, is whether R1s are trimmed more extensively than R2s, or vice versa. Comment on whether you expect R1s and R2s to be adapter-trimmed at different rates. 

```
I expect R1 and R2 to have similar rates of adapter trimming since whether adapters are present
is determine by the insert length and if that is lower than the sequencing runs specified. 
Though since the DNA sits on the flow cell for a long time before R2 is sequenced, it is 
possible that it has undergone some degredation which might cause some issues. 
However, I do expect R2 to have more quality trimming than R1, for the same reason. 
Sitting on the flow cell for a long time will probably cause some degredation. 
```

# Part 3 – Alignment and strand-specificity
8. Install sofware. In your QAA environment, use conda to install:
    - star
    - numpy
    - pysam
    - matplotlib
    - htseq

8. Find publicly available mouse genome fasta files (Ensemble release 107) and generate an alignment database from them. Align the reads to your mouse genomic database using a splice-aware aligner. Use the settings specified in PS8 from Bi621.

    *Hint* - you will need to use gene models to perform splice-aware alignment, see PS8 from Bi621.
    
```
wget http://ftp.ensembl.org/pub/release-107/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
wget http://ftp.ensembl.org/pub/release-107/gtf/mus_musculus/Mus_musculus.GRCm39.107.gtf.gz
```

```
Used align.sh to generate alignment database and perform alignment. 
```
9. Using your script from PS8 in Bi621, report the number of mapped and unmapped reads from each of your 2 sam files. Make sure that your script is looking at the bitwise flag to determine if reads are primary or secondary mapping (update/fix your script if necessary).

```
mouse_ens107_GRCm39_11_2H_both_Aligned.out.sam
Mapped: 33855756
Unmapped: 1982630

mouse_ens107_GRCm39_29_4E_fox_Aligned.out.sam
Mapped: 8995444
Unmapped: 659422
```

10. Count reads that map to features using `htseq-count`. You should run htseq-count twice: once with `--stranded=yes` and again with `--stranded=reverse`. Use default parameters otherwise.

```
htseq-count --stranded=yes -c 11_2H_both_stranded_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_11_2H_both_Aligned.out.sam Mus_musculus.GRCm39.107.gtf
```
```
htseq-count --stranded=yes -c 29_4E_fox_stranded_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_29_4E_fox_Aligned.out.sam Mus_musculus.GRCm39.107.gtf
```
```
htseq-count --stranded=reverse -c 11_2H_both_reverse_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_11_2H_both_Aligned.out.sam Mus_musculus.GRCm39.107.gtf
```
```
htseq-count --stranded=reverse -c 29_4E_fox_reverse_counts.tsv -n 10 \
--with-header mouse_ens107_GRCm39_29_4E_fox_Aligned.out.sam Mus_musculus.GRCm39.107.gtf
```
11. Demonstrate convincingly whether or not the data are from “strand-specific” RNA-Seq libraries. Include any comands/scripts used. Briefly describe your evidence, using quantitative statements (e.g. "I propose that these data are/are not strand-specific, because X% of the reads are y, as opposed to z.").

    *Hint* - recall ICA4 from Bi621.

```
cat 11_2H_both_stranded_counts.tsv | grep -v '^_' | awk '{sum+=$2} END {print sum}'
600435
cat 11_2H_both_reverse_counts.tsv | grep -v '^_' | awk '{sum+=$2} END {print sum}'
13934885
```

```
cat 29_4E_fox_stranded_counts.tsv | grep -v '^_' | awk '{sum+=$2} END {print sum}'
187153
cat 29_4E_fox_reverse_counts.tsv | grep -v '^_' | awk '{sum+=$2} END {print sum}'
3923907
```

```
For both of the files, there are more counts when --stranded=reverse is specified. Based on this and 
htseq-count --help, the reads are from strand-specific libraries where the reads are the reverse
complements of the genomic sequence which they were aligned to. 
```

## To turn in your work for this assignment

### Upload your:
- Talapas batch script/code, 
- FastQC plots, 
- mapped/unmapped read counts, 
- counts files generated from htseq-count (in a folder would be nice), 
- answers to questions, 
- and any additional plots/code to github. 
    
### You should create a pdf file (using Rmarkdown) with a high-level report including:
- all plots
- answers to questions
- read counts (in a nicely formatted table)
    
The three parts of the assignment should be clearly labeled. Be sure to title and write a figure legend for each image/graph/table you present. The file should be named `QAA_report.pdf`, and it should be a the top level of your repo.
