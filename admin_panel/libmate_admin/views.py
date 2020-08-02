from .models import Journal,Book, Issue
from django.shortcuts import render


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})

def dashboard(request):
    book_cnt = Book.objects.count()
    issue_cnt = Issue.objects.count()
    journal_cnt = Journal.objects.count()
    return render(request, 'dashboard.html', {'book_cnt': book_cnt, 'journal_cnt': journal_cnt, 'issue_cnt': issue_cnt})

def journals(request):
    items = Journal.objects.all()[:10]
    return render(request, 'journals.html', {'items': items})

def books(request):
    items = Book.objects.all()[:10]
    return render(request, 'books.html', {'items': items})
