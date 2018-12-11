import 'package:firebase_database/firebase_database.dart';

class ToDoItem {
  String key;
  String title;
  String date;
  String note;

  ToDoItem(this.title, this.note, this.date);

  ToDoItem.fromSnapshot(DataSnapshot snapshot) :
      key = snapshot.key,
      title = snapshot.value['title'],
      date = snapshot.value['date'],
      note = snapshot.value['note'];

  toJson() {
    return {
      'title': title,
      'note': note,
      'date': date
    };
  }
}