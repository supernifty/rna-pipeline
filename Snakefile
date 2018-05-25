
configfile: "cfg/config.yaml"
cluster = json.load(open("cfg/cluster.json"))

### helper functions ###
def r1s(wildcards):
  '''
    list of r1s, joined on ,
  '''
  return ','.join([s for i, s in enumerate(config["samples"][wildcards.sample]) if i % 2 == 0])

def r2s(wildcards):
  '''
    list of r2s, joined on ,
  '''
  return ','.join([s for i, s in enumerate(config["samples"][wildcards.sample]) if i % 2 == 1])


### target ###
rule all:
  input:
    expand("out/{sample}.star.sorted.bam", sample=config['samples'])

### align ###
rule sort_star:
  input:
    "out/{sample}.star.bam"
  output:
    "out/{sample}.star.sorted.bam"
  shell:
    "module load java/1.8.0_25 && "
    "java -jar tools/picard-2.8.2.jar SortSam INPUT={input} OUTPUT={output} VALIDATION_STRINGENCY=LENIENT SORT_ORDER=coordinate MAX_RECORDS_IN_RAM=5000000 CREATE_INDEX=True"

rule star:
  input:
    fastqs=lambda wildcards: config["samples"][wildcards.sample],
    star="reference/star.index",
    gff=config['gff']
  params:
    r1s=r1s,
    r2s=r2s
  output:
    "out/{sample}.star.bam"
  log:
    stderr="log/{sample}.stderr"
  shell:
    "mkdir tmp_star_{wildcards.sample}_$$ && tools/STAR/bin/Linux_x86_64_static/STAR --outFileNamePrefix tmp_star_{wildcards.sample}_$$/ --runThreadN 4 --genomeDir reference/star.index --sjdbGTFfile {input.gff} --sjdbOverhang 99 --readFilesIn {params.r1s} {params.r2s} --outSAMtype BAM Unsorted --outStd BAM_Unsorted --readFilesCommand zcat 1>{output} 2>{log.stderr} && rm -r tmp_star_{wildcards.sample}_$$"

### prepare ###
rule index_genome:
  input:
    reference=config['genome'],
    gff=config['gff']
  output:
    "reference/star.index"
  log:
    stdout="log/index_genome.stdout",
    stderr="log/index_genome.stderr"
  shell:
    "mkdir -p {output} && tools/STAR/bin/Linux_x86_64_static/STAR --runThreadN 4 --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {input.reference} --sjdbGTFfile {input.gff} --sjdbOverhang 99 --outStd Log 1>{log.stdout} 2>{log.stderr}"

