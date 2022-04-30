# RNA TRANSCRIPTOME ANALYSIS IN MULTISCLEROSIS DISEASES USING BIOINFORMATIC SOFTWARE
## introduction
The pipeline involves: 
1.obtaning SRA data
2.Quality checks on the raw reads
3.Alignment of the reads to the genome
4.Assemble gene expression from aligned reads

###Obtain the fastqc data from SRA files
Here we obtained sequences from the Geo study:GSE150337 using the software referred to as SRAtoolkit: we use the `fasterq --dump` command:

#### obtain the sequences from ncbi 
#diseased sample 
`fasterq-dump SRR11773136  -O ~/miRNAseq/input/`
`fasterq-dump SRR11773137  -O ~/miRNAseq/input/`


##### control sample
`fasterq-dump SRR15669479  -O ~/miRNAseq/input/`
`fasterq-dump SRR15669480  -O ~/miRNAseq/input/`

### Quality check on the raw reads.
Create a directory named FastQC to store the results later.
Then, call FastQC to obtain quality check metrics to inspect the quality of raw sequence reads (stored in the Fastq directory) 
and output the metrics to FastQC directory, using an multiqc combine the metrics of all the fastqc report: 

`$fastqc Fastq/*.fastq -o FastQC`  
`$cd  ./FastQC`
`$ multiqc .`

### Align raw reads to reference genome 
Map the trimmed sequence reads to reference genome using tophat2. 
Specifically, we first create a directory with the sample name to store the output then calling tophat2 and output results to the directory’s sub-directory 
named Tophat_Out. Since this is a human sample, UCSC Hg38 is used as the reference genome and the reference transcriptome file and
bowtie index files are stored under Indexes directory in the home directory. 
Bowtie2 index files contain the genome sequences to be aligned to in bowtie2 format. 
Tophat2 uses bowtie2 as the base sequence aligner.:

`#### Alignment of the fastqc data`
`####build indexes from the genome:`
`bowtie2-build GCA_000001405.29_GRCh38.p14_genomic.fna.gz human`

`#### Alignment uing tophat software`
`#### creating directory for tophat_output`
`for i in ~/miRNAseq/inputs/*.fastq ; do echo "$i" | uniq ; done` 
`for i in ~/miRNAseq/inputs/*.fastq ;`
`do` 
`C=$(basename "$i" .fastq)`
`mkdir ~/miRNAseq/output/"$C"`  
`done`
`##### align using tophat` 
`for i in for i in ~/miRNAseq/inputs/*.fastq ; do echo "$i" | uniq ; done`
`for i in ~/miRNAseq/inputs/*.fastq ;`
`do`
`C=$(basename "$i" .fastq)`
`tophat2 -r 200 -p 8 -o ~/miRNAseq/output/"$C"/Tophat_out -G ~/miRNAseq/refernces/Homo_sapiens.GRCh37.75.gtf ~/miRNAseq/refernces/human  "$i"`
`done`

### Assemble gene expression from aligned reads 
Use HTSeq to quantify the number of reads mapped to each gene:

`#### Assemble gene expression from aligned reads`
`for i in for i in ~/miRNAseq/inputs/*.fastq ; do echo "$i" | uniq ; done`
`for i in ~/miRNAseq/inputs/*.fastq ;`
`do`
`C=$(basename "$i" .fastq)`
`samtools view "$C"/Tophat_Out/accepted_hits.sorted.bam | python -m`
`HTSeq.scripts.count -q -s no - ~/miRNAseq/refernces/Homo_sapiens.GRCh37.75.gtf>`
`"$C"/"$C".count.txt`
`"$i"`
`done`


## Differential expression using EDGER
RNA expression profiling is analyzed by R programming language. The expression profiles were analyzed using stastical analysis by 
the edgeR package applying negative binomial test comparing between Healthy an diseased cells. 
The expression profiles was determined by the false discovery rate(adjusted p value) and the log fold change between the replicates.

** edgeranalysis.R**:
This script is in r code and is used to generate the maplots and the expression profile information in edgeranalysis folder, 
it works with edgeR package in r for analysis of my sequence the scripts contains codes in r and comments for each code hence it is easy to flow.


