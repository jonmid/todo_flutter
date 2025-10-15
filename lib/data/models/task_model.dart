import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.isCompleted,
    super.imageUrl,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      isCompleted: json['is_completed'] as bool,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_completed': isCompleted,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  // Método para convertir a JSON para inserción (sin id si es auto-generado)
  Map<String, dynamic> toJsonForInsert() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_completed': isCompleted,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  // Método para convertir a TaskEntity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      date: date,
      startTime: startTime,
      endTime: endTime,
      isCompleted: isCompleted,
      imageUrl: imageUrl,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      date: entity.date,
      startTime: entity.startTime,
      endTime: entity.endTime,
      isCompleted: entity.isCompleted,
      imageUrl: entity.imageUrl,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    String? imageUrl,
  }) {
    return TaskModel(
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
}