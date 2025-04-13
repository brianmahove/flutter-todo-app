import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/screens/todo_editor.dart';
import '../models/todo.dart';
import '../../helpers/database_helper.dart';

class TodoItem extends StatelessWidget {
  final Activity activity;

  const TodoItem({super.key, required this.activity});

  void _handleActivityAction(BuildContext context, String action) async {
    final dbHelper = DatabaseHelper.instance;

    switch (action) {
      case 'edit':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoEditor(activity: activity)),
        );
        break;
      case 'delete':
        await dbHelper.deleteActivity(activity.id!);
        break;
      case 'extend':
        final newDate = await showDatePicker(
          context: context,
          initialDate: activity.dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (newDate != null) {
          final updated = activity.copyWith(dueDate: newDate);
          await dbHelper.updateActivity(updated);
        }
        break;
      case 'cancel':
        final updated = activity.copyWith(status: 'Canceled');
        await dbHelper.updateActivity(updated);
        break;
      case 'hold':
        final updated = activity.copyWith(status: 'On Hold');
        await dbHelper.updateActivity(updated);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(activity.title),
        subtitle: Text('Due: ${DateFormat.yMd().format(activity.dueDate)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(activity.status),
              backgroundColor: _getStatusColor(activity.status),
            ),
            PopupMenuButton(
              itemBuilder:
                  (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                    PopupMenuItem(value: 'extend', child: Text('Extend Date')),
                    PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                    PopupMenuItem(value: 'hold', child: Text('On Hold')),
                  ],
              onSelected:
                  (value) => _handleActivityAction(context, value.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Planned':
        return Colors.blue;
      case 'On Hold':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
