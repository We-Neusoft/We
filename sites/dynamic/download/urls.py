from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('download.views',
    url(r'^$', 'index'),
)
