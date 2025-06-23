bundle exec jekyll build
cd ./_site/
rsync -avh . mathexp.eu:www/mohr
cd ../
