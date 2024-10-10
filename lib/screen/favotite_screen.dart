import 'dart:io';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/models/favorite.dart';
import 'package:elibrary/screen/detail_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _db = DatabaseService();
  List<Book> book = [];
  List<Favorit> fav = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshdata();
  }

  refreshdata() async {
    try {
      var iduser = await _db.getuser();
      var favdata = await _db.getAllFav(iduser[0]['id']);
      List<Book> fetchedBooks = [];

      for (var data in favdata) {
        var books = await _db.getBooksparams(data.bookid);

        for (var bookItem in books) {
          if (!fetchedBooks
              .any((existingBook) => existingBook.id == bookItem.id)) {
            fetchedBooks.add(bookItem);
          }
        }
      }

      setState(() {
        book = fetchedBooks;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Favorit",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.12,
                    fontWeight: FontWeight.w900),
              ),
              book.isEmpty
                  ? Container()
                  : Flexible(
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 5,
                          crossAxisCount: 2,
                          mainAxisExtent:
                              MediaQuery.of(context).size.height * 0.35,
                        ),
                        itemCount: book.length,
                        itemBuilder: (context, index) {
                          var data = book[index];
                          return InkWell(
                            onTap: () async {
                              bool? addbook = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(data: data),
                                  ));
                              if (addbook == true) {
                                refreshdata();
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Image.file(
                                    File(data.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    data.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
