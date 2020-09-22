import 'package:Ohstel_app/explore/models/ticket.dart';
import 'package:Ohstel_app/utilities/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TicketScreen extends StatefulWidget {
  final Ticket ticket;

  TicketScreen(this.ticket);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await wrapWidget(
        doc.document,
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RepaintBoundary(
                  key: _printKey,
                  child: FlutterTicketWidget(
                    width: 350.0,
                    height: 500.0,
                    isCornerRounded: true,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                height: 25.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                      width: 1.0, color: Colors.green),
                                ),
                                child: Center(
                                  child: Text(
                                    'Paid',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Image.asset(
                                      'asset/OHstel.png',
                                      width: 25.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      'OHstel',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              '${widget.ticket.location.name} Ticket',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: Column(
                              children: <Widget>[
                                ticketDetailsWidget(
                                  'Name',
                                  '${widget.ticket.user.fullName}',
                                  'Issued Date & Time',
                                  DateFormat('d-M-y')
                                      .add_jm()
                                      .format(widget.ticket.date),
                                ),
                                ticketDetailsWidget(
                                  'Scheduled Date',
                                  DateFormat('d-M-y')
                                      .format(widget.ticket.plannedDate),
                                  'Scheduled Time',
                                  DateFormat.jm()
                                      .format(widget.ticket.plannedTime),
                                ),
                                ticketDetailsWidget(
                                  'Duration',
                                  '${widget.ticket.location.duration} hrs',
                                  'Amount',
                                  'NGN ${widget.ticket.finalAmount}',
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 80.0, left: 30.0, right: 30.0),
                            child: Container(
                              width: 250.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('asset/barcode.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 75.0,
                              right: 75.0,
                            ),
                            child: Text(
                              '9824 0972 1742 1298',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _printScreen,
                  child: Text(
                    'Print',
                    style: body1.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                firstDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                secondDesc,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
