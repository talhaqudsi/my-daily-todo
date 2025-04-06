import 'package:flutter/material.dart';
import 'package:hw7_todo_app/task_form.dart';
import 'package:hw7_todo_app/about.dart';

void main() {
  // GlobalKey used to access TodoAppState from other widgets (e.g., TaskForm)
  GlobalKey<TodoAppState> appKey = GlobalKey<TodoAppState>();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Daily To-Do',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: "/",
      routes: {
        // Root screen showing the task list
        "/": (context) => TodoApp(key: appKey),

        // Task creation form screen
        "/task_form": (context) => TaskForm(appKey: appKey),

        // About screen
        "/about": (context) => About(),
      },
    ),
  );
}

// Main widget displaying the task list
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => TodoAppState();
}

// Holds the state for TodoApp, including the list of tasks
class TodoAppState extends State<TodoApp> {
  final _tasks = <Task>[]; // List to store added tasks
  bool _hasShownDialog = false;

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Welcome!'),
          content: Text(
            'Tap the "+" button below to create your first task.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Schedule dialog after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownDialog) {
        _hasShownDialog = true; // Ensure it's only shown once
        _showWelcomeDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Daily To-Do'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Info icon in the app bar that navigates to the About screen
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, "/about"),
          ),
        ],
      ),

      // Displays the list of tasks using a ListView
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.task, color: Colors.blue), // Task icon
            title: Text(_tasks[index].taskName), // Task title

            // Only show the subtitle (description) if it's not empty
            subtitle: _tasks[index].description.isNotEmpty
                ? Text(_tasks[index].description)
                : null,

            // Right-aligned due date and time display
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _tasks[index].formattedDate,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'by ${_tasks[index].formattedTime}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),

      // Floating Action Button to add a new task
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to task form screen when FAB is tapped
          Navigator.pushNamed(context, '/task_form');
        },
      ),
    );
  }

  // Adds a new task and updates the UI
  void addTask(Task newTask) {
    setState(() {
      _tasks.add(newTask);
    });
  }
}
