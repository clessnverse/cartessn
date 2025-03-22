# Set a custom library path
lib_path <- "~/R/library"
dir.create(lib_path, showWarnings = FALSE, recursive = TRUE)

# Attempt to install dependencies first
install.packages(c("devtools", "remotes", "sf", "dplyr", "ggplot2", "patchwork", "rlang"), 
                 repos = "https://cloud.r-project.org",
                 lib = lib_path)

# Load libraries
library(devtools, lib.loc = lib_path)
library(remotes, lib.loc = lib_path)

# Set verbose options to get more information
options(verbose = TRUE)
options(warn = 2)  # Convert warnings to errors for better diagnostics

# Attempt to install the package from local directory
tryCatch({
  print("Installing from local directory...")
  devtools::install(".", lib = lib_path, dependencies = TRUE, upgrade = "never", force = TRUE)
}, error = function(e) {
  print(paste("Error installing from local directory:", e))
})

# Attempt to install from GitHub with different options
tryCatch({
  print("Installing from GitHub with curl method...")
  remotes::install_github("clessnverse/cartessn", 
                         lib = lib_path, 
                         dependencies = TRUE, 
                         upgrade = "never",
                         force = TRUE,
                         INSTALL_opts = "--no-multiarch",
                         ref = "main",
                         build = TRUE,
                         build_vignettes = FALSE,
                         build_manual = FALSE,
                         build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
                         quiet = FALSE,
                         type = "source",
                         options(download.file.method = "curl"))
}, error = function(e) {
  print(paste("Error installing from GitHub with curl:", e))
})

# Try with download.file.method set to "libcurl"
tryCatch({
  print("Installing from GitHub with libcurl method...")
  options(download.file.method = "libcurl")
  remotes::install_github("clessnverse/cartessn", 
                         lib = lib_path,
                         dependencies = TRUE)
}, error = function(e) {
  print(paste("Error installing from GitHub with libcurl:", e))
})

# Try with download.file.method set to "wget"
tryCatch({
  print("Installing from GitHub with wget method...")
  options(download.file.method = "wget")
  remotes::install_github("clessnverse/cartessn", 
                         lib = lib_path,
                         dependencies = TRUE)
}, error = function(e) {
  print(paste("Error installing from GitHub with wget:", e))
})

print("Installation attempts completed.")