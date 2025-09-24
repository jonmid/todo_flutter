import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tableName = 'tasks';

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('date', ascending: true);

      return response
          .map<TaskEntity>((json) => TaskModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener las tareas: $e');
    }
  }

  @override
  Future<TaskEntity> getTaskById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', id)
          .single();

      return TaskModel.fromJson(response).toEntity();
    } catch (e) {
      throw Exception('Error al obtener la tarea por ID: $e');
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      
      await _client
          .from(_tableName)
          .insert(taskModel.toJsonForInsert());
    } catch (e) {
      throw Exception('Error al crear la tarea: $e');
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      
      await _client
          .from(_tableName)
          .update(taskModel.toJson())
          .eq('id', task.id);
    } catch (e) {
      throw Exception('Error al actualizar la tarea: $e');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar la tarea: $e');
    }
  }

  @override
  Future<List<TaskEntity>> getTasksByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final response = await _client
          .from(_tableName)
          .select()
          .gte('date', startOfDay.toIso8601String())
          .lte('date', endOfDay.toIso8601String())
          .order('start_time', ascending: true);

      return response
          .map<TaskEntity>((json) => TaskModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener las tareas por fecha: $e');
    }
  }
}