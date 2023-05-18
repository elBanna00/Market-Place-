import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/payment_card.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/stores/user_store.dart';

class PaymentCards extends StatefulWidget{
  final double balance;
  const PaymentCards({super.key, required this.balance,});

  @override
  State<StatefulWidget> createState() {
    return _PaymentCardState();
  }
}

class _PaymentCardState extends State<PaymentCards>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Cards"
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          onTapAddPaymentCard();
        },
        child: const Icon(
          Icons.add
        ),
      ),
      body: FutureBuilder<List<PaymentCard>>(
        future: RequestHandler().getPaymentCardsOfSpecificUsers(UserStore().userId!, UserStore().token!),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            List<PaymentCard> paymentCards = snapshot.data!;

            return ListView.separated(
              itemCount: paymentCards.length,
              separatorBuilder: (context,index){
                return const Divider(thickness: 2,);
              },
              itemBuilder: (context, index){
                return ListTile(
                  leading: const Icon(Icons.credit_card),
                  tileColor: Colors.green,
                  onTap: (){
                    onTapCard(
                      paymentCards[index]
                    );
                  },
                  title: Text(
                    paymentCards[index].cardNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                );
              }
            );
          }

          return const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }

  Row textField({required TextEditingController controller, required bool isHide, required String labelText}){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 500,
          child: Center(
            child: Material(
              color: Colors.white,
              child: TextField(
                obscureText: isHide,
                controller: controller,
                decoration: InputDecoration(
                    labelText: labelText,
                    border: const OutlineInputBorder()
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> onTapCard(PaymentCard card) async {
    String response = await RequestHandler().addBalanceToUser(UserStore().userId!, UserStore().token!, widget.balance);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jsonDecode(response))));
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void onTapAddPaymentCard(){
    TextEditingController __cardNumberController = TextEditingController();
    TextEditingController __cvvController = TextEditingController();
    TextEditingController __monthController = TextEditingController();
    TextEditingController __yearController = TextEditingController();

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Payment Card Details"),
        content: Column(
          children: [
            textField(controller: __cardNumberController, isHide: false, labelText: "Card number"),
            const SizedBox(height: 10,),
            textField(controller: __monthController, isHide: false, labelText: "Month"),
            const SizedBox(height: 10,),
            textField(controller: __yearController, isHide: false, labelText: "Year"),
            const SizedBox(height: 10,),
            textField(controller: __cvvController, isHide: false, labelText: "CVV"),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  width: 400,
                  child: ElevatedButton(
                      onPressed: (){
                        onSubmit(
                            cvv: int.parse(__cvvController.text),
                            year: int.parse(__yearController.text),
                            month: int.parse(__monthController.text),
                            cardNumber: int.parse(__cardNumberController.text)
                        );
                      },
                      child: const Text("Add")
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Future<void> onSubmit({required cvv, required year, required month, required cardNumber}) async {
    String response = await RequestHandler().addPaymentCard(UserStore().getUserId(), UserStore().getToken(), cvv, year, month, cardNumber);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
    Navigator.pop(context);
    setState(() {

    });
  }
}