#obtain the sequences from ncbi 
#diseased sample 
mkdir -p  ~/RNAseq_GSE150337/inputs/Fastq
fasterq-dump SRR11773137  -O ~/RNAseq_GSE150337/inputs/Fastq/
fasterq-dump SRR11773139  -O ~/RNAseq_GSE150337/inputs/Fastq/

#control sample
fasterq-dump SRR15669479  -O ~/RNAseq_GSE150337/inputs/Fastq/
fasterq-dump SRR15669480  -O ~/RNAseq_GSE150337/inputs/Fastq/
#obtain reference data
mkdir -p ~/RNAseq_GSE150337/references/
cd  ~/RNAseq_GSE150337/references/
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_40/GRCh38.primary_assembly.genome.fa.gz
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.basic.annotation.gtf.gz


#checking quality of the fastq reads 
mkdir -p ~/RNAseq_GSE150337/inputs/Fastq/FastQC
fastqc ~/RNAseq_GSE150337/inputs/Fastq/*.fastq –o FastQC
cd ./FastQC
multiqc .

#Alignment of the fastqc data 
#build indexes from the genome:
bowtie2-build ~/RNAseq_GSE150337/references/GRCh38.primary_assembly.genome.fa.gz  GRCh38.primary_assembly.genome
 
# Alignment uing tophat software
# creating directory for tophat_output
for i in ~/RNAseq_GSE150337/inputs/*.fastq ; do echo "$i" | uniq ; done 
for i in ~/RNAseq_GSE150337/inputs/*.fastq ;
do 
C=$(basename "$i" .fastq)
mkdir -p ~/RNAseq_GSE150337/output/"$C"  
done
# align using tophat 
for i in for i in ~/RNAseq_GSE150337/inputs/*.fastq ; do echo "$i" | uniq ; done
for i in ~/RNAseq_GSE150337/inputs/*.fastq ;
do
C=$(basename "$i" .fastq)
tophat2 -r 100 -p 8 -a 0 -o ~/RNAseq_GSE150337/output/"$C"/Tophat_Out -G 
~/RNAseq_GSE150337/references/gencode.v38.basic.annotation.gtf.gz
~/RNAseq_GSE150337/references/GRCh38.primary_assembly.genome
"$i"
done


# Assemble gene expression from aligned reads
for i in for i in ~/RNAseq_GSE150337/inputs/*.fastq ; do echo "$i" | uniq ; done
for i in ~/RNAseq_GSE150337/inputs/*.fastq ;
C=$(basename "$i" .fastq)
samtools view "$C"/Tophat_Out/accepted_hits.sorted.bam | python -m
HTSeq.scripts.count -q -s no -i genename - ~/RNAseq_GSE150337/references/gencode.v38.basic.annotation.gtf.gz>
"$C"/"$C".count.txt
"$i"
done

