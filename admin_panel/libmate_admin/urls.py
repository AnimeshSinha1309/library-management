from django.urls import path
from libmate_admin import views

urlpatterns = [
    path('', views.hello_world, name='hello_world'),
    path('dashboard', views.dashboard, name='dashboard'),
    path('journals', views.journals, name='journals'),
]
