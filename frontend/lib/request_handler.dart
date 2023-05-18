import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/models/payment_card.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestHandler{
  static final RequestHandler __instance = RequestHandler.__internal();
  final String HOST = "localhost:8000";

  factory RequestHandler(){
    return __instance;
  }

  RequestHandler.__internal();


  Future<int> handleUserLogin(username, password, context) async {

    Uri uri = Uri.http(HOST, "userLogin");

    Map<String,dynamic> requestBody = {
      "username": username,
      "password": password
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    if(response.statusCode == 200){
      Map<String,dynamic> responseBody = jsonDecode(response.body);

      UserStore().setToken(responseBody['token'], responseBody['user_id']);
      SharedPreferences.getInstance().then((pref){
        pref.setString('token', responseBody['token']);
        pref.setInt('user_id', responseBody['user_id']);
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body))
      );
    }

    return response.statusCode;
  }

  Future<void> getUserRole(String token, int userId) async{

    Uri uri = Uri.http(HOST, "getUserRole");

    Map<String,dynamic> requestBody = {
      "token": token,
      "user_id": userId
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    String responseBody = jsonDecode(response.body);
    if(responseBody == "Admin"){
      UserStore().isAdmin = true;
      UserStore().isVendor = true;
    }
    else if (responseBody == "Vendor"){
      UserStore().isVendor = true;
    }
  }

  Future<int> handleCreateAccount(username, password, context) async {

    Uri uri = Uri.http(HOST, "createAccount");

    Map<String,dynamic> requestBody = {
      "username": username,
      "password": password
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body))
    );

    return response.statusCode;
  }

  Future<List<int>> handleGetAllAdvertisementsIds(String field, String order) async {

    Uri uri = Uri.http(HOST, "getAllAdvertisementsIdsSorted");


    Map<String,dynamic> requestBody = {
      "field": field,
      "order": order
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });
    List<int> advertisesIds = List<int>.from(jsonDecode(response.body));

    return advertisesIds;
  }

  Future<Advertisement> handleGetAdvertisementDetails(int advertisementId) async {

    Uri uri = Uri.http(HOST, "getAdvertisementDetails");

    Map<String,dynamic> requestBody = {
      "advertise_id": advertisementId
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return Advertisement.fromJson(response.body);
  }

  Future<List<int>> handleGetOrdersIdsForSpecificUser(int userId, String token) async {

    Uri uri = Uri.http(HOST, "getOrdersIdsForSpecificUser");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });
    List<int> ordersIDs = List<int>.from(jsonDecode(response.body));

    return ordersIDs;
  }

  Future<Order> getOrderDetails(int orderId) async {
    Uri uri = Uri.http(HOST, "getOrdersDetails");

    Map<String,dynamic> requestBody = {
      "order_id": orderId
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return Order.fromJson(response.body, orderId);
  }

  Future<void> getAccountDetails(int userId, String token) async {
    Uri uri = Uri.http(HOST, "getAccountDetails");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    Map<String,dynamic> userDetails = Map<String,dynamic>.from(jsonDecode(response.body));
    UserStore().setUsername(userDetails['username'].toString());
    UserStore().setBalance(double.parse(userDetails['balance'].toString()));
  }

  Future<String> handleCreateOrder(int userId, String token, String address, List<int> advertisementsIds) async {
    Uri uri = Uri.http(HOST, "createOrder");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "address": address,
      "advertise_ids": advertisementsIds
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return response.body;
  }

  Future<List<PaymentCard>> getPaymentCardsOfSpecificUsers(int userId, String token) async {
    Uri uri = Uri.http(HOST, "getPaymentCardsOfSpecificUsers");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    List<Map<String,dynamic>> responseBody = List<Map<String,dynamic>>.from(jsonDecode(response.body));
    List<PaymentCard> paymentCards = [];
    for(Map<String,dynamic> paymentCardMap in responseBody){
      paymentCards.add(PaymentCard.fromMap(paymentCardMap));
    }

    return paymentCards;
  }

  Future<String> addPaymentCard(int userId, String token, int cvv, int year, int month, cardNumber) async {
    Uri uri = Uri.http(HOST, "addPaymentCard");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "card_no": cardNumber,
      "year": year,
      "month": month,
      "cvv": cvv
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return response.body;
  }

  Future<String> addBalanceToUser(int userId, String token, double balance) async {
    Uri uri = Uri.http(HOST, "addBalanceToUser");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "balance": balance
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return response.body;
  }

  Future<List<int>> getAdvertisesmentsIdsForSpecificUser(int userId, String token) async {
    Uri uri = Uri.http(HOST, "getAdvertisesmentsIdsForSpecificUser");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return List<int>.from(jsonDecode(response.body));
  }

  Future<List<User>> getAllUsersIds() async {
    Uri uri = Uri.http(HOST, "getAllUsersIds");

    http.Response response = await http.get(uri, headers: {
      "Content-Type": "application/json"
    });

    List<User> users = [];

    List<Map<String,dynamic>> responseBody = List<Map<String,dynamic>>.from(jsonDecode(response.body));

    for(Map<String,dynamic> data in responseBody){
      users.add(User.fromMap(data));
    }

    return users;
  }

  Future<String> demotedFromAdmin(int userId) async{
    Uri uri = Uri.http(HOST, "demotedFromAdmin");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> demotedFromVendor(int userId) async{
    Uri uri = Uri.http(HOST, "demotedFromVendor");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> promoteToAdmin(int userId) async{
    Uri uri = Uri.http(HOST, "promoteToAdmin");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> promoteToVendor(int userId) async{
    Uri uri = Uri.http(HOST, "promoteToVendor");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> deleteAdvertisement(int userId, String token, int advertiseId) async{
    Uri uri = Uri.http(HOST, "deleteAdvertisement");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "advertise_id": advertiseId
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> createAdvertisement(int userId, String token, String name, String description, int quantity, double price, List<String> photosUrls) async{
    Uri uri = Uri.http(HOST, "createAdvertisement");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "description": description,
      "name": name,
      "quantity": quantity,
      "price": price,
      "photos" : photosUrls
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }

  Future<String> updateAdvertisement(int userId, String token, String name, String description, int quantity, double price, List<String> photosUrls, int advertisementId) async{
    Uri uri = Uri.http(HOST, "updateAdvertisement");

    Map<String,dynamic> requestBody = {
      "user_id": userId,
      "token": token,
      "description": description,
      "name": name,
      "quantity": quantity,
      "price": price,
      "photos" : photosUrls,
      "advertise_id": advertisementId
    };
    String jsonBody = jsonEncode(requestBody);

    http.Response response = await http.post(uri,body: jsonBody, headers: {
      "Content-Type": "application/json"
    });

    return jsonDecode(response.body);
  }



}
