# -*- coding: utf-8 -*-
# Generated by Django 1.11.5 on 2018-04-23 09:49
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('annotations', '0020_auto_20180417_1220'),
    ]

    operations = [
        migrations.AddField(
            model_name='exportformat',
            name='vector_format',
            field=models.CharField(default='x%%count1: %%x%%bry%%count1: %%y', max_length=200),
        ),
    ]
