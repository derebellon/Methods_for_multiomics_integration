#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Download the public datasets used by the tutorials.
# Usage (from repository root):
#   bash scripts/download_data.sh           # downloads GS-BRCA only
#   bash scripts/download_data.sh --rare    # also downloads ACC (for the
#                                             comparison chapter)
#   bash scripts/download_data.sh --all     # downloads GS-BRCA + all 9 rare
#                                             cancers (for users who plan to
#                                             extend the comparison study)
# -----------------------------------------------------------------------------
set -euo pipefail

mode="${1:-brca}"

# -- GS-BRCA ------------------------------------------------------------------
echo ">> Downloading MLOmics GS-BRCA Top features..."
mkdir -p data/raw/GS-BRCA/Top
BASE="https://huggingface.co/datasets/AIBIC/MLOmics/resolve/main/Main_Dataset/Classification_datasets/GS-BRCA/Top"
for f in BRCA_label_num.csv BRCA_miRNA_top.csv BRCA_mRNA_top.csv \
         BRCA_Methy_top.csv BRCA_CNV_top.csv; do
  if [ -f "data/raw/GS-BRCA/Top/$f" ]; then
    echo "    $f already present, skipping."
  else
    curl -fL --progress-bar -o "data/raw/GS-BRCA/Top/$f" "$BASE/$f"
  fi
done

# -- Rare cancers (optional) --------------------------------------------------
download_rare() {
  local cancer="$1"
  echo ">> Downloading MLOmics ${cancer} Top features..."
  mkdir -p "data/raw/${cancer}/Top"
  local rbase="https://huggingface.co/datasets/AIBIC/MLOmics/resolve/main/Main_Dataset/Clustering_datasets/${cancer}/Top"
  for f in "survival_${cancer}.csv" "${cancer}_miRNA_top.csv" \
           "${cancer}_mRNA_top.csv" "${cancer}_Methy_top.csv" \
           "${cancer}_CNV_top.csv"; do
    if [ -f "data/raw/${cancer}/Top/$f" ]; then
      echo "    $f already present, skipping."
    else
      curl -fL --progress-bar -o "data/raw/${cancer}/Top/$f" "$rbase/$f"
    fi
  done
}

if [ "$mode" = "--rare" ] || [ "$mode" = "--all" ]; then
  download_rare ACC
fi

if [ "$mode" = "--all" ]; then
  for c in KIRC KIRP LIHC LUAD LUSC PRAD THCA THYM; do
    download_rare "$c"
  done
fi

echo ""
echo "Done. Datasets live under data/raw/."
echo "Total disk usage:"
du -sh data/raw 2>/dev/null || echo "  (du not available)"
