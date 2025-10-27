class TodoEntity {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final DateTime createdAt;

  TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });
}
