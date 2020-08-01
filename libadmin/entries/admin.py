from django.contrib import admin
from libmate_admin.models import *

# Register your models here.
class JournalsAdmin(admin.ModelAdmin):
    pass

class BooksAdmin(admin.ModelAdmin):
    pass

admin.site.register(Journal ,JournalsAdmin)
admin.site.register(Book, BooksAdmin)
