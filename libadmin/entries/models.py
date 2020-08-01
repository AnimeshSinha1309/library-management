from django.db import models

# Create your models here.
class Journal(models.Model):
    title = models.CharField(max_length = 100)
    marc_id = models.CharField(max_length = 100)
    payment_date = models.DateTimeField('Payment Date')


class Book(models.Model):
    title = models.CharField(max_length = 100, verbose_name='Book Title')
    dewey = models.CharField(max_length = 100, verbose_name='Book Title')
    accno = models.IntegerField(verbose_name='Acc. No.')
