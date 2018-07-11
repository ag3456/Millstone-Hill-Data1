from django.db import models
from django.utils import timezone
from datetime import datetime

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')
    madrigalUrl = models.CharField(max_length=200, default = " ")
    name = models.CharField(max_length=400, default = " ")
    realUrl = models.CharField(max_length =200, default = " ")
    url= models.CharField(max_length=200, default= " ")
    
    def __str__(self):
        return self.question_text
        return self.pub_date
        return self.madrigalUrl
        return self.name
        return self.realUrl
        return self.url



# Create your models here.