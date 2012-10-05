from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('mirror.views',
    url(r'^$', 'index'),
)
