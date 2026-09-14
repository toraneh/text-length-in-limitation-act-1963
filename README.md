# Text Length in the *Limitation Act, 1963*

A reproducible descriptive analysis of word counts and variation from the official India Code PDF of the *Limitation Act, 1963*.

## Summary of Findings

- **Mean text length:** 303.28 words per PDF-extracted text block (across 36 blocks)
- **Methodology:** Bootstrap resampling with 10,000 iterations
- **Random seed:** 1963

## Methodology

### Data Source

The analysis uses the official India Code PDF of the *Limitation Act, 1963*. Text was extracted and segmented into 36 distinct text blocks.

### Analysis Approach

1. **Text extraction:** `pdftools::pdf_text()` in R
2. **Word counting:** Whitespace-delimited word boundaries
3. **Variability estimation:** 10,000 bootstrap resamples with replacement
4. **Seed:** 1963 for reproducibility

### Software Environment

- **Language:** R
- **Key package:** `pdftools` (for PDF text extraction)
- **Reproducibility:** Fixed random seed ensures identical results across runs

## Data and Reproducibility

### Repository Contents

- `analysis.R` — Complete R script for reproduction
- `data/` — Source PDF and extracted data
- `output/` — Bootstrap results and summary statistics

### Running the Analysis

Execute:

```r
source("analysis.R")
```

All results will be regenerated using the fixed seed `1963`.

### Technical Note

The source document includes XeLaTeX or LuaLaTeX font specifications (`\setmainfont{Noto Serif}` in the YAML preamble). Compilation requires one of these engines; pdfLaTeX will fail.

## Citation

Please cite this work as:

```
Torane, H. (2026). Text Length in the Limitation Act, 1963. 
Preprint. Zenodo. 
https://doi.org/10.5281/zenodo.22234824
```

## License

Unless otherwise specified, the accompanying code and materials are provided for research and educational use.

## Author

Harsh Torane

---

**Date:** August 30, 2026 | **Published:** September 11, 2026
