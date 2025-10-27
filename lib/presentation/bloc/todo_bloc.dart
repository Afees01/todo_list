import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(TodoInitial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(
      LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.getAllTodos();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todo = TodoEntity(
        id: '',
        title: event.title,
        description: event.description,
        startDate: event.startDate,
        endDate: event.endDate,
        createdAt: DateTime.now(),
      );
      await _todoRepository.createTodo(todo);
      emit(TodoOperationSuccess(message: 'Todo added successfully'));
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onUpdateTodo(
      UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todo = TodoEntity(
        id: event.id,
        title: event.title,
        description: event.description,
        startDate: event.startDate,
        endDate: event.endDate,
        createdAt: DateTime.now(),
      );
      await _todoRepository.updateTodo(todo);
      emit(TodoOperationSuccess(message: 'Todo updated successfully'));
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      await _todoRepository.deleteTodo(event.id);
      emit(TodoOperationSuccess(message: 'Todo deleted successfully'));
      add(LoadTodosEvent());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}
