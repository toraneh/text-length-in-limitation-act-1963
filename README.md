# Text Length in the *Limitation Act, 1963*: A Reproducible Descriptive Analysis

A reproducible analysis of word-count variation in the official India Code PDF of the *Limitation Act, 1963* using bootstrap resampling.

## Summary

This study analyzes text-length variation across 36 text blocks extracted from the official India Code PDF of the *Limitation Act, 1963*. Bootstrap resampling (10,000 iterations, seed = 1963) yields a mean text length of approximately 303.28 words per block and provides uncertainty estimates for this descriptive statistic.

## Methodology

**Data source**
- Official India Code PDF of the *Limitation Act, 1963*

**Analysis approach**
1. Text extraction via `pdftools::pdf_text()` in R
2. Word counting using whitespace-delimited boundaries
3. Text segmentation into 36 distinct blocks
4. Variability estimation through 10,000 bootstrap resamples with replacement
5. Fixed seed: 1963 (reproducibility)

**Software environment**
- Language: R
- Key package: `pdftools` (PDF text extraction)

## Results

Mean text length: **303.28 words** (n = 36 blocks, 10,000 bootstrap iterations)

Bootstrap results and summary statistics are available in the `output/` directory.

## Repository contents

- `analysis.R` — Complete R script for full reproduction
- `data/` — Source PDF and extracted text blocks
- `output/` — Bootstrap results and summary statistics

## Reproducibility

Execute the analysis:
```r
source("analysis.R")
```

All results regenerate using the fixed seed `1963`.

**Technical note:** The source document specifies XeLaTeX or LuaLaTeX font engines (`\setmainfont{Noto Serif}` in the YAML preamble). Compilation requires one of these engines; pdfLaTeX will fail.

## Citation

Torane, H. (2026). Text Length in the *Limitation Act, 1963*. *Preprint*. Zenodo. https://doi.org/10.5281/zenodo.22234824

## License

Code and materials are provided for research and educational use.

---

**Date:** August 30, 2026 | **Published:** September 11, 2026
