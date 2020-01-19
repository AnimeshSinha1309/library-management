from webapp import views
from django.urls import path

urlpatterns = [
    path('', views.webapp, name='webapp'),
    path('submit/', views.submit, name='submit'),
]
