import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapi_bloc/repository/repository.dart';
import 'package:movieapi_bloc/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => MovieRepository(),
        child: const Home(),
      ),
      theme: ThemeData(fontFamily: 'mulish'),
      debugShowCheckedModeBanner: false,
    );
  }
}
