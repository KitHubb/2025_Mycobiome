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
    ├── Rds / # dada2 result
    ├── Figures/  # error model  + taxonomy composition 
    └── Phyloseq/ # version 0, 3
```

## Requirements

### OS
- Linux (tested on CentOS 7.9)
### Software
- cutadapt ≥ 4.9
- QIIME2 ≥ 2024.2
- R ≥ 4.4
- BBtools ≥ 37
  
### R packages
- dada2
- phyloseq
- ggplot2


### Reference
- UNITE (ver10.0_20240404_Fungi2) - `sh_general_release_dynamic_s_04.04.2024.fasta`
- Custom DB (MSA-1010) - `data/reference/Reference_MSA-1010`

## Work flow 
### 개요 
분석은 다음과 같은 단계로 수행되었다.

1. InSilicoSeq를 이용하여 진균 reference FASTA로부터 가상 paired-end FASTQ를 생성하였다.
   - 고정된 상대적 abundance를 가진 데이터셋과 lognormal 분포를 따르는 데이터셋을 각각 생성
   - 10,000,000 read의 ITS가상 데이터 생성  

2. 생성된 가상 FASTQ에 대해 cutadapt를 이용하여
   ITS1 및 ITS2 영역을 primer 기반으로 추출
   이 과정에서 primer 미매칭 read는 제거(--discard-untrimmed)하여 PCR amplification bias를 모사

3. ITS1 및 ITS2 데이터에 대해 동일한 read depth(100,000 read pair)로
   random subsampling을 수행하였으며,
   subsampling-induced stochasticity를 평가하기 위해
   서로 다른 random seed를 사용한 10회의 반복 subsampling을 수행

4. Subsampled FASTQ에 대해 DADA2를 이용하여 ASV 추론을 수행, UNITE 및 customDB를 기반으로 계통 분류
    - replicate 간 Genus 구성 및 변동성을 비교


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
`260112_dada2.Rmd` 참고 


## Known Issues and Limitations
1. InSilicoSeq를 이용하여 생성한 가상 서열에서 reverse read의 quality score가 전반적으로 낮게 형성되는 경향이 관찰
   이로 인해 DADA2 denoise 단계에서 reverse read가 대거 탈락하는 현상이 발생하였으며, 
   이는 InSilicoSeq에서 사용된 Illumina error model의 특성과도 관련이 있을 것으로 판단

2. Subsampling 과정에서 bias가 존재함을 확인
   - Seed 1~10의 10회 반복 subsampling 결과, 상대적으로 read 수가 많은 데이터셋(특히 ITS2)에서 subsampling 결과 간 변동성이 관찰
   - 이는 InSilicoSeq가 가상 서열을 순차적으로 생성한 뒤 병합(merge)하는 방식으로 FASTQ를 구성하기 때문일 가능성이 있으며,
     subsampling 시 read 순서에 따른 영향이 완전히 제거되지 않았을 가능성이 있음
   - 따라서 가상 데이터 생성 이후, 모든 read를 무작위로 섞는(shuffling) 단계가 추가적으로 필요

3. DADA2 error model의 경우, forward read의 quality가 상대적으로 우수하고,
   subsampling 이후에도 read depth가 5만 이상 확보된 샘플에서는
   실제 실험 데이터에서 학습된 error model과 유사한 형태를 보임
   다만, quality가 낮거나 read 수가 적은 경우에는 error model의 안정성이 떨어짐

