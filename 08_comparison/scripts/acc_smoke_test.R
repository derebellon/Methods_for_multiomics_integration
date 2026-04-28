# Quick smoke test: SNF on ACC + survival validation.
# Usage from repo root:
#   Rscript 08_comparison/scripts/acc_smoke_test.R

suppressPackageStartupMessages({
  library(SNFtool)
  library(survival)
})

read_omic <- function(file) {
  raw <- read.csv(file, row.names = NULL, check.names = FALSE)
  fn <- raw[[1]]
  fn[!nzchar(fn)] <- paste0("unnamed_", seq_len(sum(!nzchar(fn))))
  fn <- make.unique(fn)
  m <- as.matrix(raw[, -1, drop = FALSE])
  rownames(m) <- fn
  t(m)
}

acc_dir <- "data/raw/ACC/Top"
acc <- list(
  mRNA        = read_omic(file.path(acc_dir, "ACC_mRNA_top.csv")),
  miRNA       = read_omic(file.path(acc_dir, "ACC_miRNA_top.csv")),
  methylation = read_omic(file.path(acc_dir, "ACC_Methy_top.csv")),
  cnv         = read_omic(file.path(acc_dir, "ACC_CNV_top.csv"))
)
surv <- read.csv(file.path(acc_dir, "survival_ACC.csv"))

common <- Reduce(intersect, c(lapply(acc, rownames), list(surv$sample_name)))
cat("Aligned patients:", length(common), "\n")
acc <- lapply(acc, function(M) M[common, , drop = FALSE])
surv <- surv[match(common, surv$sample_name), ]

K <- 20; alpha <- 0.5; T_iter <- 20
build_W <- function(X) {
  Xs <- standardNormalization(X)
  D  <- (dist2(Xs, Xs))^(1/2)
  affinityMatrix(D, K = K, sigma = alpha)
}

W_list <- lapply(acc, build_W)
W_fused <- SNF(W_list, K = K, t = T_iter)

cat("\nEigengap estimate of optimal cluster count:\n")
print(estimateNumberOfClustersGivenGraph(W_fused, NUMC = 2:6))

for (C in 2:4) {
  clusters <- spectralClustering(W_fused, C)
  surv_df <- data.frame(time = surv$survival_times,
                        status = surv$event_observed,
                        cluster = factor(clusters))
  lr <- survdiff(Surv(time, status) ~ cluster, data = surv_df)
  pv <- 1 - pchisq(lr$chisq, length(lr$n) - 1)
  cat(sprintf("\nC = %d  cluster sizes: %s  log-rank p = %.4f\n",
              C, paste(table(clusters), collapse = ", "), pv))
}
