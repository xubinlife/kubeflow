FROM tensorflow/tensorflow:1.4.0-rc1-devel-gpu-py3

LABEL maintainer="Bin Xu <xubin1@nuctech.com>"

USER root

# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN rm -f /usr/bin/python && \
    ln -s /usr/bin/python3 /usr/bin/python

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
 
RUN pip install --yes \
    notebook \
    jupyterhub \
    jupyterlab \
    jupyter-tensorboard -i http://pypi.douban.com/simple --trusted-host pypi.douban.com && \
  python -m ipykernel.kernelspec && \
  jupyter nbextension enable --py widgetsnbextension --sys-prefix
  
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    rm -rf facets

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /root/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin
COPY start-singleuser.sh /usr/local/bin
COPY jupyter_notebook_config.py /etc/jupyter/

RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/start-notebook.sh /usr/local/bin/start-singleuser.sh

WORKDIR /root

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
