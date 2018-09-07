import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';
import 'package:flutter_do/util/auth_n.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  List<ToDoItem> todoItems = List();
  ToDoItem toDoItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ToDo'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => _signout(),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 0,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      ListTile(
                          leading: Icon(Icons.title),
                          title: TextFormField(
                            initialValue: '',
                            onSaved: (val) => toDoItem.title = val,
                            validator: (val) =>
                            val.isEmpty ? 'Cannot be empty.' : null,
                          )),
                      ListTile(
                          leading: Icon(Icons.note),
                          title: TextFormField(
                            initialValue: '',
                            onSaved: (val) => toDoItem.note = val,
                            validator: (val) => null,
                          )),
                      FlatButton(
                        child: Text('Do it!'),
                        color: Colors.redAccent,
                        onPressed: () => handleSubmit(),
                      )
                      // TODO: add another Flexible with nested FirebaseAnimatedList
                    ],
                  )
                ),
              ),
            )
          ],
        ));
  }

  _signout() {
    // TODO: Do we want to use Navigator here?
    logout();
  }

  handleSubmit() {
   // TODO: handle submit
  }
}
