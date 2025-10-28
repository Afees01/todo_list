import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../models/todo_models.dart';
import '../services/supabase_service.dart';

class TodoRepositoryImpl implements TodoRepository {
  final SupabaseService _supabaseService;

  TodoRepositoryImpl({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  TodoEntity _mapModelToEntity(TodoModel model) {
    return TodoEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      startDate: model.startDate,
      endDate: model.endDate,
      createdAt: model.createdAt,
    );
  }

  TodoModel _mapEntityToModel(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      createdAt: entity.createdAt,
    );
  }

  @override
  Future<List<TodoEntity>> getAllTodos() async {
    try {
      final response = await _supabaseService.getAll('todo');
      final models = response.map((json) => TodoModel.fromJson(json)).toList();
      return models.map(_mapModelToEntity).toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  @override
  Future<TodoEntity?> getTodoById(String id) async {
    try {
      final response = await _supabaseService.getById('todo', id);
      return response != null
          ? _mapModelToEntity(TodoModel.fromJson(response))
          : null;
    } catch (e) {
      throw Exception('Failed to fetch todo with id $id: $e');
    }
  }

  @override
  Future<TodoEntity> createTodo(TodoEntity todo) async {
    try {
      final model = _mapEntityToModel(todo);
      final response = await _supabaseService.insert('todo', model.toJson());
      if (response.isEmpty) {
        throw Exception('No data returned from create operation');
      }
      return _mapModelToEntity(TodoModel.fromJson(response.first));
    } catch (e) {
      throw Exception('Failed to create todo: $e');
    }
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    try {
      final model = _mapEntityToModel(todo);
      final response =
          await _supabaseService.update('todo', todo.id, model.toJson());
      if (response.isEmpty) {
        throw Exception('No data returned from update operation');
      }
      return _mapModelToEntity(TodoModel.fromJson(response.first));
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _supabaseService.delete('todo', id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}
