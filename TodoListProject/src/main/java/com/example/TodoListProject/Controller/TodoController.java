package com.example.TodoListProject.Controller;

import com.example.TodoListProject.Service.TodoService;
import com.example.TodoListProject.Todo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RequestMapping("api/v1/todo")
@RestController
@CrossOrigin(origins="*")
public class TodoController {

    @Autowired
    private TodoService todoService;

    @PostMapping("/save")
    public ResponseEntity<Todo> savingTodo(@RequestBody Todo todo){
        Todo savedTodo=todoService.saveTodo(todo);
        return ResponseEntity.ok(savedTodo);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Todo> deletingTodo(@PathVariable String id){
        todoService.deleteTodo(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/getall")
    public ResponseEntity<List<Todo>> allTodos(){
        List<Todo> todos=todoService.getAllTodos();
        return ResponseEntity.ok(todos);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Todo> updatingTodos(@PathVariable String id,@RequestParam boolean completed){
        Todo updateTodo=todoService.updatedTodo(id,completed);
        return ResponseEntity.ok(updateTodo);

    }
}