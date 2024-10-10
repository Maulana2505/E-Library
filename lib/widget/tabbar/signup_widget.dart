import 'package:elibrary/service/db.dart';
import 'package:elibrary/widget/textfield.dart';
import 'package:flutter/material.dart';

class SignupWidget extends StatefulWidget {
  final TabController? tabController;
  const SignupWidget({
    super.key,
    this.tabController,
  });

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
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
        _db.signup(_username.text, _password.text).then(
          (value) {
            if (value == null) {
              print("Tidak bisa regis");
            } else {
              widget.tabController!.animateTo(0);
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
        'SignUp',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
