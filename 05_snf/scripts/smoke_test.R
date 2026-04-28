suppressPackageStartupMessages({
  library(SNFtool)
  library(aricode)
})
source("R/load_mlomics.R")
brca <- load_mlomics_brca("data/raw/GS-BRCA/Top")

K <- 20; alpha <- 0.5; T_iter <- 20
build_W <- function(X, name = "?") {
  cat(">>", name, " dim =", dim(X), "\n")
  Xs <- standardNormalization(X)
  cat("   any NaN after std:", any(is.nan(Xs)), "\n")
  cat("   zero-variance cols:", sum(apply(X, 2, var) == 0), "\n")
  D <- (dist2(Xs, Xs))^(1/2)
  cat("   any NaN in D:", any(is.nan(D)), "\n")
  affinityMatrix(D, K = K, sigma = alpha)
}

W_mRNA <- build_W(brca$mRNA, "mRNA")
W_miRNA <- build_W(brca$miRNA, "miRNA")
W_meth <- build_W(brca$methylation, "methylation")
W_cnv  <- build_W(brca$cnv, "cnv")

cat("\nFusing...\n")
W_fused <- SNF(list(W_mRNA, W_miRNA, W_meth, W_cnv), K = K, t = T_iter)
clusters <- spectralClustering(W_fused, 5)
cat("Cluster sizes:", paste(table(clusters), collapse = ","), "\n")
cat("NMI vs PAM50:", aricode::NMI(clusters, brca$labels), "\n")
cat("ARI vs PAM50:", aricode::ARI(clusters, brca$labels), "\n")
