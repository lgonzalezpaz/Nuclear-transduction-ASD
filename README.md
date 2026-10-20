# Nuclear-transduction-ASD

Code and derived data for:

> Alvarado Y.J., Quintero M., Cardozo-Urdaneta A., Lossada C., Marrero-Ponce Y., Martinez-Rios F., Pérez-Castillo Y., Delgado A., González-Paz L.
> **How an under-pruned cortex rewrites its splicing code: Ca²⁺-tuned condensates outcompete transcription-speed and mechanical routes in idiopathic autism.** (2026, submitted)

The study first shows that the microexon deficit of idiopathic-autism cortex is post-transcriptional, adolescent-onset and switch-like, and then asks *how* a circuit-level surplus of synapses (adolescent pruning failure) reaches the nuclear splicing machinery. Three physical transduction channels are confronted:

| Channel | Mechanism | Main tests |
|---|---|---|
| **H-E** "exhausts the nucleus" | nuclear Ca²⁺/CaMK phosphorylation of the SRRM4–SRSF11–RNPS1 microexon condensate (lever rule) + ATP supply–demand | E-score fingerprint (Srrm4-KO), donor switch, activity coupling, energy budget, emergent ultrasensitivity |
| **H-K** "accelerates or brakes transcription" | RNA Pol II elongation rate → kinetic coupling | K-score fingerprint (slow Pol II neurons), sign of the required Δln v, within-gene coherence |
| **H-M** (null) | traction forces of synapse elimination → LINC → nucleus | Monte Carlo force bound, lamina-associated domains |

Everything uses public data and runs on a laptop (≈20–25 min, ≈1.2 GB of downloads; no GPU, no cluster).

## Quick start

```bash
git clone https://github.com/lgonzalezpaz/Nuclear-transduction-ASD.git
cd Nuclear-transduction-ASD
conda env create -f environment.yml && conda activate nuclear-transduction-asd   # or: pip install -r requirements.txt
bash run_all.sh
```

`run_all.sh` downloads all inputs at pinned versions, verifies SHA-256 checksums (`data/checksums.sha256`), and regenerates every result table (`results/`), figure (`figures/`) and the Supplementary Data workbook. Requirements: Python ≥ 3.11, `git`, Linux x86-64 (for the UCSC `liftOver` binary; on macOS download the corresponding binary from hgdownload.soe.ucsc.edu/admin/exe/).

## Pipeline

| Script | Purpose | Main outputs |
|---|---|---|
| `code/00_download_data.py` | retrieve inputs (GitHub at pinned commits, Europe PMC supplements, UCSC) and verify checksums | `data/raw/` |
| `code/01_prepare_exons.py` | parse cassette exons; hg19 features (MaxEntScan, UGC, PPT, UGCAUG, intron lengths, GC) | `data/processed/exons_features.tsv` |
| `code/02_mouse_exon_sets.py` | Srrm4-KO, slow-Pol II and KCl exons lifted to hg19 | `data/processed/mouse_sets_hg19.tsv` |
| `code/03_asd_dpsi.py` | composition-adjusted ASD ΔPSI with donor-clustered SE; activity/OXPHOS/Ca-kinase indices | `results/exon_dpsi.tsv` |
| `code/03b_sf_transfer.py` | splicing-factor expression per neuron; donor microexon mixture; dose-response; Bayesian calibration of the scaffold-microexon transfer function | `results/sf_expression.tsv`, `transfer_calibration.tsv` |
| `code/04_signatures.py` | E-score and K-score fingerprints (gene-grouped CV) | `results/exon_scores.tsv`, `cv_E.tsv`, `cv_K.tsv` |
| `code/05_model_selection.py` | WLS model selection, permutation, direct signatures, ICC, KCl | `results/T1`–`T4` |
| `code/06_donor_level.py` | donor indices, mixture LRT (bootstrap), activity coupling | `results/T5`, `donor_indices.tsv` |
| `code/07_replication.py` | robustness and cerebellar replication | `results/T6` |
| `code/08_biophysics.py` | first-principles channels, prior-predictive Bayes factors, ABC, subgroup, Sobol, mechanics | `results/biophysics_*` |
| `code/09_lad_test.py` | lamina-associated-domain test of the mechanical null | `results/T7_lad.tsv` |
| `code/10_figures.py` | Figures 1–6, S1, S2 (PDF + 600-dpi PNG) | `figures/` |
| `code/11_supplementary_tables.py` | Supplementary Data workbook and exon-level source data | `results/Supplementary_Data.xlsx` |
| `code/biophys.py` | model library (equations 1–10 of the paper) | — |

## Data sources

| Data | Reference | Location |
|---|---|---|
| Cassette-exon PSI (cortex, cerebellum) | Parikshak et al. 2016, *Nature* 540:423 | github.com/dhglab/Genome-wide-changes-in-lncRNA-alternative-splicing-and-cortical-patterning-in-autism (commit b9c61ac) |
| Cortical RNA-seq | Gandal et al. 2022, *Nature* 611:532 | github.com/dhglab/Broad-transcriptomic-dysregulation-across-the-cerebral-cortex-in-ASD (commit 6821cc5) |
| Srrm4-mutant splicing | Quesnel-Vallières et al. 2015, *Genes Dev* 29:746 | Europe PMC PMC4387716, Table S2 |
| Slow Pol II splicing, elongation, expression | Maslon et al. 2019, *EMBO J* 38:e101244 | Europe PMC PMC6484407, Tables EV1–EV3 |
| KCl-responsive exons | Krick et al. 2025, *Genome Res* 35:1301 | Europe PMC PMC12129014, Table S9 |
| hg19, liftOver chains, LADs | UCSC Genome Browser | hgdownload.soe.ucsc.edu; api.genome.ucsc.edu |
| MaxEntScan models | Yeo & Burge 2004 | github.com/kepbod/maxentpy (commit b5e69aa) |

No new human or animal data were generated. All inputs are de-identified, processed public data.

## Reproducibility notes

* Random seeds are fixed in every script; outputs are bit-identical across runs on the same platform.
* If an upstream file changes, `00_download_data.py` stops with a checksum mismatch.
* Expected key results: ΔAIC (vs nuisance) H-E 67.5, H-K 27.7; E-score CV AUC 0.80; K-score CV ρ 0.20; donor scaffold mixture π 0.29 (P = 0.028); emergent Hill coefficient median 4.9 (calibrated on cortex: 7.4, 95% interval 1.9–14.6); per-neuron SRRM4 log2FC +0.001 (P = 0.99); mechanical median 0.044% of basal nuclear load.

## Licence

Code: MIT (`LICENSE`). Derived data, results and figures: CC BY 4.0 (`LICENSE-DATA`). Third-party input data remain under their original terms.

## Citation

See `CITATION.cff`. Please also cite the original data providers listed above.
