import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:printing/printing.dart';
// import 'package:raffi_ukk2025/decimal.dart';
// import 'package:raffi_ukk2025/drawer.dart';

class Struk extends StatefulWidget {
  final Map penjualan;
  const Struk({super.key, required this.penjualan});

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map penjualan = widget.penjualan;
    List detail = widget.penjualan["DetailPenjualan"];
    var pelanggan = widget.penjualan["Pelanggan"];


    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          "Struk Pembelian",
        ),
        backgroundColor: const Color.fromARGB(255, 20, 78, 253),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
          initialPageFormat: PdfPageFormat.roll57,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          build: (format) async {
            final titleFont = await PdfGoogleFonts.grechenFuemenRegular();
            final fontBold = await PdfGoogleFonts.ralewayBlack();
            final font = await PdfGoogleFonts.ralewayLight();
            var pdf = pdfWidget.Document();
            pdf.addPage(pdfWidget.Page(build: (context) {
              return pdfWidget.Column(
                  mainAxisAlignment: pdfWidget.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidget.Row(
                        mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                        children: [
                          pdfWidget.Text("Toko Gitar",
                              style: pdfWidget.TextStyle(
                                  font: titleFont, fontSize: 50)),
                        ]),
                    pdfWidget.Container(
                        padding: const pdfWidget.EdgeInsets.only(top: 20, bottom: 20),
                        child: pdfWidget.Column(
                            mainAxisAlignment:
                                pdfWidget.MainAxisAlignment.center,
                            children: [
                              pdfWidget.Row(children: [
                                pdfWidget.Text("Tanggal transaksi:",
                                    style: pdfWidget.TextStyle(
                                        font: font, fontSize: 25)),
                                pdfWidget.Spacer(),
                                pdfWidget.Text(
                                    "${penjualan["TanggalPenjualan"]}",
                                    style: pdfWidget.TextStyle(
                                        font: font, fontSize: 25)),
                              ]),
                              pdfWidget.SizedBox(height: 50),
                              ...List.generate(detail.length, (index) {
                                return pdfWidget.Row(children: [
                                  pdfWidget.Text(
                                      "${detail[index]["Produk"]["NamaProduk"]} (${detail[index]["JumlahProduk"]})",
                                      style: pdfWidget.TextStyle(
                                          font: font, fontSize: 25)),
                                  pdfWidget.Spacer(),
                                  pdfWidget.Text(
                                      "Rp.${detail[index]["Subtotal"].toString()}",
                                      style: pdfWidget.TextStyle(
                                          font: font, fontSize: 25)),
                                ]);
                              }),
                              pdfWidget.SizedBox(height: 50),
                              pdfWidget.Row(children: [
                                pdfWidget.Text("Total",
                                    style: pdfWidget.TextStyle(
                                        font: fontBold, fontSize: 25)),
                                pdfWidget.Spacer(),
                                pdfWidget.Text(
                                    "Rp.${penjualan["TotalHarga"].toString()}",
                                    style: pdfWidget.TextStyle(
                                        font: fontBold, fontSize: 25)),
                              ])
                            ])),
                    pdfWidget.Row(
                        mainAxisAlignment: pdfWidget.MainAxisAlignment.center,
                        children: [
                          pdfWidget.Text(
                              "SienceStore\nJl.Lolaras no.7, Malang, Jawa Timur",
                              textAlign: pdfWidget.TextAlign.center,
                              style:
                                  pdfWidget.TextStyle(font: font, fontSize: 15))
                        ])
                  ]);
            }));
            return pdf.save();
          }),
    );
  }
}
