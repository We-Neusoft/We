from django.db import models

# Create your models here.
class Classification(models.Model):
   name = models.TextField()
   level = models.IntegerField(primary_key=True)

class Software(models.Model):
   name = models.TextField()
   name_english = models.TextField()
   name_pinyin_full = models.TextField(primary_key=True)
   name_pinyin_short = models.TextField()
   classification = models.ManyToManyField(Classification)
