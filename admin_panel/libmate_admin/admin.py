from django.contrib import admin
from libmate_admin.models import Journal,Book,Issue

# Register your models here.
class JournalAdmin(admin.ModelAdmin):
    search_fields = ['title', 'author', 'Item_DOI']

class BookAdmin(admin.ModelAdmin):
    search_fields = ['title', 'category', 'description']

class IssueAdmin(admin.ModelAdmin):
    search_fields = ['isbn']

admin.site.register(Journal, JournalAdmin)
admin.site.register(Book, BookAdmin)
admin.site.register(Issue, IssueAdmin)