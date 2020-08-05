FROM frolvlad/alpine-glibc

LABEL maintainer="kazuf3 <steelheart.wolverine@gmail.com>" \
      description="Pandoc for Japanese based on Alpine Linux + Haranoaji font."

# Install Tex Live
ENV TEXLIVE_VERSION 2018
ENV TEXLIVE_REPOGITORY http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/$TEXLIVE_VERSION/tlnet-final/
ENV PATH /usr/local/texlive/$TEXLIVE_VERSION/bin/x86_64-linuxmusl:$PATH

RUN apk --no-cache add perl wget xz tar fontconfig-dev \
 && mkdir -p /tmp/src/install-tl-unx \
 && wget -qO- $TEXLIVE_REPOGITORY/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/src/install-tl-unx --strip-components=1 \
 && printf "%s\n" \
      "selected_scheme scheme-basic" \
      "option_doc 0" \
      "option_src 0" \
      > /tmp/src/install-tl-unx/texlive.profile \
 && /tmp/src/install-tl-unx/install-tl \
      --profile=/tmp/src/install-tl-unx/texlive.profile \
      --repository=$TEXLIVE_REPOGITORY \
 && tlmgr option repository $TEXLIVE_REPOGITORY \
 && tlmgr update --self && tlmgr update --all \
 && tlmgr install \
      collection-basic collection-latex \
      collection-latexrecommended collection-latexextra \
      collection-fontsrecommended collection-langjapanese latexmk \
      luatexbase ctablestack fontspec luaotfload lualatex-math \
      sourcesanspro sourcecodepro \
 && rm -Rf /tmp/src \
 && apk --no-cache del xz 

# Install font
RUN mkdir /usr/share/fonts \
 && wget -q https://github.com/trueroad/HaranoAjiFonts/archive/20200612.zip -O /usr/share/fonts/Haranoaji.zip \
 && unzip /usr/share/fonts/Haranoaji.zip -d /usr/share/fonts/ \
 && rm /usr/share/fonts/Haranoaji.zip \
 && fc-cache -fv \
 && mktexlsr

# Install Pandoc
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/releases/download/2.10.1/pandoc-2.10.1-linux-amd64.tar.gz
ENV PANDOC_ROOT /usr/local/pandoc
ENV PANDOC_DOWNLOAD_SHA 5de8bcdf4c008e4521432cd4af86e7b8f6e309b8373a43b8d51b91825a1cc7e05fd59c24ef606b5ea92403383c9c5cb565f3c5f4335148b30cd4bc92211a7b83
ENV PATH $PATH:$PANDOC_ROOT/bin

RUN apk add --no-cache curl \
 && mkdir -p $PANDOC_ROOT \
 && curl -fsSL "$PANDOC_DOWNLOAD_URL" -o $PANDOC_ROOT/pandoc.tar.gz \
 # && echo "$PANDOC_DOWNLOAD_SHA $PANDOC_ROOT/pandoc.tar.gz" | sha512sum -c - \
 && tar -xzf $PANDOC_ROOT/pandoc.tar.gz -C $PANDOC_ROOT/ && rm $PANDOC_ROOT/pandoc.tar.gz \
 && mv $PANDOC_ROOT/pandoc-2.10.1/bin $PANDOC_ROOT/pandoc-2.10.1/share $PANDOC_ROOT/ 

RUN cd / \
 && curl -fsSL https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.7.0a/pandoc-crossref-Linux-2.10.1.tar.xz -q | tar xJ \
 && mv pandoc-crossref /usr/bin

RUN apk --no-cache del tar curl 

VOLUME ["/workspace", "/root/.pandoc/templates"]
WORKDIR /workspace
