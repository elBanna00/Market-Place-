from django.db import models

class BaseAdminUser(models.Model):
    user = models.OneToOneField('BaseUser', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'base_admin_user'


class BaseAdvertisement(models.Model):
    price = models.IntegerField()
    advertise_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=50)
    quantity = models.IntegerField()
    description = models.CharField(max_length=250)
    user = models.ForeignKey('BaseVendorUser', models.DO_NOTHING)
    order = models.ForeignKey('BaseOrder', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'base_advertisement'


class BaseHavePaymentCards(models.Model):
    user = models.OneToOneField('BaseNormalUser', models.DO_NOTHING, primary_key=True)  # The composite primary key (user_id, card_no) found, that is not supported. The first column is selected.
    card_no = models.ForeignKey('BasePaymentCards', models.DO_NOTHING, db_column='card_no')

    class Meta:
        managed = False
        db_table = 'base_have_payment_cards'
        unique_together = (('user', 'card_no'),)


class BaseNormalUser(models.Model):
    balance = models.IntegerField()
    user = models.OneToOneField('BaseUser', models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'base_normal_user'


class BaseOrder(models.Model):
    order_id = models.AutoField(primary_key=True)
    address = models.CharField(max_length=100)
    user = models.ForeignKey(BaseNormalUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'base_order'


class BasePaymentCards(models.Model):
    card_no = models.IntegerField(primary_key=True)
    cvv = models.IntegerField()
    month = models.IntegerField()
    year = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'base_payment_cards'


class BasePhotos(models.Model):
    url = models.CharField(max_length=150)
    photo_id = models.AutoField(primary_key=True)
    advertise = models.ForeignKey(BaseAdvertisement, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'base_photos'


class BaseTokens(models.Model):
    token = models.CharField(primary_key=True, max_length=100)
    user = models.ForeignKey('BaseUser', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'base_tokens'


class BaseUser(models.Model):
    username = models.CharField(db_column='Username', max_length=20)  # Field name made lowercase.
    user_id = models.AutoField(primary_key=True)
    password = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'base_user'


class BaseVendorUser(models.Model):
    user = models.OneToOneField(BaseUser, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = False
        db_table = 'base_vendor_user'