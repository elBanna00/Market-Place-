import 'dart:convert';

class Account {
  String token;
  String id;

  Account({required this.token, required this.id});

  factory Account.fromJson(String jsonString) {
    Map<String, dynamic> data =
        Map<String, dynamic>.from(jsonDecode(jsonString));

    return Account(
        token: data["token"],
        id: data['id']
    );
  }
}
