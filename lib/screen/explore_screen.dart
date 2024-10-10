import 'dart:io';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/screen/addbook_screen.dart';
import 'package:elibrary/screen/detail_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _db = DatabaseService();
  List<Book> book = [];
  @override
  void initState() {
    super.initState();
    refreshdata();
  }

  refreshdata() async {
    final result = await _db.getBooks();
    setState(() {
      book = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[300],
        child: Icon(Icons.add),
        onPressed: () async {
          bool? addbook = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddbookScreen(
                  text: "addbook",
                  book: null,
                ),
              ));

          if (addbook == true) {
            refreshdata();
          }
        },
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.12,
                  fontWeight: FontWeight.w900),
            ),
            Flexible(
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.35,
                ),
                itemCount: book.length,
                itemBuilder: (context, index) {
                  var data = book[index];
                  return InkWell(
                    onTap: () async {
                      bool? a = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(data: data),
                          ));

                      if (a == true) {
                        refreshdata();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
      )),
    );
  }
}
