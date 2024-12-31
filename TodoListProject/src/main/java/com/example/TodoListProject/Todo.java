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

}

