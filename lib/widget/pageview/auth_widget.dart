import 'package:elibrary/widget/tabbar/login_widget.dart';
import 'package:elibrary/widget/tabbar/signup_widget.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> with TickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(
      () {
        setState(() {
          selectedIndex = tabController!.index;
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/Authentication.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                TabBar(
                    controller: tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.circular(10)),
                    tabs: [
                      Tab(
                        text: "Login",
                      ),
                      Tab(
                        text: "Signup",
                      )
                    ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                      controller: tabController,
                      children: [LoginWidget(), SignupWidget(tabController : tabController)]),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget tabbar() {
    return TabBar(
        indicator: BoxDecoration(
            // border: Border.all(color: Colors.transparent),

            borderRadius: BorderRadius.circular(10)),
        labelColor: Colors.white70,
        controller: tabController,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        // indicatorWeight: 10,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
            text: "Login",
          ),
          Tab(
            text: "Signup",
          )
        ]);
  }
}
