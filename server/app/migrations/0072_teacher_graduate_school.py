# -*- coding: utf-8 -*-
# Generated by Django 1.9.2 on 2016-02-16 10:18
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0071_auto_20160216_1659'),
    ]

    operations = [
        migrations.AddField(
            model_name='teacher',
            name='graduate_school',
            field=models.CharField(default=None, max_length=50, null=True),
        ),
    ]
