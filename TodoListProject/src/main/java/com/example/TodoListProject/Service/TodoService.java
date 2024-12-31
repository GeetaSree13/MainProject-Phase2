package com.example.TodoListProject.Service;

import com.example.TodoListProject.Repositary.TodoRepo;
import com.example.TodoListProject.Todo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TodoService {

    @Autowired
    private TodoRepo todoRepo;

    public Todo saveTodo(Todo todo){

        Todo savedTodo=todoRepo.save(todo);
        return savedTodo;
    }

    public void deleteTodo(String id){

        todoRepo.deleteById(id);
    }

    public List<Todo> getAllTodos(){
        return todoRepo.findAll();
    }

    public Todo updatedTodo(String id,boolean completed){
        Optional<Todo> todos = todoRepo.findById(id);
        if (todos.isEmpty()) {
            throw new RuntimeException("Task not found with id: " + id);
        }
        Todo todo = todos.get();
        todo.setCompleted(completed);
        return todoRepo.save(todo);

    }
}
