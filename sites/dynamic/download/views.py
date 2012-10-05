#coding=utf-8
from download.models import Classification, Software, Version
from django.shortcuts import render_to_response

def key(string):
   string = string.replace(' ', '-')
   return string.lower()

def index(request):
   classifications = Classification.objects.all()
   for item in classifications:
      item.key = key(item.name_english)

   softwares = Software.objects.all()
   for item in softwares:
      item.key = key(item.name_english)
      item.versions = item.version_set.all()

   return render_to_response('download/index.weml', {'classifications': classifications, 'softwares': softwares})
