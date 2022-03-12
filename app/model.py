import torch.nn as nn
class DogCatModel(nn.Module):
    def __init__(self,model):
        super(DogCatModel,self).__init__()
        self.model = model
        self.model.fc = nn.Linear(self.model.fc.in_features,2)
    def forward(self,image):
        return self.model(image)