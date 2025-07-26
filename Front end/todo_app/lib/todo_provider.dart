import 'package:flutter/material.dart';
import 'package:todo_app/todo_model.dart';
import 'package:todo_app/todo_service.dart';

class TodoProvider with ChangeNotifier {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    try {
      _todos = await _todoService.getTodos();
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final newTodo = await _todoService.createTodo(todo);
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final updatedTodo = await _todoService.updateTodo(todo);
      final index = _todos.indexWhere((t) => t.id == updatedTodo.id);
      if (index != -1) {
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _todoService.deleteTodo(id);
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}