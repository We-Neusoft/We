from django.db import models

# Create your models here.
class Classification(models.Model):
   name = models.CharField(max_length=None)
   level = models.IntegerField(primary_key=True)

class Software(models.Model):
   name = models.CharField(max_length=None)
   name_english = models.CharField(max_length=None)
   name_pinyin_full = models.CharField(max_length=None, primary_key=True)
   name_pinyin_short = models.CharField(max_length=None)
   classification = models.ManyToManyField(Classification)