#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Script: 03_subsample_repli10.sh
# Purpose:
#   Perform random subsampling of paired-end FASTQ files
#   with multiple random seeds to assess subsampling-induced bias.
#
# Description:
#   - ITS1 and ITS2 datasets
#   - Two simulation modes (v1: fixed abundance, v2: lognormal)
#   - 10 independent subsampling replicates (seed = 1–10)
#
# Input:
#   data/its_extracted/ITS{1,2}_10M_v*_R{1,2}.fastq
#
# Output:
#   data/subsampled/
#
# Tool:
#   BBTools (reformat.sh)
#
# Author: <Your Name>
# Date: 2026-01-XX
# --------------------------------------------------

############################
# User-defined parameters
############################

# Input / output directories
INDIR="data/its_extracted"
OUTDIR="data/subsampled"
mkdir -p "${OUTDIR}"

# Subsampling depth (number of read pairs)
TARGET_READS=100000

# Seed range
SEEDS=$(seq 1 10)

############################
# Function: subsample FASTQ
############################

run_subsample () {
  local REGION=$1    # ITS1 or ITS2
  local VERSION=$2   # v1 or v2
  local SEED=$3

  local IN_R1="${INDIR}/${REGION}_10M_${VERSION}_R1.fastq"
  local IN_R2="${INDIR}/${REGION}_10M_${VERSION}_R2.fastq"

  local OUTDIR_SUB="${OUTDIR}"
  mkdir -p "${OUTDIR_SUB}"

  echo "[INFO] Subsampling ${REGION} ${VERSION} (seed=${SEED})"

  reformat.sh \
    in1="${IN_R1}" \
    in2="${IN_R2}" \
    out1="${OUTDIR_SUB}/${REGION}_100k_${VERSION}_seed${SEED}_R1.sub.fastq" \
    out2="${OUTDIR_SUB}/${REGION}_100k_${VERSION}_seed${SEED}_R2.sub.fastq" \
    samplereadstarget="${TARGET_READS}" \
    sampleseed="${SEED}" \
    verifypaired=t
}

############################
# Run subsampling
############################

for SEED in ${SEEDS}; do
  for REGION in ITS1 ITS2; do
    for VERSION in v1 v2; do
      run_subsample "${REGION}" "${VERSION}" "${SEED}"
    done
  done
done

echo "[INFO] Subsampling with 10 replicates completed successfully"

