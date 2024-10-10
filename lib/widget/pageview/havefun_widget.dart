import 'package:flutter/material.dart';

class HavefunWidget extends StatelessWidget {
  final PageController controller;
  final int currentpage;
  final int totalPage;
  const HavefunWidget(
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
                "assets/images/Reading a Book.png",
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              const Text(
                "Have Fun",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    letterSpacing: 5),
              ),
              const Text(
                "Et labore voluptate laborum excepteur sint. Magna elit eu consequat reprehenderit in quis sint quis. Fugiat aliqua est consectetur dolor duis laboris ex. Ea ex veniam sunt non aliqua .",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: currentpage == 1
                          ? null
                          : () {
                              controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                      icon: Icon(Icons.arrow_back_ios)),
                  ElevatedButton(
                    onPressed: currentpage == totalPage - 1
                        ? null
                        : () {
                            controller.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                    child: Text("Next"),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.2,
                            MediaQuery.of(context).size.height * 0.065),
                        backgroundColor: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 0),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
