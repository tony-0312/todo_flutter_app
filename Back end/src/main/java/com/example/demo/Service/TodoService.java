package com.example.demo.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.example.demo.Model.Todo;
import com.example.demo.Repository.TodoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TodoService {
    private final TodoRepository todoRepository;

    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }

    public Optional<Todo> getById(Long id) {
        return todoRepository.findById(id);
    }

    public Todo create(Todo todo) {
        todo.setCreatedAt(LocalDateTime.now());
        todo.setCompleted(false);
        return todoRepository.save(todo);
    }

    public Todo update(Long id, Todo todoDetails) {
        Optional<Todo> todo = todoRepository.findById(id);
        if (todo.isPresent()) {
            Todo existingTodo = todo.get();
            existingTodo.setTitle(todoDetails.getTitle());
            existingTodo.setDescription(todoDetails.getDescription());
            existingTodo.setCompleted(todoDetails.isCompleted());
            existingTodo.setUpdatedAt(LocalDateTime.now());
            return todoRepository.save(existingTodo);
        }
        return null;
    }

    public void delete(Long id) {
        todoRepository.deleteById(id);
    }
}