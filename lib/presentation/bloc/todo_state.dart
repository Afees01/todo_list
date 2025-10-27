import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_entity.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;

  const TodoLoaded({required this.todos});

  @override
  List<Object?> get props => [todos];
}

class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TodoOperationSuccess extends TodoState {
  final String message;

  const TodoOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
