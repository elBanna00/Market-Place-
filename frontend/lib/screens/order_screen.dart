import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart' as AdvertisementModel;
import 'package:frontend/models/order.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:frontend/widgets/order_widget.dart';

class OrderScreen extends StatefulWidget{
  const OrderScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen>{
  late Future<List<int>> __future;

  @override
  void initState() {
    super.initState();
    __future = RequestHandler().handleGetOrdersIdsForSpecificUser(UserStore().userId!, UserStore().token!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Orders Screen"),
      ),
      body: FutureBuilder<List<int>>(
        future: __future,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            List<int> ordersIds = snapshot.data!;
            return ListView.separated(
              itemCount: ordersIds.length,
              separatorBuilder: (context, _){
                return const Divider(
                  thickness: 2,
                );
              },
              itemBuilder: (context, index){
                return FutureBuilder<Order>(
                  future: RequestHandler().getOrderDetails(ordersIds[index]),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return OrderWidget(order: snapshot.data!,);
                    }
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                );
              }
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        }
      )
    );
  }

}