#!/usr/bin/env bash
# Reproduce every result, table and figure of the study (about 20-25 min on a laptop, ~1.2 GB of downloads).
set -euo pipefail
cd "$(dirname "$0")"
python code/00_download_data.py
pip install -q ./data/raw/maxentpy
python code/01_prepare_exons.py        # exon architecture & sequence features (hg19)
python code/02_mouse_exon_sets.py      # Srrm4-KO, slow-Pol II and KCl exons lifted to hg19
python code/03_asd_dpsi.py             # composition-adjusted ASD dPSI (cortex)
python code/03b_sf_transfer.py         # SF expression per neuron, microexon mixture, transfer-function calibration
python code/04_signatures.py           # E-score and K-score fingerprints
python code/05_model_selection.py      # T1-T4: model selection, direct signatures, ICC, KCl
python code/06_donor_level.py          # T5: donor-level switch and activity coupling
python code/07_replication.py          # T6: robustness and cerebellar replication
python code/08_biophysics.py           # first-principles channels, ABC, Sobol, mechanics
python code/09_lad_test.py             # T7: lamina-associated domains
python code/10_figures.py              # Figures 1-6 and S1
python code/11_supplementary_tables.py # Supplementary tables (xlsx)
echo "Done. Results in results/, figures in figures/."
