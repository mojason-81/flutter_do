import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';
import 'package:flutter_do/ui/todo_form.dart';
import 'package:flutter_do/util/auth_n.dart';
import 'confirm_delet.dart';

// FIXME: Didn't load list on initial screen load

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  List<ToDoItem> todoItemList = List();

  @override
  void initState() {
    super.initState();
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
            Flexible(
              flex: 0,
              child: Center(
                child: FlatButton(
                    child: Text(
                      'Add TODO',
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => ToDoForm()
                      ));
                  },
                )
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
                        child: Text(
                          _avatarLetter(index)
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                      title: Text(todoItemList[index].title),
                      subtitle: Text(todoItemList[index].note),
                      trailing: Text("Due On:\n${todoItemList[index].formattedDateString()}"),
                      onLongPress: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              // FIXME: for some reason, the incorrect items is removed from the list in the UI
                              return ConfirmDelete(todoItemList[index].key, databaseReference);
                            }
                        ));
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }

  String _avatarLetter(int idx) {
    String t = todoItemList[idx].title;
    if (t != null) {
      return t.substring(0,1).toUpperCase();
    } else {
      return '';
    }
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
}
