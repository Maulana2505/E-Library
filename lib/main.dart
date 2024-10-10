import 'package:elibrary/screen/home_screen.dart';
import 'package:elibrary/screen/splash_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseService();
  var user = await db.getuser();
  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isLoggedIn ? const HomeScreen() : const SplachScreen(),
    );
  }
}
