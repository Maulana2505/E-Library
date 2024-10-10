import 'package:elibrary/screen/explore_screen.dart';
import 'package:elibrary/screen/favotite_screen.dart';
import 'package:elibrary/screen/profile_screen.dart';
import 'package:elibrary/screen/search_creen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = const <Widget>[
    ExploreScreen(),
    SearchSCreen(),
    FavoriteScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        selectedItemColor: Colors.lightBlue[300],
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_sharp),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Camera',
          ),
        ],
      ),
    );
  }
}
