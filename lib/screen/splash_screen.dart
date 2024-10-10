import 'package:elibrary/widget/pageview/auth_widget.dart';
import 'package:elibrary/widget/pageview/havefun_widget.dart';
import 'package:elibrary/widget/pageview/welcome_widget.dart';
import 'package:flutter/material.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  PageController controller = PageController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPage = 3;
    int currentPage = 0;
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: [
          WelcomeWidget(
            controller: controller,currentpage: currentPage,totalPage: totalPage,
          ),
          HavefunWidget( controller: controller,currentpage: currentPage,totalPage: totalPage,),
          AuthWidget()
        ],
      )),
    );
  }
}
