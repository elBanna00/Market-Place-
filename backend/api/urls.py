from django.urls import path
from api import views

urlpatterns = [
    path("userLogin", views.userLogin),
    path("getOrdersDetails" , views.getOrdersDetails),
    path("getOrdersIdsForSpecificUser" , views.getOrdersIdsForSpecificUser),
    path("getAdvertisesmentsIdsForSpecificUser" , views.getAdvertisesmentsIdsForSpecificUser),
    path('getAdvertisementDetails', views.getAdvertisementDetails),
    path('createAccount', views.createAccount),
    path('deleteAdvertisement', views.deleteAdvertisement),
    path('createOrder', views.createOrder),
    path('updateAdvertisement', views.updateAdvertisement),
    path("getAccountDetails", views.getAccountDetails),
    path("getPaymentCardsOfSpecificUsers", views.getPaymentCardsOfSpecificUsers),
    path("addPaymentCard", views.addPaymentCard),
    path("createAdvertisement", views.createAdvertisement),
    path("getAllAdvertisementsIds", views.getAllAdvertisementsIds),
    path("addBalanceToUser", views.addBalanceToUser),
    path("getUserRole", views.getUserRole),
    path("promoteToAdmin", views.promoteToAdmin),
    path("promoteToVendor", views.promoteToVendor),
    path("demotedFromAdmin", views.demotedFromAdmin),
    path("demotedFromVendor", views.demotedFromVendor),
    path('getAllUsersIds', views.getAllUsersIds),
    path("getAllAdvertisementsIdsSorted", views.getAllAdvertisementsIdsSorted)
]
