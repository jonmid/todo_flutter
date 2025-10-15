class TaskEntity {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final bool isCompleted;
  final String? imageUrl;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isCompleted,
    this.imageUrl,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    String? imageUrl,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isCompleted == isCompleted &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        isCompleted.hashCode ^
        imageUrl.hashCode;
  }
}
