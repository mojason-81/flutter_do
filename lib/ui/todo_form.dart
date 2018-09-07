// TODO: would like to stick the form in it's own class, but it is more difficult than expected
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';

class ToDoForm extends StatefulWidget {
  ToDoForm(BuildContext context, ToDoItem toDoItem, DatabaseReference databaseReference);

  @override
  _ToDoFormState createState() => _ToDoFormState(BuildContext context, ToDoItem toDoItem, DatabaseReference databaseReference);
}

class _ToDoFormState extends State<ToDoForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var context;
  var toDoItem;
  var databaseReference;

  _ToDoFormState(this.context, this.toDoItem, this.databaseReference);

  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      return Flexible(
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
                ],
              )
          ),
        ),
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
}
