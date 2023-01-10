build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve

# deploy:
# 	bundle exec jekyll build
# 	ssh byu-domains "rm -rf public_html/courses/ecen625/*"
# 	scp -r _site/* byu-domains:public_html/courses/ecen625/

develop_docker:
	docker run --rm --volume="$$PWD:/srv/jekyll" -p 4000:4000 -p 35729:35729 -it jekyll/jekyll:4.0 jekyll serve --livereload

build_docker:
	docker run --rm --volume="$$PWD:/srv/jekyll" -it jekyll/jekyll:4.0 jekyll build

check_links: build
	bundle exec htmlproofer --swap-urls "^\/ecen625:"  --allow_missing_href=true --ignore-status-codes "0,301" ./_site

