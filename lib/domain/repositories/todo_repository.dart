import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getAllTodos();
  Future<TodoEntity?> getTodoById(String id);
  Future<TodoEntity> createTodo(TodoEntity todo);
  Future<TodoEntity> updateTodo(TodoEntity todo);
  Future<void> deleteTodo(String id);
}
