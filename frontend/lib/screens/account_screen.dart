import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/screens/add_balance_screen.dart';
import 'package:frontend/stores/user_store.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountScreenState();
  }
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Account Screen"),
      ),
      body: Center(
        child: FutureBuilder(
            future: RequestHandler()
                .getAccountDetails(UserStore().userId!, UserStore().token!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "User ID: ${UserStore().userId!.toString()}",
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Username: ${UserStore().username!}",
                          style: const TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Balance: ${UserStore().balance}\$",
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 10),
                        FloatingActionButton(
                            onPressed: (){
                              onClickAddBalance();
                            },
                            child: const Icon(
                                Icons.add
                            ),
                        )
                      ],
                    )
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  void onClickAddBalance(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddBalanceScreen();
    }));
  }
}
