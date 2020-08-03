from django.urls import path
from libmate_admin import views

urlpatterns = [
    path('', views.dashboard, name='home'),
    path('dashboard', views.dashboard, name='dashboard'),
    path('journals', views.journals, name='journals'),
    path('books', views.books, name='books'),
]
