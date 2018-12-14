import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ConfirmDelete extends StatefulWidget {
  final String itemKey;
  final DatabaseReference databaseReference;
  ConfirmDelete(this.itemKey, this.databaseReference);

  @override
  _ConfirmDeleteState createState() => _ConfirmDeleteState(itemKey, databaseReference);
}

class _ConfirmDeleteState extends State<ConfirmDelete> {
  final String itemKey;
  final DatabaseReference databaseReference;
  _ConfirmDeleteState(this.itemKey, this.databaseReference);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: FlatButton(
                        child: Text('Delete ToDo Item?'),
                        color: Colors.redAccent,
                        onPressed: () {
                          deleteEntry();
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
          )
        ]);
  }

  deleteEntry() {
    debugPrint(itemKey);
    databaseReference.child(itemKey).remove();
  }
}
