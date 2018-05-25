# Somatic pipeline

## Installation
* Python 3 is required.

```
python -m venv rna_venv
. ./rna_venv/bin/activate
pip install -r requirements.txt
```

## Reference Data
```
wget ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/knownGene.txt.gz
```

## Dependencies
* reference/genome.fa: this file needs to be bwa indexed.

Modules
* java
* samtools

Tools directory
* picard

### STAR ###
```
cd tools
git clone https://github.com/alexdobin/STAR.git
```

## Configuration

* cfg/config.yaml: set sample details
* cfg/cluster.json: set cluster resources

## Usage

```
./run.sh
```

## Directories
* cfg: configuration files
* in: input files (fastq)
* log: command logs
* out: generated files
* reference: reference files
* tools: 3rd party tools
