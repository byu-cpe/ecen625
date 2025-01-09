build: install
	bundle exec jekyll build

serve: install
	bundle exec jekyll serve --livereload

install:
	bundle install

check_links: build
	bundle exec htmlproofer --swap-urls "^\/ecen625:"  --ignore-empty-alt --ignore-missing-alt --no-enforce-https --ignore-status-codes "0,200,301,302,403" ./_site

