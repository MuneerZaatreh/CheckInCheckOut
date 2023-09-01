import 'package:flutter/material.dart';

enum DialogsAction { yes, cancel }

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
      BuildContext context, String title, String body) async {
    final action = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.right,
            ),
            content: Text(
              body,
              textAlign: TextAlign.right,
            ),
            actions: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      height: 30.0,
                      minWidth: 70.0,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text("نعم"),
                      onPressed: () =>
                          Navigator.of(context).pop(DialogsAction.yes),
                      splashColor: Colors.blue,
                    ),
                    MaterialButton(
                      height: 30.0,
                      minWidth: 70.0,
                      color: Colors.red,
                      textColor: Colors.white,
                      child: const Text("لا"),
                      onPressed: () =>
                          Navigator.of(context).pop(DialogsAction.cancel),
                      splashColor: Colors.redAccent,
                    )
                  ]),
            ],
          );
        });
    return (action != null) ? action : DialogsAction.cancel;
  }
}
