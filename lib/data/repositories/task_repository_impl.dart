import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final List<TaskModel> _tasks = [];

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return List<TaskEntity>.from(_tasks);
  }

  @override
  Future<TaskEntity> getTaskById(String id) async {
    final task = _tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw Exception('Task not found'),
    );
    return task;
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final taskModel = TaskModel.fromEntity(task);
    _tasks.add(taskModel);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = TaskModel.fromEntity(task);
    } else {
      throw Exception('Task not found');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(DateTime date) async {
    final filteredTasks = _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
    return List<TaskEntity>.from(filteredTasks);
  }
}