# alpine-pandoc-ja [![Docker Automated build](https://img.shields.io/docker/build/kazuf3/docker-alpine-pandoc-ja)](https://hub.docker.com/repository/docker/kazuf3/docker-alpine-pandoc-ja/builds)

Pandoc for Japanese based on Alpine Linux. This image contains

- Tex Live 2018
- pandoc 2.10.1
- pandoc-crossref 2.10.1
- Harano Aji Font 20200612

## Usage

```sh
$ docker pull kazuf3/alpine-pandoc-ja
$ docker run -it --rm -v `pwd`:/workspace kazuf3/alpine-pandoc-ja pandoc input.md -f markdown -o output.pdf --pdf-engine=lualatex
```

### Use Template

```
$ mkdir templates
$ wget https://raw.githubusercontent.com/Wandmalfarbe/pandoc-latex-template/master/eisvogel.tex -O templates/eisvogel.tex
$ docker run -it --rm -v `pwd`:/workspace -v `pwd`/templates:/root/.pandoc/templates kumassy/pandoc:latest pandoc input.md -f markdown -o output.pdf --pdf-engine=lualatex --template eisvogel.tex
```

## Reference Dockerfile

- [kumassy/docker-alpine-pandoc-ja](https://github.com/kumassy/docker-alpine-pandoc-ja)
- [k1low/alpine-pandoc-ja](https://github.com/k1LoW/docker-alpine-pandoc-ja)
- [portown/alpine-pandoc](https://github.com/portown/alpine-pandoc)
- [paperist/alpine-texlive-ja](https://github.com/Paperist/docker-alpine-texlive-ja)


