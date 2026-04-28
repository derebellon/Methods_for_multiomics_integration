#' Load the MLOmics GS-BRCA "Top" dataset
#'
#' Reads the four CSV files released by Yang et al. (2025) for the GS-BRCA
#' classification task at the "Top" feature scale, transposes them to the
#' samples-in-rows convention used throughout this tutorial collection,
#' aligns sample IDs across omics, and returns a list ready for downstream
#' tools such as `mixOmics::splsda()`, `MOFA2::create_mofa()` or
#' `SNFtool::SNF()`.
#'
#' MLOmics ships each omic as a `features x samples` matrix with feature
#' names as the first (unnamed) column and TCGA barcodes as column headers.
#' The label file is a single column "Label" whose row order matches the
#' sample columns of the omics matrices.
#'
#' Reference: Yang Z, Kotoge R, Piao X, Chen Z, Zhu L, Gao P, Matsubara Y,
#' Sakurai Y, Sun J. *MLOmics: Cancer Multi-Omics Database for Machine
#' Learning.* Scientific Data 12, 913 (2025).
#'
#' @param data_dir Path to the `Top/` folder with the five CSVs.
#' @return A list with elements:
#'   - `mRNA`, `miRNA`, `methylation`, `cnv`: numeric matrices, samples in rows
#'   - `labels`: factor of PAM50 subtypes (LumA, LumB, Her2, Basal, Normal)
#'   - `sample_ids`: character vector of TCGA barcodes
load_mlomics_brca <- function(data_dir) {

  read_omic <- function(file) {
    raw <- read.csv(file, row.names = NULL, check.names = FALSE)

    # MLOmics' miRNA file ships with 166 empty feature names. Replace with
    # synthetic names before deduplicating, so we do not silently overwrite.
    feature_names <- raw[[1]]
    feature_names[!nzchar(feature_names)] <- paste0(
      "unnamed_", seq_len(sum(!nzchar(feature_names)))
    )
    feature_names <- make.unique(feature_names)

    m <- as.matrix(raw[, -1, drop = FALSE])
    rownames(m) <- feature_names
    t(m)                              # transpose to samples x features
  }

  mRNA <- read_omic(file.path(data_dir, "BRCA_mRNA_top.csv"))
  miRNA <- read_omic(file.path(data_dir, "BRCA_miRNA_top.csv"))
  meth <- read_omic(file.path(data_dir, "BRCA_Methy_top.csv"))
  cnv <- read_omic(file.path(data_dir, "BRCA_CNV_top.csv"))

  labels_num <- read.csv(file.path(data_dir, "BRCA_label_num.csv"))$Label

  # Mapping defined by the MLOmics authors in GS-Subtype labels.xlsx
  subtype_map <- c("LumA", "Her2", "LumB", "Normal", "Basal")
  labels <- factor(subtype_map[labels_num + 1], levels = subtype_map)

  stopifnot(
    nrow(mRNA) == nrow(miRNA),
    nrow(mRNA) == nrow(meth),
    nrow(mRNA) == nrow(cnv),
    nrow(mRNA) == length(labels),
    identical(rownames(mRNA), rownames(miRNA)),
    identical(rownames(mRNA), rownames(meth)),
    identical(rownames(mRNA), rownames(cnv))
  )

  list(
    mRNA        = mRNA,
    miRNA       = miRNA,
    methylation = meth,
    cnv         = cnv,
    labels      = labels,
    sample_ids  = rownames(mRNA)
  )
}
