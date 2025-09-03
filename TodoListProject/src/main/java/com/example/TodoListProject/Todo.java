package com.example.TodoListProject;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection="todo")
public class Todo {

    @Id
    private String id;
    @JsonProperty("todoName")
    private String todoName;
    @JsonProperty("completed")
    private boolean completed;

    // Explicit getter and setter methods to ensure compilation works
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTodoName() {
        return todoName;
    }

    public void setTodoName(String todoName) {
        this.todoName = todoName;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }
}

