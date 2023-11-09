// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_cats/Home/AppBar.dart';
import 'package:flutter_app_cats/bloc/form_bloc.dart';
import 'package:flutter_app_cats/firebase_options.dart';
import 'package:flutter_app_cats/login_pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormBloc>(
        create: (context) => FormBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login and Register',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginScreen(),
        ));
  }
}
