# ucli-kit

Shared style kit of the ucli sites: plain CSS and JS, no build step. Version in `VERSION`, checksums
in `SHA256SUMS` (`scripts/check-kit.sh` verifies them). The canonical copy is this folder in
ucli-website; the other ucli repos hold verbatim copies. Change it here first, then copy it.

| File | Layer |
|---|---|
| `tokens.css` | shared: fonts, colour, type, spacing, light and dark |
| `base.css` | shared: the `u-*` components (selectors are `.u-*` only) |
| `prose.css` | Astro sites only: reset and element defaults |
| `copy.js`, `theme.js` | Copy buttons; light/dark toggle for the Astro sites |
| `mark.svg` | favicon and logo |
| `specimen.html` | every component on one page (not indexed) |

## Fonts

Self-hosted, Latin subset (the Latin ranges of the Google Fonts/fontsource subset), WOFF2. The
licence of each family ships next to the files: `fonts/OFL-Source-Serif.txt`, `fonts/OFL-IBM-Plex.txt`
(SIL Open Font License 1.1). The upstream files were not edited beyond subsetting.

| Files | Family | Upstream release | Source file | Licence text from |
|---|---|---|---|---|
| `source-serif-4-400`, `-400-italic`, `-600` | Source Serif 4 (Regular, Italic, Semibold; text cut) | 4.005R, https://github.com/adobe-fonts/source-serif/releases/tag/4.005R (`source-serif-4.005_WOFF2.zip`, `TTF/`) | `SourceSerif4-Regular/It/Semibold.ttf.woff2` | https://github.com/adobe-fonts/source-serif/blob/4.005R/LICENSE.md |
| `ibm-plex-sans-400`, `-600` | IBM Plex Sans (Regular, SemiBold) | @ibm/plex-sans@1.1.0, https://github.com/IBM/plex/releases/tag/%40ibm%2Fplex-sans%401.1.0 (`ibm-plex-sans.zip`) | `fonts/complete/woff2/IBMPlexSans-Regular/SemiBold.woff2` | `LICENSE.txt` in that zip |
| `ibm-plex-mono-400`, `-500` | IBM Plex Mono (Regular, Medium) | @ibm/plex-mono@2.5.0, https://github.com/IBM/plex/releases/tag/%40ibm%2Fplex-mono%402.5.0 (`ibm-plex-mono.zip`) | `fonts/complete/woff2/IBMPlexMono-Regular/Medium.woff2` | `LICENSE.txt` in that zip (identical to Plex Sans) |

Subset command (fontTools 4.46):
`python3 -m fontTools.subset <upstream.woff2> --unicodes=U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+0304,U+0308,U+0329,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD --flavor=woff2 --layout-features='*' --no-hinting --desubroutinize --output-file=<out.woff2>`

## Fallback metrics

Measured from the files in `fonts/` with fontTools (average advance of a-z, hhea ascent and descent
over unitsPerEm) against the Liberation faces that stand in for Times New Roman, Arial and Courier New.

| Face | Average a-z (font / fallback) | size-adjust | ascent / descent override |
|---|---|---|---|
| Source Serif Fallback | 0.5103 / 0.4593 | 111.1% | 93.2% / 30.2% |
| Plex Sans Fallback | 0.5050 / 0.4895 | 103.2% | 99.4% / 26.7% |
| Plex Mono Fallback | 0.6000 / 0.6001 | 100% | 102.5% / 27.5% |

The design's draft numbers for Source Serif (119.9%, 86.4%, 27.9%) came from a different cut and
differ by more than 0.5 point, so the measured values are used.
