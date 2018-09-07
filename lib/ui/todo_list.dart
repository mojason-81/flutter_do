import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';
// import 'package:flutter_do/ui/todo_form.dart';
import 'package:flutter_do/util/auth_n.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  List<ToDoItem> todoItemList = List();
  ToDoItem toDoItem;

  @override
  void initState() {
    super.initState();
    toDoItem = ToDoItem('', '');
    databaseReference = database.reference().child('todo_list');
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
  }

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
            // ToDoForm(context, toDoItem, databaseReference),
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
                      ],
                    )
                ),
              ),
            ),
            Flexible(
              child: FirebaseAnimatedList(
                query: databaseReference,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation,
                    int index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                      ),
                      title: Text(todoItemList[index].title),
                      subtitle: Text(todoItemList[index].note),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  _signout() {
    // TODO: Do we want to use Navigator here?
    logout();
  }

  void _onEntryAdded(Event event) {
    setState(() {
      todoItemList.add(ToDoItem.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var oldEntry = todoItemList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      todoItemList[todoItemList.indexOf(oldEntry)] = ToDoItem.fromSnapshot(event.snapshot);
    });
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
