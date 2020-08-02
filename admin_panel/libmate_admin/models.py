from django.db import models

# Create your models here.
class Journal(models.Model):
    title = models.CharField(max_length = 100, verbose_name = "Journal Title", primary_key = True)
    author = models.CharField(max_length = 100,verbose_name = "Author", null=True)
    Publication_Title = models.CharField(max_length = 100, verbose_name = "Publication Title", null=True)
    Book_Series_Title = models.CharField(max_length = 100, verbose_name = "Book Series Title", null=True)
    Journal_Volume = models.CharField(max_length = 100,verbose_name = "Journal  Volume", null=True)
    Journal_Issue = models.CharField(max_length = 100,verbose_name = "Journal  Issue", null=True)
    Item_DOI = models.CharField(max_length = 100,verbose_name = "Item Date of Issue", null=True)
    Publication_Year = models.CharField(max_length = 100,verbose_name = "Publication Year", null=True)
    URL = models.CharField(max_length = 100,verbose_name = "URL", null=True)
    Content_Type = models.CharField(max_length = 100,verbose_name = "Content Type", null=True)

    def __str__(self):
        return '%s, by %s' % (self.title, self.author)

class Book(models.Model):
    id = models.CharField(max_length = 200, verbose_name='Book ID',primary_key = True)
    title = models.CharField(max_length = 1000, verbose_name='Book Title' ,null=True)
    category = models.CharField(max_length = 1000, verbose_name='Category', null=True)
    author = models.CharField(max_length = 1000, verbose_name='Authors', null=True)
    description = models.CharField(max_length = 6000, verbose_name='Description', null=True)
    rating = models.FloatField(verbose_name='Rating', null=True)
    tag = models.CharField(max_length = 1000, verbose_name='Tag', null=True)
    gbooks_link = models.CharField(max_length = 1000, verbose_name='Gbooks link', null=True)
    volume_link = models.CharField(max_length = 1000, verbose_name='Volume link', null=True)
    info_link = models.CharField(max_length = 1000, verbose_name='Info Link', null=True)
    image = models.CharField(max_length = 1000, verbose_name='Image Link', null=True)
    isbn = models.CharField(max_length = 13,verbose_name='ISBN Number', null=True)

    def __str__(self):
        return '%s, by %s -  %s' % (self.title, self.author, self.isbn)