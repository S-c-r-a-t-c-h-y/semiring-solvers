SRC_DIR   := ../idris-frex/src
BUILD_DIR := ../idris-frex/build/ttc/2025081600
OUT_DIR   := generated

# Find all Idris source files recursively under src/
IDR_FILES := $(shell find $(SRC_DIR) -type f -name '*.idr')

# Map src/foo/bar.idr -> generated/foo/bar.tex
TEX_FILES := $(patsubst $(SRC_DIR)/%.idr,$(OUT_DIR)/%.tex,$(IDR_FILES))

.PHONY: all one clean list

all: $(TEX_FILES)

# Build one LaTeX file from one Idris file if the matching .ttm exists.
# If it doesn't exist, print a warning and continue.
$(OUT_DIR)/%.tex: $(SRC_DIR)/%.idr
	@mkdir -p $(dir $@)
	@if [ -f "$(BUILD_DIR)/$*.ttm" ]; then \
		echo "Generating $@"; \
		katla latex "$<" "$(BUILD_DIR)/$*.ttm" --snippet > "$@"; \
	else \
		echo "Skipping $< (missing $(BUILD_DIR)/$*.ttm)"; \
		rm -f "$@"; \
	fi

# Build a single file:
#   make one FILE=foo/bar
#   make one FILE=foo/bar.idr
#   make one FILE=src/foo/bar.idr
#   make one FILE=foo/bar OUT=custom/path/output.tex
#   make one FILE=src/foo/bar.idr OUT=output.tex
#
# If OUT is omitted, defaults to generated/foo/bar.tex
one:
	@test -n "$(FILE)" || (echo "Usage: make one FILE=path/to/file[.idr] [OUT=path/to/output.tex]"; exit 1)
	@f='$(FILE)'; \
	f=$${f#$(SRC_DIR)/}; \
	f=$${f%.idr}; \
	src="$(SRC_DIR)/$$f.idr"; \
	ttm="$(BUILD_DIR)/$$f.ttm"; \
	out='$(OUT)'; \
	if [ -z "$$out" ]; then out="$(OUT_DIR)/$$f.tex"; fi; \
	if [ ! -f "$$src" ]; then \
		echo "Source file not found: $$src"; \
		exit 1; \
	fi; \
	mkdir -p "$$(dirname "$$out")"; \
	if [ -f "$$ttm" ]; then \
		echo "Generating $$out"; \
		katla latex "$$src" "$$ttm" --snippet > "$$out"; \
	else \
		echo "Skipping $$src (missing $$ttm)"; \
		rm -f "$$out"; \
	fi

# Optional helper to show discovered source files
list:
	@printf '%s\n' $(IDR_FILES)

clean:
	rm -rf $(OUT_DIR)
