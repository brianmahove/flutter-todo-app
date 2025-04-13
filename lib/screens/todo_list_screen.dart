import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_editor.dart';
import '../helpers/database_helper.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  _loadActivities() async {
    activities = await DatabaseHelper.instance.getActivities();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Activities')),
      body:
          activities.isEmpty
              ? Center(child: Text('No activities found'))
              : ListView.builder(
                itemCount: activities.length,
                itemBuilder:
                    (context, index) => TodoItem(activity: activities[index]),
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TodoEditor()),
            ).then((_) => _loadActivities()),
      ),
    );
  }
}
