#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Script: 01_make_simul_fastq.sh
# Purpose:
#   Generate simulated paired-end FASTQ files using InSilicoSeq (ISS)
#   for ITS benchmarking analysis.
#
# Description:
#   Two simulation strategies are used:
#   (v1) User-defined relative abundance (abundance.tsv)
#   (v2) Lognormal abundance distribution
#
# Input:
#   - Reference genomes (FASTA)
#   - Abundance table (for v1)
#
# Output:
#   - Simulated FASTQ files (MiSeq error model)
#   -  data/simul_fastq/
#
# Tool:
#   InSilicoSeq (iss)
#
# Author: So-Yeon Kim
# Date: 2026-01-12
# --------------------------------------------------

############################
# User-defined parameters
############################

# Reference genome FASTA
GENOME_FASTA="data/input/fungi_mock_customDB_nameModi.fas"

# Abundance file (used only in v1)
ABUNDANCE_FILE="data/input/abundance.tsv"

# Number of reads (10 million)
N_READS=10000000

# Number of CPUs
CPUS=4

# Sequencing error model
MODEL="miseq"

# Output directory
OUTDIR="data/simul_fastq"
mkdir -p "${OUTDIR}"

############################
# Simulation 1:
# Fixed abundance (abundance.tsv)
############################

echo "[INFO] Running ISS simulation (v1: fixed abundance)"

iss generate \
  --genomes "${GENOME_FASTA}" \
  --abundance_file "${ABUNDANCE_FILE}" \
  --model "${MODEL}" \
  --n_reads "${N_READS}" \
  --cpus "${CPUS}" \
  --output "${OUTDIR}/ITS_300bp_10M_v1"

############################
# Simulation 2:
# Lognormal abundance distribution
############################

echo "[INFO] Running ISS simulation (v2: lognormal abundance)"

iss generate \
  --genomes "${GENOME_FASTA}" \
  --abundance lognormal \
  --model "${MODEL}" \
  --n_reads "${N_READS}" \
  --cpus "${CPUS}" \
  --output "${OUTDIR}/ITS_300bp_10M_v2"

echo "[INFO] Simulation completed successfully"

