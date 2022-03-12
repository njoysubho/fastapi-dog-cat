## Fastapi service backed by resnet classification model

This service uses fastapi to create a REST API backed by a simple model to classify images of dogs and cat.
The service is containerized and deployed on Heroku.

## Running locally

To run locally use 

```
docker run -p 8001:8001 -e PORT=8001 <image>
```

## Running on Heroku

```
curl -XPOST 'https://dog-cat-fastapi.herokuapp.com/pet' \
--form 'file=@"<your-image-path>"'
```