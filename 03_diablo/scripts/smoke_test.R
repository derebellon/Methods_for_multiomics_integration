# Quick smoke test: ensure block.splsda runs end-to-end on the 4-block GS-BRCA data.
# Usage from repo root:
#   Rscript 03_diablo/scripts/smoke_test.R

suppressPackageStartupMessages(library(mixOmics))
source("R/load_mlomics.R")

brca <- load_mlomics_brca("data/raw/GS-BRCA/Top")
X <- list(mRNA = brca$mRNA, miRNA = brca$miRNA,
          methylation = brca$methylation, CNV = brca$cnv)
Y <- brca$labels

design <- matrix(0.1, 4, 4); diag(design) <- 0
dimnames(design) <- list(names(X), names(X))

t0 <- Sys.time()
fit <- block.splsda(
  X, Y, ncomp = 2,
  keepX = list(mRNA = c(20,20), miRNA = c(20,20),
               methylation = c(20,20), CNV = c(20,20)),
  design = design
)
cat(sprintf("block.splsda baseline fit: %.1f s\n",
            as.numeric(Sys.time() - t0, units = "secs")))

# Quick perf
t0 <- Sys.time()
set.seed(42)
cv <- perf(fit, validation = "Mfold", folds = 5, nrepeat = 1,
           dist = "centroids.dist", progressBar = FALSE)
cat(sprintf("perf 5-fold x 1 rep: %.1f s\n",
            as.numeric(Sys.time() - t0, units = "secs")))
print(cv$WeightedVote.error.rate$centroids.dist)

cat("\nSmoke test OK.\n")
