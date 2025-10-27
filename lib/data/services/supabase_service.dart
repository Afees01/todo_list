import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // Generic CRUD operations for any table
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final response = await client.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch data from $table: $e');
    }
  }

  Future<Map<String, dynamic>?> getById(String table, String id) async {
    try {
      final response = await client.from(table).select().eq('id', id).single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch data from $table with id $id: $e');
    }
  }

  Future<List<Map<String, dynamic>>> insert(
      String table, Map<String, dynamic> data) async {
    try {
      final response = await client.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to insert data into $table: $e');
    }
  }

  Future<List<Map<String, dynamic>>> update(
      String table, String id, Map<String, dynamic> data) async {
    try {
      final response =
          await client.from(table).update(data).eq('id', id).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to update data in $table with id $id: $e');
    }
  }

  Future<void> delete(String table, String id) async {
    try {
      await client.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete data from $table with id $id: $e');
    }
  }

  // Specific methods for todos
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    return await getAll('todo');
  }

  Future<List<Map<String, dynamic>>> insertTodo(
      Map<String, dynamic> todoData) async {
    return await insert('todo', todoData);
  }

  Future<List<Map<String, dynamic>>> updateTodo(
      String id, Map<String, dynamic> todoData) async {
    return await update('todo', id, todoData);
  }

  Future<void> deleteTodo(String id) async {
    await delete('todo', id);
  }
}
