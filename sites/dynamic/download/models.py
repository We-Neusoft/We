from django.db import models

class Classification(models.Model):
   name = models.CharField(max_length=255)
   name_english = models.CharField(max_length=255, primary_key=True)
   name_pinyin_full = models.CharField(max_length=255)
   name_pinyin_short = models.CharField(max_length=255)
   def __unicode__(self):
      return self.name

class Software(models.Model):
   name = models.CharField(max_length=255)
   name_english = models.CharField(max_length=255, primary_key=True)
   name_pinyin_full = models.CharField(max_length=255)
   name_pinyin_short = models.CharField(max_length=255)
   classification = models.ForeignKey(Classification)
   def __unicode__(self):
      return self.name

class Version(models.Model):
   software = models.ForeignKey(Software)
   name = models.CharField(max_length=255)
   name_english = models.CharField(max_length=255, primary_key=True)
   name_pinyin_full = models.CharField(max_length=255)
   name_pinyin_short = models.CharField(max_length=255)
   version = models.CharField(max_length=255)
   comment = models.CharField(max_length=255)
   comment_english = models.CharField(max_length=255)
   def __unicode__(self):
      return self.name
