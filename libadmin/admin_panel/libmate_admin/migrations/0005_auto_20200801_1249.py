# Generated by Django 3.0.8 on 2020-08-01 12:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('libmate_admin', '0004_auto_20200801_1244'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='book',
            name='accno',
        ),
        migrations.AlterField(
            model_name='book',
            name='description',
            field=models.CharField(max_length=10000, null=True, verbose_name='Description'),
        ),
    ]
