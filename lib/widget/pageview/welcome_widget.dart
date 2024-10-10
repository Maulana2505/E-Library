import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  final PageController controller;
  final int currentpage;
  final int totalPage;
  const WelcomeWidget(
      {super.key,
      required this.controller,
      required this.currentpage,
      required this.totalPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/Book Lover.png",
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              const Text(
                "Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    letterSpacing: 5),
              ),
              const Text(
                "Et labore voluptate laborum excepteur sint. Magna elit eu consequat reprehenderit in quis sint quis. Fugiat aliqua est consectetur dolor duis laboris ex. Ea ex veniam sunt non aliqua .",
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              ElevatedButton(
                onPressed: currentpage == totalPage - 1
                    ? null
                    : () {
                        controller.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                child: Text("Get Started"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9,
                        MediaQuery.of(context).size.height * 0.065),
                    backgroundColor: Colors.lightBlue[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 0),
              )
            ],
          ),
        ),
      )),
    );
  }
}
