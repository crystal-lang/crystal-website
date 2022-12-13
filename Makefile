-include Makefile.local # for optional local options

# Recipes for this Makefile

## Build the site
##   $ make
## Run local server
##   $ make serve
## Validate generated HTML:
##   $ make check_html check_external_links
## Clean up output directory
##   $ make clean

O ?= _site## Output path

cache ?=1## enable caching for htmlproofer external link check

htmlproofer = vendor/bin/htmlproofer

CONTENT_SOURCES := $(wildcard assets/**) $(wildcard _data/**) $(wildcard _events/**) $(wildcard _pages/**) $(wildcard _posts/**) $(wildcard _releases/**)
SITE_SOURCES := feed.xml _config.yml index.html Makefile $(wildcard _includes/**) $(wildcard _layouts/**) $(wildcard _plugins/**) $(wildcard _sass/**) $(wildcard scripts/**) $(wildcard _style_guide/**)
ALL_SOURCES := $(CONTENT_SOURCES) $(THEME_SOURCES)

.PHONY: all
all: build

.PHONY: build
build: $(O) ## Build site

.PHONY: serve
serve: deps ## Run a local HTTP server with this site
	bundle exec jekyll serve --watch --livereload --incremental --strict_front_matter  --destination $(O)

$(O): deps $(ALL_SOURCES)
	bundle exec jekyll build --strict_front_matter --destination $(O)

.PHONY: deps
deps: Gemfile.lock
	(bundle check 2>&1 > /dev/null) || bundle install

Gemfile.lock: Gemfile
	bundle install

.PHONY: update_sponsors
update_sponsors: scripts/merge.cr fetch_opencollective ## Update sponsor data (fetch from opencollective and merge into _data/sponsors.csv)
	crystal $<

.PHONY: fetch_opencollective
fetch_opencollective: scripts/opencollective.cr
	crystal $<

.PHONY: check_html
check_html: $(O) $(htmlproofer) ## Validates generated HTML
	$(htmlproofer) $(O) \
		--assume-extension \
		--url-swap "\A\/(images):https://crystal-lang.org/\1" \
		--disable_external \
		--allow-hash-href \
		--checks-to-ignore ImageCheck \
		--check-img-http

.PHONY: check_external_links
check_external_links: $(O) $(htmlproofer) ## Validates external links in generated HTML
	$(htmlproofer) $(O) \
		--assume-extension \
		--url-swap "\A\/(api|docs|images|reference):https://crystal-lang.org/\1" \
		--url-ignore "http://0.0.0.0:8080" \
		--http-status-ignore 999 \
		--external_only \
		$(if $(cache),--timeframe '30d',)

$(htmlproofer):
	mkdir -p $(dir $@)
	gem install --version 3.19.3 html-proofer --bindir $(dir $@)

.PHONY: clean
clean: ## Removes output directory
	rm -rf $(O)

.PHONY: help
help: ## Show this help
	@echo
	@printf '\033[34mtargets:\033[0m\n'
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) |\
		sort |\
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo
	@printf '\033[34moptional variables:\033[0m\n'
	@grep -hE '^[a-zA-Z_-]+ \?=.*?## .*$$' $(MAKEFILE_LIST) |\
		sort |\
		awk 'BEGIN {FS = " \\?=.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo
	@printf '\033[34mrecipes:\033[0m\n'
	@grep -hE '^##.*$$' $(MAKEFILE_LIST) |\
		awk 'BEGIN {FS = "## "}; /^## [a-zA-Z_-]/ {printf "  \033[36m%s\033[0m\n", $$2}; /^##  / {printf "  %s\n", $$2}'
