from django.db import models

class Classification(models.Model):
   name = models.TextField()
   name_english = models.TextField(primary_key=True)
   name_pinyin_full = models.TextField()
   name_pinyin_short = models.TextField()
   def __unicode__(self):
      return self.name

class Software(models.Model):
   name = models.TextField()
   name_english = models.TextField(primary_key=True)
   name_pinyin_full = models.TextField()
   name_pinyin_short = models.TextField()
   classification = models.ManyToManyField(Classification)
   def __unicode__(self):
      return self.name