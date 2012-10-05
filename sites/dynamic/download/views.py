#coding=utf-8
from download.models import Classification, Software
from django.shortcuts import render_to_response

def key(string):
   string = string.replace(' ', '-')
   return string.lower()

def index(request):
   classifications = Classification.objects.all()
   for item in classifications:
      classifications.key = key(classifications.name_english)

   softwares = Software.objects.all()

   return render_to_response('download/index.weml', {'classifications': classifications, 'softwares': softwares})
