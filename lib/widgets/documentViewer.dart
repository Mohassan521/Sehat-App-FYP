import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewer extends StatelessWidget {
  final String url;
  final String document_name;
  const DocumentViewer({super.key, required this.url, required this.document_name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document_name),
      ),
      body: SfPdfViewer.network(url),
    );
  }
}