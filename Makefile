generate: data/temp/all.nt
	python bin/generate.py

generate+serve_locally: data/temp/all.nt
	python bin/generate.py --site_url http://localhost:8000 --serve

data/temp/void.nt: void.ttl data/temp
	rdfpipe -i turtle -o ntriples $< > $@

data/temp/haushalt_vocab.nt: data/haushalt_vocab.ttl
	rdfpipe -i turtle -o ntriples $< > $@

data/temp/all.nt: data/temp/void.nt data/temp/haushalt_vocab.nt
	rdfpipe -i ntriples -o ntriples $^ > $@

_site:
	mkdir _site

data/temp:
	mkdir data/temp

clean:
	rm -rf _site
	rm -rf data/temp