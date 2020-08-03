from .models import Journal, Book, Issue
from django.shortcuts import render
import datetime
from libmate_admin.plotter import caller
from libmate_admin.tags_dict import tags


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})


def dashboard(request):
    book_cnt = Book.objects.count()
    issue_cnt = Issue.objects.filter(return_date__isnull=True).count()
    journal_cnt = Journal.objects.count()
    issue_dates = []
    return_dates = []
    isbns = []

    for obj in Issue.objects.all():
        isd = datetime.date(
            year=int(obj.issue_date[0:4]), month=int(obj.issue_date[5:7]), day=int(obj.issue_date[8:10]))
        if obj.return_date:
            rtd = datetime.date(
                year=int(obj.return_date[0:4]), month=int(obj.return_date[5:7]), day=int(obj.return_date[8:10]))
        else:
            rtd = 'null'
        issue_dates.append(isd)
        return_dates.append(rtd)
        isbns.append(obj.isbn)
        
    ans = caller(issue_dates, return_dates)
    # print(ans)
    return render(request, 'dashboard.html', {'book_cnt': book_cnt, 'journal_cnt': journal_cnt, 'issue_cnt': issue_cnt,'data1':ans[0],'data2':ans[1],'data3':ans[2],'data4':ans[3],'data5':ans[4]})


def journals(request):
    items = Journal.objects.all()[:20]
    return render(request, 'journals.html', {'items': items})


def books(request):
    items = Book.objects.all()[:10]
    return render(request, 'books.html', {'items': items})
