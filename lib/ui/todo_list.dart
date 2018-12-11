import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_do/models/todo_item.dart';
import 'package:flutter_do/ui/todo_form.dart';
import 'package:flutter_do/util/auth_n.dart';

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
                      debugPrint('I worked');
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
                        backgroundColor: Colors.greenAccent,
                      ),
                      title: Text(todoItemList[index].title),
                      subtitle: Text(todoItemList[index].note),
                      trailing: Text('Due Date: ${todoItemList[index].date}'),
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
}
