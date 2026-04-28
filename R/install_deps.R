# -----------------------------------------------------------------------------
# Install all R packages used by the tutorials.
# Use this if you do not want to use renv (renv::restore() is preferred when
# the renv.lock file is present).
#
# Usage:
#   Rscript R/install_deps.R
# -----------------------------------------------------------------------------

cran_pkgs <- c(
  "knitr", "rmarkdown",          # rendering
  "ggplot2", "RColorBrewer",     # plotting
  "reticulate",                  # R <-> Python bridge for VAE tutorial
  "SNFtool",                     # tutorial 4 (SNF)
  "aricode",                     # NMI / ARI metrics
  "survival", "survminer",       # comparison chapter (KM)
  "BiocManager"                  # gateway to Bioconductor
)

bioc_pkgs <- c(
  "mixOmics",                    # tutorials 1 (sPLS-DA) and 2 (DIABLO)
  "MOFA2",                       # tutorial 3 (MOFA2)
  "WGCNA",                       # tutorial 5 (WGCNA)
  "MultiAssayExperiment",        # MOFA2 dependency
  "BiocParallel"                 # parallel backend used by tune.block.splsda
)

options(repos = c(CRAN = "https://cloud.r-project.org"))

# CRAN
to_install <- setdiff(cran_pkgs,
                     rownames(installed.packages()))
if (length(to_install) > 0) {
  message("Installing CRAN packages: ", paste(to_install, collapse = ", "))
  install.packages(to_install, Ncpus = max(1, parallel::detectCores() - 1))
}

# Bioconductor
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
to_install_bioc <- setdiff(bioc_pkgs,
                           rownames(installed.packages()))
if (length(to_install_bioc) > 0) {
  message("Installing Bioconductor packages: ",
          paste(to_install_bioc, collapse = ", "))
  BiocManager::install(to_install_bioc, ask = FALSE, update = FALSE)
}

# Quick verification
all_pkgs <- c(cran_pkgs, bioc_pkgs)
status <- vapply(all_pkgs, requireNamespace, logical(1), quietly = TRUE)
cat("\nInstallation summary:\n")
print(data.frame(package = all_pkgs, available = status))

if (all(status)) {
  cat("\nAll dependencies installed successfully.\n")
  cat("\nFor the VAE tutorial you also need a Python environment with:\n")
  cat("  pip install torch numpy pandas scikit-learn matplotlib umap-learn\n")
} else {
  missing <- all_pkgs[!status]
  warning("Some packages failed to install: ",
          paste(missing, collapse = ", "))
}
