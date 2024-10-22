# Generated by Django 3.0.8 on 2020-08-01 12:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('entries', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='book',
            name='authors',
            field=models.CharField(max_length=100, null=True, verbose_name='Authors'),
        ),
        migrations.AddField(
            model_name='book',
            name='description',
            field=models.CharField(max_length=1000, null=True, verbose_name='Description'),
        ),
        migrations.AddField(
            model_name='book',
            name='genre',
            field=models.CharField(max_length=100, null=True, verbose_name='ISBN'),
        ),
        migrations.AddField(
            model_name='book',
            name='isbn',
            field=models.IntegerField(null=True, verbose_name='ISBN Number'),
        ),
        migrations.AddField(
            model_name='book',
            name='subject',
            field=models.CharField(max_length=100, null=True, verbose_name='Subject'),
        ),
        migrations.AlterField(
            model_name='book',
            name='accno',
            field=models.IntegerField(verbose_name='Accession Number'),
        ),
        migrations.AlterField(
            model_name='book',
            name='dewey',
            field=models.CharField(max_length=100, null=True, verbose_name='Dewey Decimal id'),
        ),
    ]
