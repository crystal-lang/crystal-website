OUTPUT_DIR ?= _site

htmlproofer = vendor/bin/htmlproofer

.PHONY: build
build: $(OUTPUT_DIR)

$(OUTPUT_DIR):
	bundle exec jekyll build --destination $(OUTPUT_DIR)

.PHONY: check_html
check_html: $(OUTPUT_DIR) $(htmlproofer)
	$(htmlproofer) $(OUTPUT_DIR) \
		--assume-extension \
		--url-swap "\A\/(images):https://crystal-lang.org/\1" \
		--disable_external \
		--allow-hash-href \
		--checks-to-ignore ImageCheck \
		--check-img-http

.PHONY: check_external_links
check_external_links: $(OUTPUT_DIR) $(htmlproofer)
	$(htmlproofer) $(OUTPUT_DIR) \
		--assume-extension \
		--url-swap "\A\/(api|docs|images|reference):https://crystal-lang.org/\1" \
		--url-ignore "http://0.0.0.0:8080" \
		--http-status-ignore 999 \
		--external_only

$(htmlproofer):
	mkdir -p $(dir $@)
	gem install html-proofer --bindir $(dir $@)

.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR)
