import 'dart:convert';

class Order{
  double totalPrice;
  String address;
  List<int> advertisementsIds;
  int orderId;
  Order({required this.totalPrice, required this.address, required this.advertisementsIds, required this.orderId});

  factory Order.fromJson(String jsonString, int orderId){
    Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(jsonString));
    double totalPrice = data['price'];
    String address = data['address'];
    List<int> advertisementsIds = List<int>.from(data['advertises_id']);

    return Order(
        totalPrice: totalPrice,
        address: address,
        advertisementsIds: advertisementsIds,
        orderId:orderId
    );
  }
}
