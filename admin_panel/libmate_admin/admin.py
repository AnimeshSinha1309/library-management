from django.contrib import admin
from libmate_admin.models import Journals

# Register your models here.
class JournalsAdmin(admin.ModelAdmin):
    pass

admin.site.register(Journals,JournalsAdmin)