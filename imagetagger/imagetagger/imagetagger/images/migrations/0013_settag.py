# Generated by Django 2.0.4 on 2018-06-27 18:12

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('images', '0012_imageset_creator'),
    ]

    operations = [
        migrations.CreateModel(
            name='SetTag',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, unique=True)),
                ('imagesets', models.ManyToManyField(related_name='set_tags', to='images.ImageSet')),
            ],
        ),
    ]
