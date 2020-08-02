from .models import Journal,Book
from django.shortcuts import render


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})


def dashboard(request):
    journal_cnt = Journal.objects.count()
    book_cnt = Book.objects.count()
    return render(request, 'dashboard.html', {'book_cnt': book_cnt, 'journal_cnt': journal_cnt, 'issue_cnt': 20})


def journals(request):
    items = []
    # print(Journal.objects.all())
    cnt = 0
    for obj in Journal.objects.all():
        cnt += 1
        items.append(obj)
        if cnt == 50:
            break
    return render(request, 'journals.html', {'items': items})


def books(request):
    items = []
    # print(Journal.objects.all())
    cnt = 0
    for obj in Book.objects.all():
        cnt += 1
        items.append(obj)
        if cnt == 50:
            break
    return render(request, 'books.html', {'items': items})
