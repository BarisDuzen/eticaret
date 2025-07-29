import 'package:eticaret/product/home/cubit/CheckoutCubit.dart';
import 'package:eticaret/product/home/cubit/FavouriteCubit.dart';
import 'package:eticaret/product/home/cubit/HomepageCubit.dart';
import 'package:eticaret/product/home/view/widget/homepage/HomePage.dart';
import 'package:eticaret/product/home/view/widget/login_page/Login.dart';
import 'package:eticaret/product/home/view/Navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeCubit()),BlocProvider(create: (context) => CheckOut()),BlocProvider(create: (context) => FavouriteCubit())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginPage(),
      ),
    );
  }
}

