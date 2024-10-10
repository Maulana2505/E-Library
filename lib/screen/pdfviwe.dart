import 'dart:io';

import 'package:elibrary/models/book.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdfviwe extends StatelessWidget {
  final Book data;
  const Pdfviwe({super.key, required this.data});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        centerTitle: true,
      ),
      body: SfPdfViewer.file(File(data.filePath)),
    );
  }
}
