import 'dart:convert';

class Advertisement{
  int advertiseId;
  String name;
  String description;
  int quantity;
  double price;

  @override
  String toString() {
    return 'Advertisement{advertiseId: $advertiseId, name: $name, description: $description, quantity: $quantity, price: $price, photosURLS: $photosURLS, user_id: $user_id}';
  }

  List<String> photosURLS;
  int user_id;

  Advertisement({required this.advertiseId, required this.name, required this.description, required this.quantity,
      required this.price, required this.photosURLS, required this.user_id});

  factory Advertisement.fromJson(String jsonString){
    Map<String,dynamic> data = Map<String,dynamic>.from(jsonDecode(jsonString));

    return Advertisement(
        advertiseId: data['advertise_id'],
        name: data['name'],
        description: data['description'],
        user_id: data['user_id'],
        quantity: data["quantity"],
        price: data['price'],
        photosURLS: List<String>.from(data['photos'])
    );
  }

  factory Advertisement.fromMap(Map<String,dynamic> map){
    return Advertisement(
        advertiseId: map['id'],
        name: map['name'],
        description: map['description'],
        quantity: map["quantity"],
        price: map['price'],
        photosURLS: map['photos_URLs'],
        user_id: map['user_id'],
    );
  }
}