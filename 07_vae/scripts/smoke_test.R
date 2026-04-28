suppressPackageStartupMessages(library(reticulate))

source("R/load_mlomics.R")
brca <- load_mlomics_brca("data/raw/GS-BRCA/Top")
X_concat <- cbind(brca$mRNA, brca$miRNA, brca$methylation, brca$cnv)
X_scaled <- scale(X_concat)
y_int <- as.integer(brca$labels) - 1
class_names <- levels(brca$labels)

cat("X dim:", dim(X_scaled), "  y len:", length(y_int), "\n")

py$X <- as.matrix(X_scaled)
py$y <- y_int
py$class_names <- class_names

cat("Successfully passed to Python.\n")

py_run_string("import torch; import numpy as np; print('torch:', torch.__version__, ' numpy:', np.__version__)")
py_run_string("import numpy as np; print('X shape:', np.asarray(X).shape, '  y shape:', np.asarray(y).shape)")
