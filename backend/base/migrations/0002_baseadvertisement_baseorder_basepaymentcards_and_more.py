# Generated by Django 4.2.1 on 2023-05-16 12:56

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='BaseAdvertisement',
            fields=[
                ('price', models.IntegerField()),
                ('advertise_id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=50)),
                ('quantity', models.IntegerField()),
                ('description', models.CharField(max_length=250)),
            ],
            options={
                'db_table': 'base_advertisement',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseOrder',
            fields=[
                ('order_id', models.AutoField(primary_key=True, serialize=False)),
                ('address', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'base_order',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BasePaymentCards',
            fields=[
                ('card_no', models.IntegerField(primary_key=True, serialize=False)),
                ('cvv', models.IntegerField()),
                ('month', models.IntegerField()),
                ('year', models.IntegerField()),
            ],
            options={
                'db_table': 'base_payment_cards',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BasePhotos',
            fields=[
                ('url', models.CharField(max_length=150)),
                ('photo_id', models.AutoField(primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'base_photos',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseTokens',
            fields=[
                ('token', models.CharField(max_length=100, primary_key=True, serialize=False)),
            ],
            options={
                'db_table': 'base_tokens',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseUser',
            fields=[
                ('username', models.CharField(db_column='Username', max_length=20)),
                ('user_id', models.AutoField(primary_key=True, serialize=False)),
                ('password', models.CharField(max_length=20)),
            ],
            options={
                'db_table': 'base_user',
                'managed': False,
            },
        ),
        migrations.DeleteModel(
            name='Item',
        ),
        migrations.CreateModel(
            name='BaseAdminUser',
            fields=[
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='base.baseuser')),
            ],
            options={
                'db_table': 'base_admin_user',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseNormalUser',
            fields=[
                ('balance', models.IntegerField()),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='base.baseuser')),
            ],
            options={
                'db_table': 'base_normal_user',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseVendorUser',
            fields=[
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='base.baseuser')),
            ],
            options={
                'db_table': 'base_vendor_user',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='BaseHavePaymentCards',
            fields=[
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.DO_NOTHING, primary_key=True, serialize=False, to='base.basenormaluser')),
            ],
            options={
                'db_table': 'base_have_payment_cards',
                'managed': False,
            },
        ),
    ]
