FROM ubuntu:20.04

WORKDIR /code
# install utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install -y python3.8 python3-distutils python3-pip python3-apt
# Installing python dependencies
RUN python3 -m pip --no-cache-dir install --upgrade pip && \
    python3 --version && \
    pip3 --version

# Copy model files
COPY model/model.pth .
COPY requirements.txt .

RUN pip3 install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app 

EXPOSE $PORT

CMD gunicorn -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT app.main:app