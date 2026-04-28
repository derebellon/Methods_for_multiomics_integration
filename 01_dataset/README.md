# 01 — Dataset

Introduction to the **MLOmics GS-BRCA** multi-omics breast cancer dataset (Yang et al., *Sci Data* 12:913, 2025) used by every other tutorial in this repository.

## What is in this folder

- [`dataset.qmd`](dataset.qmd) — rendered as the *Dataset* chapter of the site. Explains source cohort, completeness, download, file layout, two practical gotchas, and class distribution.

## What you do here

1. Read the chapter.
2. Run the `curl` block once to download the five CSV files (~186 MB) into `data/raw/GS-BRCA/Top/` at the repository root.
3. Move on to [`02_splsda/`](../02_splsda/).

The shared loader that the rest of the tutorials call lives at [`../R/load_mlomics.R`](../R/load_mlomics.R).
