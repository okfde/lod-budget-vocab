# Creating a static site with Jinja-RDF

- Create a folder for your project:

```
$ mkdir haushalt
$ cd haushalt
```

- Jinja-RDF is a python tool, so create a `requirements.txt` file in the root of your folder.
- To add Jinja-RDF as a requirement, add the following line to the file (which is otherwise probably empty):

```
jinja-rdf @ git+https://github.com/berlinonline/jinjardf@main
```

- Create a virtual environment for your project and activate it:

```
haushalt $ python -m venv venv
haushalt $ . venv/bin/activate
(venv) haushalt $
```

- Install the requirements (i.e., Jinja-RDF):

```
(venv) haushalt $ pip install -r requirements.txt
Collecting jinja-rdf@ git+https://github.com/berlinonline/jinjardf@main (from -r requirements.txt (line 1))
…
Installing collected packages: jinja-rdf
Successfully installed jinja-rdf-0.0.1
```

- You're building a site based on RDF data, so you need to put a file with the data somewhere. Create a folder called `data` and put it there (you could put it anywhere, but `data` is a good convention):

```
(venv) haushalt $ mkdir data
```

- In our example we're working with a vocabulary for budget data in a file called `haushalt_vocab.ttl`, so now we have `data/haushalt_vocab.ttl`.
- All subjects in the data (i.e. the vocabulary) are in the namespace `https://ld.example.com/bund/finanz/haushalt/`, for which there is a prefix `hh`:

```turtle
@prefix hh: <https://ld.example.com/bund/finanz/haushalt/> .
```

- Because we want to create a site for serving URIs in this namespace, the base of the namespace needs to be the domain and path where our site will be hosted! So, `https://ld.example.com/` is probably not going to work.
- Let's say we want to host through Github-Pages in an organisation `okfde` in a repository `lod-budget-vocab`. Then our namespace would have to be (or at least start with): `https://okfde.github.io/lod-budget-vocab/`. So we change the prefix definition to:

```turtle
@prefix hh: <https://okfde.github.io/lod-budget-vocab/> .
```

- To generate the site, we need a configuration file for Jinja-RDF. Put a file `config.yml` in the project root, with the following content (explanations inline):

```yaml
# the following two settings are determined by the namespace of the data/vocab we want to serve
base_url: 'https://okfde.github.io' # the base hostname & protocol for your site, e.g. http://example.com
base_path: '/lod-budget-vocab' # the subpath of your site, e.g. /blog

# where is the data:
dataset_path: 'data/haushalt_vocab.ttl'

# where are the templates:
template_path: 'templates'

# where should we put the generated site (locally):
output_path: '_site/'

# RDF prefixes that can be used in the templates (in UPPERCASE) and in SPARQL queries (as is):
# (should include the namespace of our data)
prefixes:
  berorgs: https://berlin.github.io/lod-vocabulary/berorgs/
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/
  hh: https://okfde.github.io/lod-budget-vocab/
  lodsg: https://berlinonline.github.io/lod-sg/
  org: http://www.w3.org/ns/org#
  rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns#
  rdfs: http://www.w3.org/2000/01/rdf-schema#
  schema: https://schema.org/
  void: http://rdfs.org/ns/void#
  xsd: http://www.w3.org/2001/XMLSchema#

# files or folders that should be copied into the generated site:
include:
  - assets/

# a mapping from RDF classes to templates:
# (Everything not included in the mapping will use the default template.)
class_template_mappings:
  "void:Dataset": "dataset.html.jinja"
```
