import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/cubits/login_cubit/login_cubit.dart';
import 'package:frontend/request_handler.dart';
import 'package:frontend/screens/homescreen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/stores/user_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: MaterialApp(
        title: "Frontend",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Hind',
                color: Colors.black,
                fontWeight: FontWeight.w700
            ),
          ),
        ),
        scrollBehavior: MyCustomScrollBehavior(),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref){
      if(pref.getInt('user_id') != null) {
        UserStore().setToken(pref.getString('token')!, pref.getInt('user_id')!);
        context.read<LoginCubit>().setLoggedState(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, loginState){
        if(loginState is UnLoggedState) {
          return const LoginScreen();
        }
        else if (loginState is LoggedState){
          return FutureBuilder(
            future: RequestHandler().getUserRole(UserStore().token!, UserStore().userId!),
            builder: (context, snapshot) {
              return const HomeScreen();
            }
          );
        }
        return const SizedBox();
      },
    );
  }
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}