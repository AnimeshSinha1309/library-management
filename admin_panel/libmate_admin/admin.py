from django.contrib import admin
from libmate_admin.models import Journal,Book

# Register your models here.
class JournalAdmin(admin.ModelAdmin):
    pass

class BookAdmin(admin.ModelAdmin):
    pass

admin.site.register(Journal,JournalAdmin)
admin.site.register(Book,BookAdmin)