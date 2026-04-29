# Main LaTeX file (without .tex extension)
MAIN = report

# Default target
all: pdf

# Compile LaTeX to PDF
pdf:
	pdflatex $(MAIN).tex
	pdflatex $(MAIN).tex   # run twice for references/TOC

# Open PDF (Mac)
open:
	open $(MAIN).pdf

# Clean auxiliary files
clean:
	rm -f *.aux *.log *.out *.toc *.lof *.lot

# Remove everything including PDF
fullclean: clean
	rm -f $(MAIN).pdf

# Rebuild from scratch
rebuild: fullclean pdf
