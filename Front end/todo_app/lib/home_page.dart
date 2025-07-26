import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_model.dart';
import 'package:todo_app/todo_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TodoProvider>().fetchTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.todos.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      if (value != null) {
                        todoProvider.updateTodo(
                          Todo(
                            id: todo.id,
                            title: todo.title,
                            description: todo.description,
                            completed: value,
                            createdAt: todo.createdAt,
                            updatedAt: DateTime.now(),
                          ),
                        );
                      }
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: todo.completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: todo.description != null && todo.description!.isNotEmpty
                      ? Text(
                          todo.description!,
                          style: TextStyle(
                            decoration: todo.completed ? TextDecoration.lineThrough : null,
                          ),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(context, todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(context, todo),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        return AlertDialog(
          title: Text('Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Description'),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (title.isNotEmpty) {
                  context.read<TodoProvider>().addTodo(
                        Todo(
                          title: title,
                          description: description,
                          completed: false,
                          createdAt: DateTime.now(),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = todo.title;
        String description = todo.description ?? '';
        return AlertDialog(
          title: Text('Edit Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Title'),
                onChanged: (value) => title = value,
                controller: TextEditingController(text: title),
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Description'),
                onChanged: (value) => description = value,
                controller: TextEditingController(text: description),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (title.isNotEmpty) {
                  context.read<TodoProvider>().updateTodo(
                        Todo(
                          id: todo.id,
                          title: title,
                          description: description,
                          completed: todo.completed,
                          createdAt: todo.createdAt,
                          updatedAt: DateTime.now(),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Todo'),
          content: Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                context.read<TodoProvider>().deleteTodo(todo.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}