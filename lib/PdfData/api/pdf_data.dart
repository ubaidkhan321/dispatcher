import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PdfGenerator extends StatefulWidget {
  @override
  _PdfGeneratorState createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {
  final pdf = pw.Document();
  late File? file = null;

  writePdf() async {
    final font = await rootBundle.load("assets/Helvetica.ttf");
    final ttf = pw.Font.ttf(font);
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Center(
                  child: pw.Text('Hello wajih',
                      style: pw.TextStyle(fontSize: 40))),
            ],
          );
        }));
  }

  Future savePdf() async {
    Directory? documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory!.path;
    File _file = File('$documentPath/sample3.pdf');
    //
    _file.writeAsBytes(await pdf.save());
    //
    print('Document $documentPath');
    print('File $_file');
    setState(() {
      file = _file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: file != null
            ? PdfView(path: file!.path)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add widgets for UI elements and actions
                  // For example, a button to generate and save the PDF
                  Center(child: Text('data')),
                  ElevatedButton(
                    onPressed: () async {
                      writePdf();
                      savePdf();
                      print('object');
                    },
                    child: Text("Generate PDF"),
                  ),
                ],
              ));
  }
}
