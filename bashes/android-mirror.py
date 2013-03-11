#!/usr/bin/python

from os import path, stat, utime
from urllib import urlretrieve, urlopen
from time import mktime, strptime
from xml.etree import ElementTree as ET

def download(file_name, last_modified):
   urlretrieve(base_url + file_name, work_dir + file_name)
   utime(work_dir + file_name, (last_modified, last_modified))

   process(file_name)

def process(file_name):
   handle = urlopen(base_url + file_name)
   headers = handle.info()
   content_length = int(headers.getheader('Content-Length'))
   last_modified = mktime(strptime(headers.getheader('Last-Modified'), '%a, %d %b %Y %H:%M:%S %Z'))

   if path.exists(work_dir + file_name):
      file_stat = stat(work_dir + file_name)
      if (file_stat.st_mtime == last_modified) and (file_stat.st_size == content_length):
         return

   download(file_name, last_modified)

work_dir = '/storage/mirror/android/repository/'
base_url = 'https://dl-ssl.google.com/android/repository/'
xml_file = 'repository-7.xml'
namespace = '{http://schemas.android.com/sdk/android/repository/7}'

process(xml_file)

repository = ET.parse(work_dir + xml_file).getroot()
for url in repository.findall('.//' + namespace + 'url'):
   process(url.text)
