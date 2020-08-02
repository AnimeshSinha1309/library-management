from django.db import models

# Create your models here.
class Journal(models.Model):
    title = models.CharField(max_length = 100, verbose_name = "Journal Title", null=True)
    publisher = models.CharField(max_length = 100, verbose_name = "Publisher", null=True)
    editors = models.CharField(max_length = 100, verbose_name = "Editor in Chief", null=True)
    issn = models.CharField(max_length = 13,verbose_name = "ISSN", null=True)
    payment_date = models.DateTimeField('Payment Date', null=True)

    def __str__(self):
        return '%s, by %s - %s' % (self.title, self.publisher,self.issn)

class Book(models.Model):
    title = models.CharField(max_length = 100, verbose_name='Book Title')
    dewey = models.CharField(max_length = 100, verbose_name='Dewey Decimal id', null=True)
    authors = models.CharField(max_length = 100, verbose_name='Authors', null=True)
    subject = models.CharField(max_length = 100, verbose_name='Subject', null=True)
    genre = models.CharField(max_length = 100, verbose_name='Genre', null=True)
    isbn = models.CharField(max_length = 13,verbose_name='ISBN Number', null=True)
    description = models.CharField(max_length = 10000, verbose_name='Description', null=True)

    def __str__(self):
        return '%s, by %s -  %s' % (self.title, self.authors, self.isbn)