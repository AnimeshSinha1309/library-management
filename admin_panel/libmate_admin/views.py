from .models import Journal, Book, Issue
from django.shortcuts import render
import datetime


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})


def dashboard(request):
    journal_cnt = Journal.objects.count()
    issue_dates = []
    return_dates = []
    isbns = []
    for obj in Issue.objects.all():
        # print(obj.issue_date)
        isd = datetime.date(
            year=int(obj.issue_date[0:4]), month=int(obj.issue_date[5:7]), day=int(obj.issue_date[8:10]))
        if obj.return_date:
            rtd = datetime.date(
                year=int(obj.return_date[0:4]), month=int(obj.return_date[5:7]), day=int(obj.return_date[8:10]))
        else:
            rtd = null
        issue_dates.append(isd)
        return_dates.append(rtd)
        isbns.append(obj.isbn)
    # print(issue_dates)
    # print(return_dates)
    book_cnt = Book.objects.count()
    return render(request, 'dashboard.html', {'book_cnt': book_cnt, 'journal_cnt': journal_cnt, 'issue_cnt': 20})


def journals(request):
    items = []
    # print(Journal.objects.all())
    cnt = 0
    for obj in Journal.objects.all():
        cnt += 1
        items.append(obj)
        if cnt == 30:
            break
    return render(request, 'journals.html', {'items': items})


def books(request):
    items = []
    # print(Journal.objects.all())
    cnt = 0
    for obj in Book.objects.all():
        cnt += 1
        items.append(obj)
        if cnt == 15:
            break
    return render(request, 'books.html', {'items': items})
