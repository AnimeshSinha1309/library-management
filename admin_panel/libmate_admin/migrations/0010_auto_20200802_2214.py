# Generated by Django 2.2.4 on 2020-08-02 22:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('libmate_admin', '0009_issue'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='issue',
            unique_together={('isbn', 'accno')},
        ),
    ]
