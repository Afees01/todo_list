import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:async';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Network configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);
  static const Duration _timeoutDuration = Duration(seconds: 30);

  // Initialize Supabase with better configuration
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  // Check network connectivity with multiple fallbacks
  Future<bool> _isNetworkAvailable() async {
    try {
      // Try multiple DNS lookups for better reliability
      final List<String> testHosts = [
        'google.com',
        'cloudflare.com',
        'supabase.co',
      ];

      for (String host in testHosts) {
        try {
          final result = await InternetAddress.lookup(host)
              .timeout(const Duration(seconds: 5));
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next host
          continue;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Retry mechanism for network operations
  Future<T> _retryOperation<T>(Future<T> Function() operation) async {
    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        // Try the operation directly first, only check network on failure
        return await operation().timeout(_timeoutDuration);
      } catch (e) {
        // Only check network connectivity if we get a network-related error
        if (e.toString().contains('SocketException') ||
            e.toString().contains('TimeoutException') ||
            e.toString().contains('HandshakeException')) {
          if (!await _isNetworkAvailable()) {
            if (attempt == _maxRetries) {
              throw Exception('No internet connection available');
            }
          }
        }

        if (attempt == _maxRetries) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(_retryDelay * attempt);
      }
    }
    throw Exception('Operation failed after $_maxRetries attempts');
  }

  // Generic CRUD operations for any table with retry logic
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    return await _retryOperation(() async {
      final response = await client.from(table).select();
      return List<Map<String, dynamic>>.from(response);
    });
  }

  Future<Map<String, dynamic>?> getById(String table, String id) async {
    return await _retryOperation(() async {
      final response = await client.from(table).select().eq('id', id).single();
      return response;
    });
  }

  Future<List<Map<String, dynamic>>> insert(
      String table, Map<String, dynamic> data) async {
    return await _retryOperation(() async {
      final response = await client.from(table).insert(data).select();
      return List<Map<String, dynamic>>.from(response);
    });
  }

  Future<List<Map<String, dynamic>>> update(
      String table, String id, Map<String, dynamic> data) async {
    return await _retryOperation(() async {
      final response =
          await client.from(table).update(data).eq('id', id).select();
      return List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> delete(String table, String id) async {
    return await _retryOperation(() async {
      await client.from(table).delete().eq('id', id);
    });
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

  // Public method to check network connectivity
  Future<bool> isNetworkAvailable() async {
    return await _isNetworkAvailable();
  }

  // Test Supabase connection
  Future<bool> testConnection() async {
    try {
      await _retryOperation(() async {
        await client.from('todo').select().limit(1);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get detailed error information
  String getDetailedErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'Network connection failed. Please check your internet connection.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('HandshakeException')) {
      return 'SSL handshake failed. This might be due to network restrictions.';
    } else if (error.toString().contains('FormatException')) {
      return 'Invalid response format from server.';
    } else if (error.toString().contains('PlatformException')) {
      return 'Platform-specific error. Please restart the app and try again.';
    } else if (error.toString().contains('No internet connection available')) {
      return 'No internet connection. Please check your network settings.';
    } else {
      return 'Connection error: ${error.toString()}';
    }
  }

  // Android-specific network test
  Future<bool> testAndroidConnection() async {
    try {
      // Test basic connectivity
      final isNetworkAvailable = await _isNetworkAvailable();
      if (!isNetworkAvailable) {
        return false;
      }

      // Test Supabase connection with a simple query
      await client
          .from('todo')
          .select()
          .limit(1)
          .timeout(const Duration(seconds: 10));
      return true;
    } catch (e) {
      print('Android connection test failed: $e');
      return false;
    }
  }
}
