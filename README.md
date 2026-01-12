# 2025_Mycobiome

This repository contains Linux (bash) and R scripts for simulated NGS Datasets ITS-based fungal microbiome analysis.


## Directory 

```
ITS_simulation_pipeline/
├── README.md
├── scripts/                 # bash pipeline
│   └── bash/
│       ├── 01_make_simul_fastq.sh
│       ├── 02_extract_ITS.sh
│       └── 03_subsample_repli10.sh
├── data/
│   ├── input/               # FASTA, abundance.tsv
│   ├── simul_fastq/         # gitignore
│   ├── its_extracted/       # gitignore
│   └── subsampled/          # gitignore
│    
└── Rproj_simul/             
    ├── Rproj_simul.Rproj
    ├── 260112_dada2.Rmd
    ├── Figures/
    └── Phyloseq/
```

## Requirements

### OS
- Linux (tested on CentOS 7.9)
### Software
- cutadapt ≥ 4.9
- QIIME2 ≥ 2024.2
- R ≥ 4.4
### R packages
- dada2
- phyloseq
- ggplot2
### Reference
- UNITE (ver10.0_20240404_Fungi2) - `sh_general_release_dynamic_s_04.04.2024.fasta`
- Custom DB (MSA-1010) - `data/reference/Reference_MSA-1010`

## Work flow 
### 1) Conda (Linux tools)
```
# 1. insilicoseq기반 가상 서열 생산
conda activate insilicoseq
bash scripts/bash/01_make_simul_fastq.sh

# 2. ITS 영역 추출 (cutadapt)
conda activate cutadpat
bash scripts/bash/02_extract_ITS.sh

# 3. Subsampling  (BBtools)
conda activate bbtools
bash scripts/bash/03_subsample_repli10.sh
```



### 2) R env

```{r}


```
