// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:elibrary/models/book.dart';
import 'package:elibrary/service/db.dart';

class AddbookScreen extends StatefulWidget {
  final String text;
  final Book? book;
  const AddbookScreen({super.key, required this.text, this.book});
  @override
  State<AddbookScreen> createState() => _AddbookScreenState();
}

class _AddbookScreenState extends State<AddbookScreen> {
  final db = DatabaseService();
  int? id;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  FilePickerResult? filePickerResult;
  String imgfile = "";
  String pdffile = "";
  @override
  void initState() {
    super.initState();
    _getuserlogin();
  }

  _getuserlogin() async {
    await db.getuser().then(
      (value) {
        print(value);
        id = value[0]['id'];
      },
    );
    if (widget.book != null) {
      setState(() {
        imgfile = widget.book!.image;
        _title.text = widget.book!.title;
        _desc.text = widget.book!.description;
        pdffile = widget.book!.filePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    filePickerResult = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (filePickerResult == null) {
                      return null;
                    } else {
                      imgfile = filePickerResult!.files.first.path.toString();
                      setState(() {});
                    }
                  },
                  child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: imgfile == ""
                          ? Text("No Image Selected")
                          : Image.file(File(imgfile))),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _fildstitle(context, _title, "Title", 0.8, 0.06),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: _fildsdesc(context, _desc, "Description", 0.8)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    filePickerResult = await FilePicker.platform.pickFiles(
                        type: FileType.custom, allowedExtensions: ['pdf']);
                    if (filePickerResult == null) {
                      return null;
                    } else {
                      pdffile = filePickerResult!.files.first.path.toString();
                      setState(() {});
                    }
                  },
                  child: Container(
                    color: Colors.grey.withOpacity(0.2),
                    alignment: Alignment.center,
                    // height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: pdffile == "" ? Text("Select File") : Text(pdffile),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                widget.text == "addbook" ? _btnAddbook() : _btnUpdate()
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _fildstitle(BuildContext context, TextEditingController controller,
      String hint, double width, double height) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
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

  Widget _fildsdesc(BuildContext context, TextEditingController controller,
      String hint, double width) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 5,
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
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

  Widget _btnAddbook() {
    return ElevatedButton(
      onPressed: () async {
        Book addbook = Book(
            idauthors: id!,
            title: _title.text,
            image: imgfile.toString(),
            description: _desc.text,
            filePath: pdffile.toString());
        await db.insertBook(addbook);
        Navigator.pop(context, true);
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: Colors.lightBlue[300],
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.06),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0),
      child: const Text(
        'Add Book',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _btnUpdate() {
    return ElevatedButton(
      onPressed: () async {
        Book updatebook = Book(
            id: widget.book!.id,
            idauthors: id!,
            title: _title.text,
            image: imgfile.toString(),
            description: _desc.text,
            filePath: pdffile.toString());
        await db.updateBook(widget.book!.id, updatebook);
        Navigator.pop(context, updatebook);
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: Colors.lightBlue[300],
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.06),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0),
      child: const Text(
        'Update Book',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
