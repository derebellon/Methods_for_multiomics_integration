suppressPackageStartupMessages({
  library(MOFA2)
})
source("R/load_mlomics.R")
brca <- load_mlomics_brca("data/raw/GS-BRCA/Top")

mofa_data <- list(
  mRNA        = t(brca$mRNA),
  miRNA       = t(brca$miRNA),
  methylation = t(brca$methylation),
  CNV         = t(brca$cnv)
)
cat("dims:\n"); print(sapply(mofa_data, dim))

mofa <- create_mofa(mofa_data)
cat("create_mofa OK\n")

data_opts  <- get_default_data_options(mofa)
model_opts <- get_default_model_options(mofa); model_opts$num_factors <- 10
train_opts <- get_default_training_options(mofa)
train_opts$verbose <- FALSE
train_opts$convergence_mode <- "fast"
train_opts$seed <- 42
train_opts$save_interrupted <- TRUE

mofa <- prepare_mofa(mofa, data_options = data_opts,
                     model_options = model_opts, training_options = train_opts)
cat("prepare_mofa OK\n")

tmp_out <- tempfile(fileext = ".hdf5")
mofa <- run_mofa(mofa, use_basilisk = TRUE, outfile = tmp_out, save_data = TRUE)
cat("MOFA trained and saved to", tmp_out, "\n")
cat("run_mofa OK\n")

print(get_variance_explained(mofa)$r2_per_factor)
