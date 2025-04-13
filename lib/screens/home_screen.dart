import 'package:flutter/material.dart';
import 'package:todo_app/screens/todo_editor.dart';
import '../helpers/database_helper.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'todo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    activities = await DatabaseHelper.instance.getActivities();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo App')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSection(
                'Activities',
                TodoListScreen(),
                activities.take(2).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSection(String title, Widget screen, List items) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: ElevatedButton(
            child: Text('View All'),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                ),
          ),
        ),
        items.isEmpty
            ? Padding(
              padding: EdgeInsets.all(16),
              child: Text('No $title available. Tap + to create!'),
            )
            : Column(
              children:
                  items.map((item) {
                    if (item is Activity) return TodoItem(activity: item);
                    return SizedBox();
                  }).toList(),
            ),
      ],
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Add Activity'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditor(TodoEditor());
                },
              ),
            ],
          ),
    );
  }

  _navigateToEditor(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    _loadData();
  }
}
