from rest_framework import serializers
from base.models import BaseUser

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = BaseUser
        fields = ["username", "password"]

