import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:linear/PdfData/api/pdf_api.dart';
import 'package:linear/PdfData/model/customer.dart';
import 'package:linear/PdfData/model/invoice.dart';
import 'package:linear/PdfData/model/supplier.dart';
import 'package:linear/helpers/api.dart';
import 'package:linear/screens/login.dart';
import 'package:linear/screens/order_booker/retailer_visit.dart';
import 'package:linear/screens/orders/add_order.dart';
import 'package:linear/screens/splash_screen/splash.dart';
import 'package:linear/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static var ttf;
  Future<void> data() async {}

  static Future<File> generate(Invoice invoice) async {
    //
    final font = await rootBundle.load("assets/Montserrat-Regular.ttf");
    // ttf = Font.ttf(font);
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // Heading
        buildTitle(invoice),
        // Header
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        // Table
        buildInvoice(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        // Total Amount
        buildNetTotal(invoice),
      ],
      // footer: (context) => buildFooter(invoice),
    ));
    //
    Random random = Random();
    int min = 100000; // Minimum 6-digit number
    int max = 999999; // Maximum 6-digit number
    int randomSixDigitNumber = min + random.nextInt(max - min + 1);
    //
    return PdfApi.saveDocument(
        name: 'invoice$randomSixDigitNumber.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLeftSide(invoice.supplier),
              buildRightSide(invoice.supplier),
            ],
          ),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        children: [
          Center(
            child: Text(
              'INVOICE',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      );

  static Widget buildLeftSide(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('To: ${supplier.name}', style: TextStyle(fontSize: 10)),
          Text(supplier.address, style: TextStyle(fontSize: 10)),
          Text('Tel: ${supplier.phone}', style: TextStyle(fontSize: 10)),
          Text('Email: ${supplier.email}', style: TextStyle(fontSize: 10)),
          Text('NTN #: ${supplier.ntn}', style: TextStyle(fontSize: 10)),
          Text('GST Number: ${supplier.gst}', style: TextStyle(fontSize: 10)),
        ],
      );

  static Widget buildRightSide(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${supplier.date}', style: TextStyle(fontSize: 10)),
          Text('P.O Number: ${supplier.po_number}',
              style: TextStyle(fontSize: 10)),
          Text('Delivery Address : ${supplier.address}',
              style: TextStyle(fontSize: 10)),
          Text('Created By : ${Splash.order_booker_name}',
              style: TextStyle(fontSize: 10)),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    // Rows
    final rows = List.generate(
      AddOrder.add_order_orders.length,
      (index) => [
        '${index + 1}',
        '${AddOrder.add_order_orders[index]['sku']}',
        '${AddOrder.add_order_orders[index]['product']}',
        '${AddOrder.add_order_orders[index]['qty']}',
        // '${AddOrder.add_order_orders[index]['selling_price']}',
        '${AddOrder.add_order_orders[index]['price']}',
        '${AddOrder.add_order_orders[index]['product_mrp']}', // MRP
        '${AddOrder.add_order_orders[index]['amount']}',
      ],
    );
//
    return Table.fromTextArray(
      cellStyle: TextStyle(fontSize: 10),
      cellAlignment: Alignment.center,
      headers: AddOrder.add_order_column,
      data: rows,
      border: pw.TableBorder.all(color: PdfColor.fromHex('#DDDDDD')), //Dark
      headerStyle: TextStyle(fontSize: 8),
      headerDecoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#EEEEEE'), //Light
      ),
      cellHeight: 30,
    );
  }

  static Widget buildNetTotal(Invoice invoice) => Column(
        children: [
          Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Center(
                child: pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#DDDDDD'))),
              child: pw.Text('Net Amount',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            )),
            pw.Center(
                child: pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#DDDDDD'))),
              child: pw.Text('$order_amount',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            )),
          ]),
        ],
      );
}
