# ============================================================
# Limitation Act, 1963
# Bootstrap analysis of extracted text blocks
#
# Minimal, reproducible analysis
# R 4.5.0 + pdftools
#
# Method:
#   1. Extract text from the official PDF.
#   2. Split each page into blank-line-separated text blocks.
#   3. Remove standalone page-number artifacts.
#   4. Count words in each extracted text block.
#   5. Bootstrap the observed text blocks with replacement
#      10,000 times.
#   6. Calculate the mean words per extracted text block
#      for every bootstrap sample.
#   7. Produce one figure.
#
# This analysis resamples the observed document.
# It does not simulate legal cases or legal rules.
# ============================================================


# ------------------------------------------------------------
# 1. Reproducibility settings
# ------------------------------------------------------------

set.seed(1963)

n_boot <- 10000

pdf_file <- "data/limitation_act_1963.pdf"

output_dir <- "output"

dir.create(
  output_dir,
  showWarnings = FALSE,
  recursive = TRUE
)


# ------------------------------------------------------------
# 2. Required package
# ------------------------------------------------------------

if (!requireNamespace("pdftools", quietly = TRUE)) {
  stop(
    "Package 'pdftools' is required.\n",
    "Install it once with:\n",
    "install.packages('pdftools')"
  )
}


# ------------------------------------------------------------
# 3. Check input PDF
# ------------------------------------------------------------

if (!file.exists(pdf_file)) {
  stop(
    "PDF not found: ", pdf_file, "\n\n",
    "Expected location:\n",
    pdf_file
  )
}


# ------------------------------------------------------------
# 4. Extract PDF text
# ------------------------------------------------------------

pages <- pdftools::pdf_text(pdf_file)

if (length(pages) == 0) {
  stop("No text was extracted from the PDF.")
}


# ------------------------------------------------------------
# 5. Convert pages into extracted text blocks
#
# A text block is a consecutive group of non-empty lines,
# separated from the next block by one or more blank lines.
# ------------------------------------------------------------

extract_blocks <- function(page_text) {

  # Normalize line endings
  page_text <- gsub("\r\n?", "\n", page_text)

  # Split page into lines
  lines <- strsplit(
    page_text,
    "\n",
    fixed = TRUE
  )[[1]]

  # Remove surrounding whitespace
  lines <- trimws(lines)

  # Identify blank lines
  blank <- nchar(lines) == 0

  # Guard against an empty page
  if (length(lines) == 0) {
    return(character(0))
  }

  # Create block identifiers
  block_id <- cumsum(
    c(TRUE, blank[-length(blank)])
  )

  # Keep only non-empty lines
  keep <- !blank

  lines_kept <- lines[keep]
  block_id_kept <- block_id[keep]

  if (length(lines_kept) == 0) {
    return(character(0))
  }

  # Join lines belonging to the same block
  blocks <- tapply(
    lines_kept,
    block_id_kept,
    paste,
    collapse = " "
  )

  unname(as.character(blocks))
}


blocks_by_page <- lapply(
  pages,
  extract_blocks
)

text_blocks <- unlist(
  blocks_by_page,
  use.names = FALSE
)


# ------------------------------------------------------------
# 6. Clean extracted text blocks
# ------------------------------------------------------------

# Remove surrounding whitespace
text_blocks <- trimws(text_blocks)

# Remove empty blocks
text_blocks <- text_blocks[
  nchar(text_blocks) > 0
]

# Remove standalone PDF page-number artifacts.
# This removes entries such as "1", "2", ..., "24".
# No other short text blocks are removed.
text_blocks <- text_blocks[
  !grepl("^\\d+$", text_blocks)
]


# ------------------------------------------------------------
# 7. Count words in each extracted text block
# ------------------------------------------------------------

count_words <- function(x) {

  x <- trimws(x)

  if (nchar(x) == 0) {
    return(0L)
  }

  words <- unlist(
    strsplit(x, "\\s+")
  )

  words <- words[
    nzchar(words)
  ]

  length(words)
}


words_per_block <- vapply(
  text_blocks,
  count_words,
  integer(1)
)

n_blocks <- length(words_per_block)

if (n_blocks < 2) {
  stop(
    "Fewer than two extracted text blocks were found. ",
    "Bootstrap analysis cannot proceed."
  )
}


# ------------------------------------------------------------
# 8. Observed statistic
# ------------------------------------------------------------

observed_mean <- mean(
  words_per_block
)


# ------------------------------------------------------------
# 9. Bootstrap
#
# Each simulation:
#   - samples the observed text blocks with replacement
#   - uses the same number of blocks as the document
#   - calculates mean words per extracted text block
# ------------------------------------------------------------

bootstrap_mean <- numeric(
  n_boot
)

for (i in seq_len(n_boot)) {

  sampled_blocks <- sample(
    words_per_block,
    size = n_blocks,
    replace = TRUE
  )

  bootstrap_mean[i] <- mean(
    sampled_blocks
  )
}


# ------------------------------------------------------------
# 10. Bootstrap summary
# ------------------------------------------------------------

bootstrap_mean_value <- mean(
  bootstrap_mean
)

bootstrap_sd <- sd(
  bootstrap_mean
)

bootstrap_ci <- quantile(
  bootstrap_mean,
  probs = c(0.025, 0.975)
)


# ------------------------------------------------------------
# 11. Print results
# ------------------------------------------------------------

cat("\n")

cat(
  "Limitation Act, 1963 - Extracted Text Block Bootstrap\n"
)

cat(
  "-----------------------------------------------------\n"
)

cat(
  "PDF pages:                                  ",
  length(pages),
  "\n"
)

cat(
  "Extracted text blocks:                     ",
  n_blocks,
  "\n"
)

cat(
  "Bootstrap resamples:                       ",
  n_boot,
  "\n"
)

cat(
  "Observed mean words per extracted text block:",
  round(observed_mean, 2),
  "\n"
)

cat(
  "Bootstrap mean words per extracted text block:",
  round(bootstrap_mean_value, 2),
  "\n"
)

cat(
  "Bootstrap SD:                              ",
  round(bootstrap_sd, 2),
  "\n"
)

cat(
  "95% percentile lower:                     ",
  round(bootstrap_ci[1], 2),
  "\n"
)

cat(
  "95% percentile upper:                     ",
  round(bootstrap_ci[2], 2),
  "\n"
)

cat("\n")


# ------------------------------------------------------------
# 12. Save observed extracted text blocks
# ------------------------------------------------------------

write.csv(
  data.frame(
    block = seq_len(n_blocks),
    words = words_per_block,
    text = text_blocks
  ),
  file = file.path(
    output_dir,
    "observed_text_blocks.csv"
  ),
  row.names = FALSE
)


# ------------------------------------------------------------
# 13. Save bootstrap results
# ------------------------------------------------------------

write.csv(
  data.frame(
    simulation = seq_len(n_boot),
    mean_words_per_extracted_text_block = bootstrap_mean
  ),
  file = file.path(
    output_dir,
    "10000_bootstrap_results.csv"
  ),
  row.names = FALSE
)


# ------------------------------------------------------------
# 14. Save summary
# ------------------------------------------------------------

summary_table <- data.frame(
  statistic = c(
    "pdf_pages",
    "extracted_text_blocks",
    "bootstrap_resamples",
    "observed_mean_words_per_extracted_text_block",
    "bootstrap_mean_words_per_extracted_text_block",
    "bootstrap_sd",
    "ci_2.5_percent",
    "ci_97.5_percent"
  ),
  value = c(
    length(pages),
    n_blocks,
    n_boot,
    observed_mean,
    bootstrap_mean_value,
    bootstrap_sd,
    bootstrap_ci[1],
    bootstrap_ci[2]
  )
)

write.csv(
  summary_table,
  file = file.path(
    output_dir,
    "simulation_summary.csv"
  ),
  row.names = FALSE
)


# ------------------------------------------------------------
# 15. Produce the single figure
# ------------------------------------------------------------

png(
  filename = file.path(
    output_dir,
    "Figure_1_extracted_text_block_bootstrap.png"
  ),
  width = 1000,
  height = 650,
  res = 120
)

hist(
  bootstrap_mean,
  breaks = 50,
  main = paste(
    "Bootstrap Distribution of Mean Words per",
    "Extracted Text Block"
  ),
  xlab = "Mean words per extracted text block",
  ylab = "Number of bootstrap samples"
)

# Observed mean
abline(
  v = observed_mean,
  lwd = 2
)

# 95% percentile interval
abline(
  v = bootstrap_ci[1],
  lty = 2
)

abline(
  v = bootstrap_ci[2],
  lty = 2
)

dev.off()


# ------------------------------------------------------------
# 16. Completion message
# ------------------------------------------------------------

cat(
  "Files written to: ", output_dir, "\n",
  " - observed_text_blocks.csv\n",
  " - 10000_bootstrap_results.csv\n",
  " - simulation_summary.csv\n",
  " - Figure_1_extracted_text_block_bootstrap.png\n"
)
