// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyViewPdf extends StatefulWidget {
  String link;
  MyViewPdf({Key? key, required this.link}) : super(key: key);

  @override
  State<MyViewPdf> createState() => _MyViewPdfState(link);
}

class _MyViewPdfState extends State<MyViewPdf> {
  String link;
  _MyViewPdfState(this.link);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير حضور'),
      ),
      body: SfPdfViewer.network(
        link,
      ),
    );
  }
}
