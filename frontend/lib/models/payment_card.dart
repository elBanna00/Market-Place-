import 'dart:convert';

class PaymentCard{
  int cvv;
  int month;
  int year;
  int cardNumber;

  PaymentCard({required this.cardNumber, required this.year, required this.month, required this.cvv});

  factory PaymentCard.fromMap(Map<String,dynamic> data){

    return PaymentCard(
      cvv: data['cvv'],
      month: data['month'],
      year: data['year'],
      cardNumber: data['card_number']
    );
  }
}