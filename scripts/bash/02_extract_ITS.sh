#!/usr/bin/env bash
set -euo pipefail


# --------------------------------------------------
# Script: 02_extract_ITS.sh
# Purpose:
#   Extract ITS1 and ITS2 regions from simulated paired-end FASTQ
#   using cutadapt, reproducing primer-based amplification bias.
#
# Description:
#   - ITS1: ITS1-F / ITS2 primer pair
#   - ITS2: ITS3 / ITS4 primer pair
#   - Untrimmed reads are discarded to mimic PCR failure
#
# Input:
#   data/simul_fastq/ITS_300bp_10M_v*_R{1,2}.fastq
#
# Output:
#   data/its_extracted/
#
# Tool:
#   cutadapt
#
# Author: So-yeon Kim
# Date: 2026-01-12
# --------------------------------------------------

############################
# User-defined parameters
############################

# Input / output directories
INDIR="data/simul_fastq"
OUTDIR="data/its_extracted"
mkdir -p "${OUTDIR}"

# Number of threads
THREADS=4

############################
# Primer sequences
############################

# ITS1 primers (ITS1-F / ITS2)
ITS1_FWD="CTTGGTCATTTAGAGGAAGTAA"
ITS1_REV="GCTGCGTTCTTCATCGATGC"

# ITS2 primers (ITS3 / ITS4)
ITS2_FWD="GCATCGATGAAGAACGCAGC"
ITS2_REV="TCCTCCGCTTATTGATATGC"

############################
# Function: run cutadapt
############################

run_cutadapt () {
  local REGION=$1
  local FWD=$2
  local REV=$3
  local VERSION=$4

  echo "[INFO] Extracting ${REGION} (version ${VERSION})"

  cutadapt \
    -g "${FWD}" \
    -a "${REV}" \
    --discard-untrimmed \
    --match-read-wildcards \
    -m 50 \
    -o "${OUTDIR}/${REGION}_10M_${VERSION}_R1.fastq" \
    -p "${OUTDIR}/${REGION}_10M_${VERSION}_R2.fastq" \
    "${INDIR}/ITS_300bp_10M_${VERSION}_R1.fastq" \
    "${INDIR}/ITS_300bp_10M_${VERSION}_R2.fastq" \
    -j "${THREADS}"
}

############################
# Run extraction
############################

for VERSION in v1 v2; do
  run_cutadapt "ITS1" "${ITS1_FWD}" "${ITS1_REV}" "${VERSION}"
  run_cutadapt "ITS2" "${ITS2_FWD}" "${ITS2_REV}" "${VERSION}"
done


echo "[INFO] ITS extraction completed successfully"

