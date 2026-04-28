# Rare-cancer benchmark: SNF + spectral clustering + survival validation
# across all rare cancers we have downloaded. Run from repo root:
#   Rscript 08_comparison/scripts/rare_cancers_benchmark.R

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

run_one <- function(cancer) {
  d <- file.path("data/raw", cancer, "Top")
  if (!dir.exists(d)) {
    return(data.frame(cancer = cancer, n = NA, eigengap_C = NA,
                      C2_p = NA, C3_p = NA, C4_p = NA,
                      note = "data not downloaded"))
  }

  blocks <- list(
    mRNA        = read_omic(file.path(d, paste0(cancer, "_mRNA_top.csv"))),
    miRNA       = read_omic(file.path(d, paste0(cancer, "_miRNA_top.csv"))),
    methylation = read_omic(file.path(d, paste0(cancer, "_Methy_top.csv"))),
    cnv         = read_omic(file.path(d, paste0(cancer, "_CNV_top.csv")))
  )
  surv <- read.csv(file.path(d, paste0("survival_", cancer, ".csv")))

  common <- Reduce(intersect, c(lapply(blocks, rownames), list(surv$sample_name)))
  blocks <- lapply(blocks, function(M) M[common, , drop = FALSE])
  surv   <- surv[match(common, surv$sample_name), ]

  K <- 20; alpha <- 0.5; T_iter <- 20
  build_W <- function(X) {
    Xs <- standardNormalization(X)
    D  <- (dist2(Xs, Xs))^(1/2)
    affinityMatrix(D, K = K, sigma = alpha)
  }

  W_list  <- lapply(blocks, build_W)
  W_fused <- SNF(W_list, K = K, t = T_iter)

  eg <- estimateNumberOfClustersGivenGraph(W_fused, NUMC = 2:6)
  eigengap_best <- as.integer(eg[[1]])

  pvs <- sapply(2:4, function(C) {
    cl <- spectralClustering(W_fused, C)
    df <- data.frame(time = surv$survival_times,
                     status = surv$event_observed,
                     cluster = factor(cl))
    lr <- survdiff(Surv(time, status) ~ cluster, data = df)
    1 - pchisq(lr$chisq, length(lr$n) - 1)
  })

  data.frame(
    cancer = cancer,
    n = length(common),
    eigengap_C = eigengap_best,
    C2_p = pvs[1], C3_p = pvs[2], C4_p = pvs[3],
    note = ""
  )
}

cancers <- c("ACC", "KIRP", "KIRC", "LIHC")
res <- do.call(rbind, lapply(cancers, run_one))

cat("\n========== Rare-cancer benchmark ==========\n")
print(res, row.names = FALSE)

# Persist for the comparison chapter
saveRDS(res, "08_comparison/scripts/rare_cancer_results.rds")
write.csv(res, "08_comparison/scripts/rare_cancer_results.csv", row.names = FALSE)
cat("\nResults written to 08_comparison/scripts/rare_cancer_results.{rds,csv}\n")
