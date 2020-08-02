from .models import Journal,Book, Issue
from django.shortcuts import render
import datetime
from libmate_admin.plotter import caller


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})

def dashboard(request):
    book_cnt = Book.objects.count()
    issue_cnt = Issue.objects.count()
    journal_cnt = Journal.objects.count()
    # issue_dates = []
    # return_dates = []
    # isbns = []
    # store = Issue.objects.all()
    # print("start")

    # for obj in store:
    #     isd = datetime.date(
    #         year=int(obj.issue_date[0:4]), month=int(obj.issue_date[5:7]), day=int(obj.issue_date[8:10]))
    #     if obj.return_date:
    #         rtd = datetime.date(
    #             year=int(obj.return_date[0:4]), month=int(obj.return_date[5:7]), day=int(obj.return_date[8:10]))
    #     else:
    #         rtd = 'null'
    #     issue_dates.append(isd)
    #     return_dates.append(rtd)
    #     isbns.append(obj.isbn)
    
    # ans = caller(issue_dates, return_dates)
    # print("HEL")
    # print(ans)
    ans = [{'Monday': 82, 'Tuesday': 73, 'Wednesday': 79, 'Thursday': 76, 'Friday': 84, 'Saturday': 75, 'Sunday': 82}, [0, 17, 21, 19, 10, 20, 21, 18, 17, 20, 25, 20, 20, 23, 23, 17, 16, 17, 19, 18, 12, 17, 17, 16, 16, 16, 15, 23, 14, 14, 19, 11], [225, 14, 20, 19, 33, 35, 31, 28, 27, 25, 30, 22, 15, 16, 4, 1, 3, 1, 1, 1], [0, 27, 25, 30, 22, 15, 16, 4, 1, 3, 1, 1, 1], [405, 139, 7]]
    return render(request, 'dashboard.html', {'book_cnt': book_cnt, 'journal_cnt': journal_cnt, 'issue_cnt': issue_cnt,'data1':ans[0],'data2':ans[1]})

def journals(request):
    items = Journal.objects.all()[:10]
    return render(request, 'journals.html', {'items': items})

def books(request):
    items = Book.objects.all()[:10]
    return render(request, 'books.html', {'items': items})
