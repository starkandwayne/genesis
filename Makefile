.PHONY: test test-quick test-secrets test-ci release dev-release clean

test: test-quick test-secrets

test-ci:
	prove t/*.t

test-quick:
	ls t/*.t | grep -v secrets.t | xargs prove

test-secrets:
	@echo 'prove t/secrets.t'
	@prove t/secrets.t ; rc=$$? ; for pid in $$(ps | grep '[\.]/t/vaults/vault-' | awk '{print $$1}') ; do kill -TERM $$pid; done ; exit $$rc

release:
	@if [[ -z $$VERSION ]]; then echo >&2 "No VERSION specified in environment; try \`make VERSION=2.0 release'"; exit 1; fi
	@echo "Cutting new Genesis release (v$$VERSION)"
	./pack $$VERSION

dev-release:
	@echo "Cutting new **DEVELOPER** Genesis release"
	./pack

clean:
	rm -f genesis-*
