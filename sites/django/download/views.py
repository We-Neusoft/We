#coding=utf-8
from download.models import Classification, Software
from django.shortcuts import render_to_response

def index(request):
   classifications = Classification.objects.all()
   softwares = Software.objects.all()
   return render_to_response('download/index.weml', {'classifications': classifications, 'softwares': softwares})
