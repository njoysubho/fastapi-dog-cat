FROM nvidia/cuda:11.2.0-runtime-ubuntu20.04

WORKDIR /code
# install utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl

ENV CONDA_AUTO_UPDATE_CONDA=false \
    PATH=/opt/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/miniconda \
    && rm ~/miniconda.sh \
    && sed -i "$ a PATH=/opt/miniconda/bin:\$PATH" /etc/environment

# Installing python dependencies
RUN python3 -m pip --no-cache-dir install --upgrade pip && \
    python3 --version && \
    pip3 --version

RUN pip3 --timeout=300 --no-cache-dir install torch==1.9.1+cu111 -f https://download.pytorch.org/whl/cu111/torch_stable.html

#COPY ./requirements.txt .
#RUN pip3 --timeout=300 --no-cache-dir install -r requirements.txt

# Copy model files
COPY model/model.pth .
COPY requirements.txt .

RUN pip3 install --no-cache-dir --upgrade -r /code/requirements.txt

# Copy app files
COPY ./app /code/app 

EXPOSE $PORT
#CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT
CMD gunicorn -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT app.main:app