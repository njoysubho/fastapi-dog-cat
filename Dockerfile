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
# pip install aws cli
RUN pip3 install awscli 
ARG MODEL_NAME
ARG AWS_ACCESS_ID
ARG AWS_ACCESS_SECRET
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_SECRET
ENV AWS_DEFAULT_REGION=eu-west-1
# Copy model files
RUN aws s3 cp s3://datascience-sab/${MODEL_NAME}.pth .

COPY requirements.txt .

RUN pip3 install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app 

EXPOSE $PORT

CMD gunicorn -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT app.main:app