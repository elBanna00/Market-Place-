import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubits/login_cubit/login_cubit.dart';
import 'package:frontend/models/advertisement.dart' as AdvertisementsModels;
import 'package:frontend/request_handler.dart';
import 'package:frontend/screens/account_screen.dart';
import 'package:frontend/screens/advertise_screen.dart';
import 'package:frontend/screens/checkout_screen.dart';
import 'package:frontend/screens/inventory_screen.dart';
import 'package:frontend/screens/manage_users.dart';
import 'package:frontend/screens/order_screen.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:frontend/widgets/advertise_widget.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{


  final dateAscending = 1;
  final dateDescending = 2;
  final priceAscending = 3;
  final priceDescending = 4;
  final quantityAscending = 5;
  final quantityDescending = 6;

  String field = "advertise_id";
  String order = "DESC";
  int? value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Homepage"
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckOutScreen()));
              },
              icon: const Icon(
                Icons.shopping_cart
              )
          ),
          SizedBox(
            width: 250,
            child: DropdownButtonFormField(
                value: value,
                items: [
                  DropdownMenuItem(
                    value: dateAscending,
                    child: const Text("Date Ascending"),
                  ),
                  DropdownMenuItem(
                    value: dateDescending,
                    child: const Text("Date Descending"),
                  ),
                  DropdownMenuItem(
                    value: priceAscending,
                    child: const Text("Price Ascending"),
                  ),
                  DropdownMenuItem(
                    value: priceDescending,
                    child: const Text("Price Descending"),
                  ),
                  DropdownMenuItem(
                    value: quantityAscending,
                    child: const Text("Quantity Ascending"),
                  ),
                  DropdownMenuItem(
                    value: quantityDescending,
                    child: const Text("Quantity Descending"),
                  ),
                ],
                onChanged:(int? value){
                  value = value;
                  switch(value){
                    case 1:
                      field = "advertise_id";
                      order = "ASC";
                      break;
                    case 2:
                      field = "advertise_id";
                      order = "DESC";
                      break;

                    case 3:
                      field = "price";
                      order = "ASC";
                      break;

                    case 4:
                      field = "price";
                      order = "DESC";
                      break;

                    case 5:
                      field = "quantity";
                      order = "ASC";
                      break;

                    case 6:
                      field = "quantity";
                      order = "DESC";
                      break;
                  }
                  setState(() {});
                }
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.account_circle_rounded,
              ),
              title: const Text("Account Details"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const AccountScreen();
                }));
                },
            ),
            ListTile(
              leading: const Icon(
                Icons.history,
              ),
              title: const Text("Previous Orders"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
              },
            ),
            if(UserStore().isVendor)
            ListTile(
              leading: const Icon(
                Icons.store,
              ),
              title: const Text("See my Inventory"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen()));
              },
            ),
            if(UserStore().isAdmin)
              ListTile(
              leading: const Icon(
                Icons.manage_accounts,
              ),
              title: const Text("Manage Accounts"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageUsers()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text("Logout"),
              onTap: (){
                context.read<LoginCubit>().setUnLoggedState(context);
              },
            ),

          ],
        ),
      ),
      body: FutureBuilder<List<int>>(
        future: RequestHandler().handleGetAllAdvertisementsIds(field,order),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<int> advertisesIds = snapshot.data!;
            return ListView.builder(
              itemCount: advertisesIds.length,
              itemBuilder: (context,index){
                return FutureBuilder<AdvertisementsModels.Advertisement>(
                    future: RequestHandler().handleGetAdvertisementDetails(advertisesIds[index]),
                    builder: (context, advertisementsSnapshot){
                      if(advertisementsSnapshot.hasData){
                        AdvertisementsModels.Advertisement advertisement = advertisementsSnapshot.data!;
                        return AdvertiseWidget(advertisement: advertisement);
                      }
                      return SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                );
              },
           );
          }

          return const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}