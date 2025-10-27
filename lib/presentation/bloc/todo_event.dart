import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  const AddTodoEvent({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [title, description, startDate, endDate];
}

class UpdateTodoEvent extends TodoEvent {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  const UpdateTodoEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, title, description, startDate, endDate];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;

  const DeleteTodoEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
