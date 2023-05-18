import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/screens/add_advertisement_screen.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:frontend/widgets/advertise_widget.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InventoryScreenState();
  }
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Screen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          onTapAdd();
        },
        child: const Icon(
          Icons.add
        ),
      ),
      body: FutureBuilder<List<int>>(
        future: RequestHandler().getAdvertisesmentsIdsForSpecificUser(
          UserStore().userId!,
          UserStore().token!
        ),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<int> advertisementsIds = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
            itemCount: advertisementsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Advertisement>(
                future: RequestHandler().handleGetAdvertisementDetails(advertisementsIds[index]),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Stack(
                      children: [
                        AdvertiseWidget(advertisement: snapshot.data!),
                        Positioned(
                          right: 50,
                          bottom: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              onTapDelete(advertisementsIds[index]);
                            },
                            child: const Icon(
                              Icons.delete
                            ),
                          ),
                        ),
                        Positioned(
                          right: 150,
                          bottom: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return AddAdvertiseScreen(
                                  advertisement: snapshot.data!,
                                );
                              }));
                            },
                            child: const Icon(
                                Icons.edit
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              );
            },
          );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  Future<void> onTapDelete(int advertiseId) async {
    String response = await RequestHandler().deleteAdvertisement(UserStore().userId!, UserStore().token!, advertiseId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
    setState(() {

    });
  }
  void onTapAdd(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return const AddAdvertiseScreen();
    }));
  }
}
