# Text Length in the *Limitation Act, 1963*

Reproducible descriptive analysis of word counts from the official India Code PDF of the *Limitation Act, 1963*.

**Result:** 303.28 words per PDF-extracted text block (36 blocks).

**Method:** R, `pdftools::pdf_text()`, whitespace-delimited word counts, 10,000 bootstrap resamples, seed `1963`.

**Note:** `\setmainfont{Noto Serif}` in the YAML needs XeLaTeX or LuaLaTeX to compile successfully.

Author: Harsh Torane · 30 August 2026

Please cite it as:
> Torane, H. “Text Length in the Limitation Act, 1963”. Preprint, Zenodo, September 11, 2026. [10.5281/zenodo.22234824](https://doi.org/10.5281/zenodo.22234824)
