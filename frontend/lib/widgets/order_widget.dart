import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/models/order.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/widgets/advertise_widget.dart';

class OrderWidget extends StatefulWidget{
  final Order order;
  const OrderWidget({super.key, required this.order});

  @override
  State<StatefulWidget> createState() {
    return _OrderWidgetState();
  }
}

class _OrderWidgetState extends State<OrderWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey,
            width: 3,
            style: BorderStyle.values[
            1
            ]
        ),

        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Order id: ${widget.order.orderId}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    "Total price: ${widget.order.totalPrice}"
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    "Address: ${widget.order.address}"
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text("Advertisements"),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.order.advertisementsIds.length,
              itemBuilder: (context, index){
                return FutureBuilder<Advertisement>(
                  future: RequestHandler().handleGetAdvertisementDetails(widget.order.advertisementsIds[index]),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return AdvertiseWidget(advertisement: snapshot.data!);
                    }

                    return const SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                );
              }
          ),
        ],
      ),
    );
  }
}