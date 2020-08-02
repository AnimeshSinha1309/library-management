from .models import Journal
from django.shortcuts import render


# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})

def dashboard(request):
    journal_cnt = Journal.objects.count()
    return render(request, 'dashboard.html', {'book_cnt':'100','journal_cnt':journal_cnt,'issue_cnt':20})