from django.db import models

# Create your models here.
class Journal(models.Model):
    title = models.CharField(max_length = 100)
    marc_id = models.CharField(max_length = 100)
    payment_date = models.DateTimeField('Payment Date')

    def __str__(self):
        return '%s, by %s - %d, %d' % (self.title, self.authors, self.accno, self.isbn)


class Book(models.Model):
    title = models.CharField(max_length = 100, verbose_name='Book Title')
    dewey = models.CharField(max_length = 100, verbose_name='Dewey Decimal id', null=True)
    accno = models.IntegerField(verbose_name='Accession Number')
    authors = models.CharField(max_length = 100, verbose_name='Authors', null=True)
    subject = models.CharField(max_length = 100, verbose_name='Subject', null=True)
    genre = models.CharField(max_length = 100, verbose_name='Genre', null=True)
    isbn = models.IntegerField(verbose_name='ISBN Number', null=True)
    description = models.CharField(max_length = 1000, verbose_name='Description', null=True)

    def __str__(self):
        return '%s, by %s - %d, %d' % (self.title, self.authors, self.accno, self.isbn)
