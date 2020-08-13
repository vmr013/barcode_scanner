import 'package:barcode_scanner/database_management/remote_database_management.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var history;
    return FutureBuilder(
      future: Product.query(),
      builder: (context, snapshot) {
        List<Widget> children = [];
        if (snapshot.hasData) {
          history = snapshot.data;
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Eroare la încărcare: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Se încarcă produsele înregistrate...'),
            )
          ];
        }
        return (history == null)
            ? Center(
              child: Column(
                  children: children,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
                ),
            )
            : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, i) {
                  var dateTime =
                      DateTime.parse(history[i][Product.registrationDate]);
                  return ListTile(
                    title: Text("${i + 1}. ${history[i][Product.name]}"),
                    onTap: () async {
                      var productId = history[i][Product.id];
                      var stock = await Transaction.queryStock(id: productId);
//                      if (stock == null ||
//                          stock[0] == null ||
//                          stock[0]['stock'] == null)
//                        stock = 0;
//                      else {
//                        stock = stock[0]['stock'];
//                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            "Barcode: ${history[i]['barcode']}\n"
                            "Data înregistrării: ${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}\n"
                            "Stoc: $stock unități",
                          ),
                        ),
                      );
                    },
                  );
                },
              );
      },
    );
  }
}