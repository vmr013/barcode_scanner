import 'package:barcode_scanner/database_management/database_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductDialog();
}

class _ProductDialog extends State<ProductDialog> {
  var nameController = TextEditingController();
  var nameFocusNode = FocusNode();
  var nameError = false;

  var barcodeController = TextEditingController();
  var barcodeFocusNode = FocusNode();
  var barcodeError = false;
  var manually = false;

  var outOfScanner = true;

  @override
  Widget build(BuildContext context) {
    if (outOfScanner && nameController.text.isEmpty)
      nameFocusNode.requestFocus();
//    else if (barcodeEmpty) barcodeFocusNode.requestFocus();
    return SimpleDialog(
      title: Text("Înregistrare"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Denumire: ",
                  hintText: "Denumire produs ... ",
                  errorText: (nameError)
                      ? "Denumirea produsului este obligatorie"
                      : null,
                ),
                controller: nameController,
                focusNode: nameFocusNode,
                keyboardType: TextInputType.text,
                textInputAction:
                    (manually) ? TextInputAction.next : TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                onEditingComplete: () {
                  barcodeFocusNode.requestFocus();
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: manually,
                    onChanged: (value) {
                      setState(() {
                        manually = value;
                      });
                    },
                  ),
                  Text("Introducere manuală a codului de bare"),
                ],
              ),
              (manually)
                  ? TextField(
                      decoration: InputDecoration(
                        labelText: "Cod de bare: ",
                        hintText: "Introduceți manual ...",
                        helperText:
                            "Cod din litere mari și cifre sau doar cifre",
                        errorText: (barcodeError)
                            ? "Codul de bare este obligatoriu"
                            : null,
                      ),
                      controller: barcodeController,
                      focusNode: barcodeFocusNode,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[A-Z0-9]+"))
                      ],
                      onEditingComplete: () {
                        barcodeFocusNode.unfocus();
                      },
                    )
                  : Column(
                      children: [
                        RaisedButton.icon(
                          label: Text("Scanare"),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              outOfScanner = false;
                            });
                            var result =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#ff4297",
                                    "Anulează",
                                    true,
                                    ScanMode.DEFAULT);
                            if (result == '-1') {
                              setState(() {
                                barcodeController.text = "";
                                outOfScanner = true;
                              });
                              return;
                            }
                            setState(() {
                              barcodeController.text = result;
                              outOfScanner = true;
                            });
                          },
                          icon: Icon(Icons.settings_overscan),
                        ),
                        Text(
                          "Barcod: ${barcodeController.text}",
                          style: TextStyle(
                            color: (barcodeError) ? Colors.red : Colors.green,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        Row(
          children: <Widget>[
            RaisedButton.icon(
              label: Text("Anulare"),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel),
            ),
            RaisedButton.icon(
              onPressed: () async {
                setState(() {
                  nameError = nameController.text.isEmpty;
                  barcodeError = barcodeController.text.isEmpty;
                });
                if (nameError || barcodeError) {
                  return;
                }
                var instance = Operation.instance;
                instance.insert({
                  Operation.json: "{"
                      "\"product\":"
                      "{"
                      "\"${Product.name}\":\"${nameController.text}\","
                      "\"barcode\":\"${barcodeController.text}\","
                      "\"${Product.registrationDate}\":\"${DateTime.now().toIso8601String()}\""
                      "}"
                      "}"
                });
                Navigator.pop(context);
              },
              icon: Icon(Icons.done),
              label: Text("Terminat"),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ],
    );
  }
}
