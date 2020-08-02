from django.shortcuts import render

# Create your views here.
def hello_world(request):
    return render(request, 'hello_world.html', {})

def dashboard(request):
    return render(request, 'dashboard.html', {})

def journals(request):
    return render(request, 'journals.html', {})