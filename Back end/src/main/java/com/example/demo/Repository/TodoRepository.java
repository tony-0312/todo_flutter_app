package com.example.demo.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.Model.Todo;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long>{
    
}
