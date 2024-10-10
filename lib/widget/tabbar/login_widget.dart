import 'package:elibrary/screen/home_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:elibrary/widget/textfield.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              filds(context, _username, "Username", 0.8, 0.06),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              filds(context, _password, "Password", 0.8, 0.06),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _btnLogin()
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnLogin() {
    return ElevatedButton(
      onPressed: () {
        // _db.deleteUser(2);
        _db.login(_username.text, _password.text).then(
          (value) async {
            if (value != null) {
              print(value);
              await _db.updateLoginUser(value[0]['id']).then(
                    (value) => print(value),
                  );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false,
              );
            } else {
              print(value);
            }
          },
        );
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: Colors.lightBlue[300],
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.06),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0),
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
