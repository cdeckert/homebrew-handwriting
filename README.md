# Homebrew tap for Handwriting CLI

This tap installs the native Apple-silicon `handwriting-cli`. It creates
handwritten PDF, PNG, and SVG files locally with Apple Core ML; text and output
never leave the Mac.

## Install

```bash
brew tap cdeckert/handwriting
brew install handwriting-cli
```

Requirements: an Apple-silicon Mac, macOS 14 or newer, and Xcode 16 or newer.

## Use

```bash
handwriting-cli \
  --text "Ein kurzer handschriftlicher Text." \
  --output note.pdf

handwriting-cli \
  --input brief.txt \
  --output brief.pdf \
  --style 4 \
  --font-size 32 \
  --seed 2026

cat brief.txt | handwriting-cli --input - --output pages.png
```

The default `auto` engine uses the neural handwriting model when possible and
switches to the local Unicode renderer for umlauts, accents, symbols, or other
scripts. Run `handwriting-cli --help` for all options and
`handwriting-cli --list-styles` for the 13 included styles.

## Update

```bash
brew update
brew upgrade handwriting-cli
```

## Development

Install and test the formula directly from a checkout:

```bash
brew install --build-from-source ./Formula/handwriting-cli.rb
brew test handwriting-cli
brew style ./Formula/handwriting-cli.rb
```

The formula pins a source revision and checksum so installs are reproducible.
For a new upstream release, update `url`, `version`, and `sha256` together, then
run all three commands above. Once the tap has been added locally, also run
`brew audit --strict cdeckert/handwriting/handwriting-cli`.
