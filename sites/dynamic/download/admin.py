#coding=utf-8
from download.models import Classification, Software, Version
from django.contrib import admin

class SoftwareInline(admin.TabularInline):
   model = Software
   extra = 1

class VersionInline(admin.TabularInline):
   model = Version
   extra = 1

class ClassificationAdmin(admin.ModelAdmin):
   inlines = [SoftwareInline]

class SoftwareAdmin(admin.ModelAdmin):
   list_display = ('software_name', 'name_pinyin', 'classification')
   search_fields = ['name']
   inlines = [VersionInline]

   def software_name(self, obj):
      return '%s (%s)' % (obj.name, obj.name_english)

   def name_pinyin(self, obj):
      return '%s (%s)' % (obj.name_pinyin_full, obj.name_pinyin_short)

class VersionAdmin(admin.ModelAdmin):
   list_display = ('version_name', 'version_pinyin', 'version', 'version_comment')

   def version_name(self, obj):
      return '%s (%s)' % (obj.name, obj.name_english)

   def version_pinyin(self, obj):
      return '%s (%s)' % (obj.name_pinyin_full, obj.name_pinyin_short)

   def version_comment(self, obj):
      return '%s (%s)' % (obj.comment, obj.comment_english)

admin.site.register(Classification, ClassificationAdmin)
admin.site.register(Software, SoftwareAdmin)
admin.site.register(Version, VersionAdmin)
