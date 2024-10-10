import 'dart:io';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/screen/detail_screen.dart';
import 'package:elibrary/service/db.dart';
import 'package:elibrary/widget/pageview/auth_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int id = 0;
  String username = "";
  final _db = DatabaseService();
  List<Book> book = [];
  @override
  void initState() {
    super.initState();
    _user();
  }

  _user() async {
    var user = await _db.getuser();
    var s = await _db.getuserbyid(user[0]['id']);

    List<Book> fetchedBooks = [];

    var books = await _db.getAllBooksparams(user[0]['id']);

    for (var bookItem in books) {
      if (!fetchedBooks.any((existingBook) => existingBook.id == bookItem.id)) {
        fetchedBooks.add(bookItem);
      }
    }
    print(fetchedBooks);
    setState(() {
      user != null ? id = user[0]['id'] : null;
      username = s[0]['username'];
      book = fetchedBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () async {
                            await _db.logout(id);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => AuthWidget(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Icon(Icons.logout)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    CircleAvatar(
                        backgroundColor: Color(0xfffef7ff),
                        radius: MediaQuery.of(context).size.height * 0.1,
                        child: Icon(
                          Icons.person_2,
                          size: MediaQuery.of(context).size.height * 0.2,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Text(
                      username,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.03),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xfffef7ff),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "My Book",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.10,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        book.isEmpty
                            ? Container()
                            : Flexible(
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2,
                                    mainAxisExtent:
                                        MediaQuery.of(context).size.height *
                                            0.35,
                                  ),
                                  itemCount: book.length,
                                  itemBuilder: (context, index) {
                                    var data = book[index];
                                    return InkWell(
                                      onTap: () async {
                                        bool? a = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(data: data),
                                            ));

                                        if (a == true) {
                                          _user();
                                        }
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Image.file(
                                              File(data.image),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              data.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
