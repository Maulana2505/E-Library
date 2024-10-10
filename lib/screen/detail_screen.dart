// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/screen/addbook_screen.dart';
import 'package:elibrary/screen/pdfviwe.dart';
import 'package:elibrary/service/db.dart';

class DetailScreen extends StatefulWidget {
  late Book? data;
  DetailScreen({
    super.key,
    required this.data,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _db = DatabaseService();
  String name = "";
  int id = 0;
  bool? fav = false;
  int idfav = 0;
  @override
  void initState() {
    super.initState();
    getnameusers();
  }

  Future<void> getnameusers() async {
    try {
      var iduser = await _db.getuser();
      var data = await _db.getuserbyid(widget.data!.idauthors);
      setState(() {
        name = data[0]['username'];
        id = iduser[0]['id'];
      });
      await _getfav();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _getfav() async {
    try {
      var favStatus = await _db.getFavparams(id, widget.data!.id);
      setState(() {
        fav = favStatus[0]['isFavorite'] != null ? !fav! : false;
        idfav = favStatus[0]['id'];
      });
      print(favStatus);
    } catch (e) {
      print('Error loading favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            id == widget.data!.idauthors
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _db.deleteBook(widget.data!.id);
                            _db.deleteFavUser(widget.data!.id);
                            Navigator.pop(context, true);
                          },
                          icon: const Icon(Icons.delete)),
                      IconButton(
                          onPressed: () async {
                            var addbook = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddbookScreen(
                                    text: "updatebook",
                                    book: widget.data,
                                  ),
                                ));

                            if (addbook != null) {
                              Book w = addbook;
                              setState(() {
                                widget.data!.idauthors = w.idauthors;
                                widget.data!.title = w.title;
                                widget.data!.description = w.description;
                                widget.data!.image = w.image;
                                widget.data!.filePath = w.filePath;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit))
                    ],
                  )
                : Container()
          ],
        ),
        body: SafeArea(
            child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfffef7ff),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Image.file(
                              File(widget.data!.image),
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  widget.data!.title,
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                ),
                              ),
                              Text(
                                name,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.withOpacity(0.75)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Synopsis",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.03),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.data!.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_btnFav(), _btnRead()],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget _btnFav() {
    return ElevatedButton(
        onPressed: () async {
          if (fav == false) {
            await _db.addFav(id, widget.data!.id, 1).then(
                  (value) => setState(() {
                    idfav = value;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Add Favorit")));
                  }),
                );
            setState(() {
              fav = true;
            });
          } else {
            await _db.deleteFav(idfav).then(
              (value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Delete Favorit")));
              },
            );
            setState(() {
              fav = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 0),
        child: fav == true
            ? const Icon(
                Icons.bookmark,
                color: Colors.white,
              )
            : const Icon(
                Icons.bookmark_border,
                color: Colors.white,
              ));
  }

  Widget _btnRead() {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Pdfviwe(data: widget.data!),
            ));
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: Colors.lightBlue[300],
          minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
              MediaQuery.of(context).size.height * 0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0),
      child: const Text(
        'Read Now',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
