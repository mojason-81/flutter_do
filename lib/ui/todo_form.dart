// TODO: would like to stick the form in it's own class, but it is more difficult than expected
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';

class ToDoForm extends StatefulWidget {
  @override
  _ToDoFormState createState() => _ToDoFormState();
}

class _ToDoFormState extends State<ToDoForm> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  ToDoItem toDoItem;

  @override
  void initState() {
    super.initState();
    toDoItem = ToDoItem('', '');
    databaseReference = database.reference().child('todo_list');
    // databaseReference.onChildAdded.listen(_onEntryAdded);
    // databaseReference.onChildChanged.listen(_onEntryChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Form(
              key: formKey,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      onPressed: () {
                        handleSubmit();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      // save from data to db
      databaseReference.push().set(toDoItem.toJson());
    }
  }
}
