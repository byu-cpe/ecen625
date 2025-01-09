build: install
	bundle exec jekyll build

serve: install
	bundle exec jekyll serve --livereload

install:
	bundle install

check_links: build
	bundle exec htmlproofer --swap-urls "^\/ecen625:"  --allow_missing_href=true --ignore-status-codes "0,200,301" ./_site

