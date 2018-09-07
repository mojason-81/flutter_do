import 'package:firebase_database/firebase_database.dart';

class ToDoItem {
  String key;
  String title;
  String note;

  ToDoItem(this.title, this.note);

  ToDoItem.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      title = snapshot.value['title'],
      note = snapshot.value['note'];

  toJson() {
    return {
      'title': title,
      'note': note
    };
  }
}