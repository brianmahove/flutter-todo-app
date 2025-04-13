import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../helpers/database_helper.dart';

class TodoEditor extends StatefulWidget {
  final Activity? activity;

  const TodoEditor({super.key, this.activity});

  @override
  _TodoEditorState createState() => _TodoEditorState();
}

class _TodoEditorState extends State<TodoEditor> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  late DateTime _dueDate;
  late String _status;

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _titleController.text = widget.activity!.title;
      _descController.text = widget.activity!.description;
      _dueDate = widget.activity!.dueDate;
      _status = widget.activity!.status;
    } else {
      _dueDate = DateTime.now();
      _status = 'Planned';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity == null ? 'New Activity' : 'Edit Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ListTile(
              title: Text('Due Date: ${DateFormat.yMd().format(_dueDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            DropdownButton<String>(
              value: _status,
              items:
                  ['Planned', 'On Hold', 'Canceled'].map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            ElevatedButton(onPressed: _saveActivity, child: Text('Save')),
          ],
        ),
      ),
    );
  }

  _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  _saveActivity() async {
    final activity = Activity(
      id: widget.activity?.id,
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate,
      status: _status,
    );

    if (widget.activity == null) {
      await DatabaseHelper.instance.createActivity(activity);
    } else {
      await DatabaseHelper.instance.updateActivity(activity);
    }
    Navigator.pop(context);
  }
}
