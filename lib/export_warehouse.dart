import 'dart:convert';
import 'dart:io';

import 'package:barcode_scanner/scan_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'database_management/remote_database_management.dart';

class ExportWarehouse extends StatefulWidget {
  final host;
  final port;

  const ExportWarehouse({Key key, this.host, this.port}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExportWarehouse();
}

class _ExportWarehouse extends State<ExportWarehouse> {
  var history;
  var apiKey;

  readKey() async {
    final directory = await getApplicationDocumentsDirectory();
    final apiFile = File('${directory.path}/warehouse.key');
    if (!await apiFile.exists())
      setState(() {
        apiKey = null;
      });
    var _apiKey = utf8.decode(await apiFile.readAsBytes());
    if (_apiKey.isNotEmpty)
      setState(() {
        apiKey = _apiKey;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (apiKey == null) readKey();
    var transaction = Transaction();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Extragere"),
      ),
      body: FutureBuilder(
        future: transaction.queryExport(),
        builder: (context, snapshot) {
          List<Widget> children = [];
          if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Eroare: ${snapshot.error}'),
              )
            ];
          } else if (snapshot.hasData) {
            history = snapshot.data;
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Se încarcă tranzacțiile efectuate...'),
              )
            ];
          }
          return (history == null)
              ? Center(
                  child: Column(
                    children: children,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, i) {
                    var exportDate =
                        DateTime.parse(history[i][Transaction.transactionDate]);
                    return ListTile(
                      title: Text("${i + 1}.  ${history[i][Product.name]} extras ${history[i][Transaction.quantity]} unități"),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Detalii"),
                          content: Text(
                            "Cantitate: ${history[i][Transaction.quantity]}\n"
                            "Data tranzacției: "
                            "${exportDate.day.toString().padLeft(2, '0')}/"
                            "${exportDate.month.toString().padLeft(2, '0')}/"
                            "${exportDate.year} "
                            "${exportDate.hour.toString().padLeft(2, '0')}:"
                            "${exportDate.minute.toString().padLeft(2, '0')}\n"
                            "Barcod produs: ${history[i][Product.barcode]}",
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          label: Text("Extragere"),
          icon: Icon(Icons.arrow_upward),
          onPressed: () async {
            var needReload = await showDialog(
              context: context,
              builder: (context) {
                return ScanDialog(
                  Text('Extragere produs'),
                  transaction.insert,
                  (id, quantity) => <String, dynamic>{
                    Transaction.productId: id,
                    Transaction.quantity: quantity,
                    Transaction.transactionDate:
                        DateTime.now().toIso8601String(),
                  },
                  availableStockFunction: transaction.queryStock,
                  outFlag: true,
                );
              },
              barrierDismissible: false,
            );
            if (needReload) setState(() {});
          },
        ),
      ),
    );
  }
}
