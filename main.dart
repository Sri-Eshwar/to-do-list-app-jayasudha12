import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> tasks = [];
  TextEditingController searchController = TextEditingController();

  List<Map<String, String>> get filteredTasks {
    if (searchController.text.isEmpty) return tasks;
    return tasks.where((task) => task["title"]!.toLowerCase().contains(searchController.text.toLowerCase())).toList();
  }

  void _addOrEditTask({int? index}) {
    TextEditingController titleController = TextEditingController(text: index != null ? tasks[index]["title"] : "");
    TextEditingController descriptionController = TextEditingController(text: index != null ? tasks[index]["description"] : "");
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? "Add Task" : "Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  String timestamp = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                  if (index == null) {
                    tasks.add({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "time": timestamp,
                    });
                  } else {
                    tasks[index] = {
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "time": timestamp,
                    };
                  }
                });
                Navigator.pop(context);
              },
              child: Text(index == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do List", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Tasks",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 10),
            const Text(
              "Stay productive and get things done!",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(child: Text("No tasks yet. Add a task!"))
                  : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(Icons.task, color: Colors.blue),
                            title: Text(filteredTasks[index]["title"]!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(filteredTasks[index]["description"]!),
                                const SizedBox(height: 5),
                                Text("Added: ${filteredTasks[index]["time"]}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.green),
                                  onPressed: () => _addOrEditTask(index: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
