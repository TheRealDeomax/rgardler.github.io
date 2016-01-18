docker rm -f jekyll
docker run --rm -v "/$PWD:/src" -p 80:4000 --name jekyll grahamc/jekyll serve -H $CLIENT_IP --drafts --force_polling
