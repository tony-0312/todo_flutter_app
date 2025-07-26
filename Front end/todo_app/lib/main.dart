import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/todo_provider.dart';

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}