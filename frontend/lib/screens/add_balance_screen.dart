import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/payment_cards.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddBalanceScreenState();
  }
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add quantity"),
        ),
        body: ListView(
          children: [
            textField(
                controller: controller,
                isHide: false,
                labelText: "Amount to add"),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        onClickAdd();
                      },
                      child: Text("Add")),
                ),
              ],
            )
          ],
        ));
  }

  Row textField(
      {required TextEditingController controller,
      required bool isHide,
      required String labelText}) {
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                obscureText: isHide,
                controller: controller,
                decoration: InputDecoration(
                    labelText: labelText, border: const OutlineInputBorder()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onClickAdd(){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PaymentCards(balance:
      double.parse(controller.text),
      );
    }));
  }
}
