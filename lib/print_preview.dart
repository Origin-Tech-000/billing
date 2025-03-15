import 'package:pappettante_chayakada/domain/print/model/bill_model.dart';
import 'package:pappettante_chayakada/infrastructure/print/print.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PrintPreview extends StatelessWidget {
  final BillModel model;
  const PrintPreview({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return PdfPreview(
    //   build: (format) => generatePdf(format, model),
    // );
  }
}
