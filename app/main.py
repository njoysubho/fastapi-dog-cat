from typing import Optional

from fastapi import FastAPI
from fastapi import File, UploadFile
from PIL import Image
from io import BytesIO
from app.model import DogCatModel
from torchvision import transforms
import torch
import torchvision.models as models

app = FastAPI()

def read_imagefile(data) -> Image.Image:
    image = Image.open(BytesIO(data))
    return image

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/pet/")
async def predict(file: UploadFile=File(...)):
    image = read_imagefile(await file.read())
    tfms= transforms.Compose([
                                            transforms.Resize((224,224)),
                                            transforms.RandomRotation(20),
                                            transforms.RandomVerticalFlip(p=0.1),
                                            transforms.ToTensor(),
                                            transforms.Normalize((0.485, 0.456, 0.406), (0.229, 0.224, 0.225)),
                                            ])
    image = tfms(image)
    image = image[None,:]
    dcModel = DogCatModel(models.resnet34(pretrained=False))
    dcModel.load_state_dict(torch.load('/code/model.pth',map_location=torch.device('cpu')))
    dcModel.eval()
    with torch.no_grad():
        prediction= dcModel(image)
        _,label = torch.max(prediction,dim=1)
        label = label.item()
    return {"prediction": label}


    

