import 'dart:io';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/screen/detail_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:flutter/material.dart';

class SearchSCreen extends StatefulWidget {
  const SearchSCreen({super.key});

  @override
  State<SearchSCreen> createState() => _SearchSCreenState();
}

class _SearchSCreenState extends State<SearchSCreen> {
  final TextEditingController _search = TextEditingController();
  final _db = DatabaseService();
  List<Book> _book = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchdata();
  }

  _fetchdata() async {
    final result = await _db.getBooks();
    setState(() {
      _book = result;
    });
  }

  _searchBooks(String query) async {
    final result = await _db.searchBooks(query);
    setState(() {
      _book = result; // Update the UI with search results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text( 
                  "Search",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.12,
                      fontWeight: FontWeight.w900),
                ),
              ),
              filds(context, _search, "Search", 0.9, 0.055),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // childAspectRatio: 5,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      mainAxisExtent: MediaQuery.of(context).size.height * 0.35,
                    ),
                    itemCount: _book.length,
                    itemBuilder: (context, index) {
                      var data = _book[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(data: data),
                              ));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.45,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Image.file(
                                File(data.image),
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width * 0.21,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                data.title,
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget filds(BuildContext context, TextEditingController controller,
      String hint, double width, double height) {
    return Container(
      // width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      child: TextField(
        onChanged: (value) {
          if (value.isNotEmpty) {
            _searchBooks(value);
          } else {
            _fetchdata();
          }
        },
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: hint,
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            filled: true,
            contentPadding: EdgeInsets.all(20),
            fillColor: Colors.grey.withOpacity(0.6)),
      ),
    );
  }
}
