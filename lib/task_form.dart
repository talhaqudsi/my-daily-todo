import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hw7_todo_app/main.dart';
import 'package:intl/intl.dart';

// The form screen for creating a new task
class TaskForm extends StatefulWidget {
  const TaskForm({super.key, required this.appKey});

  // Reference to the TodoAppState, used to call addTask()
  final GlobalKey<TodoAppState> appKey;

  @override
  State<TaskForm> createState() => TaskFormState();
}

// Task model with basic fields and formatted date/time getters
class Task {
  final String taskName, description;
  final DateTime dueDate;

  Task({this.taskName = '', this.description = '', required this.dueDate});

  String get formattedDate => DateFormat('MM/dd/yyyy').format(dueDate);
  String get formattedTime => DateFormat('hh:mm aaa').format(dueDate);
}

class TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  // Form field values
  late String _taskName = '', _description = '';
  DateTime _dueDate = DateTime.now();

  // Rounds a TimeOfDay up to the next 15-minute increment
  TimeOfDay roundToNearest15Minutes(TimeOfDay time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final roundedTotal = ((totalMinutes + 14) ~/ 15) *
        15; // Always round up to the next 15 minute interval
    final roundedHour = roundedTotal ~/ 60;
    final roundedMinute = roundedTotal % 60;

    return TimeOfDay(hour: roundedHour % 24, minute: roundedMinute);
  }

  // Handles both date and time picking, then calls roundToNearest15Minutes to round time
  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
    );
    if (pickedTime == null || !context.mounted) return;

    final roundedTime = roundToNearest15Minutes(pickedTime);

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        roundedTime.hour,
        roundedTime.minute,
      );
    });
  }

  // Validates and submits the form, adds the task via appKey
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        _formKey.currentState!.save();

        final newTask = Task(
          taskName: _taskName,
          description: _description,
          dueDate: _dueDate,
        );

        // Add the task to TodoApp
        widget.appKey.currentState?.addTask(newTask);

        // Show task details popup
        _showTaskDetailsDialog(newTask);

        log('Task Name: $_taskName, Description: $_description, Due Date: $_dueDate');
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        SnackBar snackBar = SnackBar(content: Text('Error caught: $e'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  // Confirmation dialog after task is added
  void _showTaskDetailsDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Task Added'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${task.taskName}', style: TextStyle(fontWeight: FontWeight.bold)),
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${task.description}'),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                  'Due by ${task.formattedDate} at ${task.formattedTime}'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
            Navigator.of(context).pop(); // Close the alert dialog
            Navigator.of(context).pop(); // Return to main screen
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Sets _dueDate when the form is first initialized
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final rounded = roundToNearest15Minutes(TimeOfDay.fromDateTime(now));
    _dueDate =
        DateTime(now.year, now.month, now.day, rounded.hour, rounded.minute);
  }

  // Main form UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Form'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            // Task name field (required)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Task to Complete',
                border: OutlineInputBorder(),
              ),
              onSaved: (String? value) => _taskName = value ?? "",
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Task name is required";
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Optional description field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onSaved: (String? value) => _description = value ?? "",
            ),
            SizedBox(height: 16),

            // Date & time selector styled like a form field
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Due Date & Time',
                border: OutlineInputBorder(),
              ),
              child: InkWell(
                onTap: () {
                  _pickDateTime(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat('EEE, MMM d, yyyy').format(_dueDate)} at "
                      "${DateFormat('hh:mm aaa').format(_dueDate)}",
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Submit button
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Task'),
            ),
          ]),
        ),
      ),
    );
  }
}
