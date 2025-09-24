import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

class TaskController extends GetxController {
  final TaskRepository _taskRepository = TaskRepositoryImpl();
  
  // Observable variables
  final RxList<TaskEntity> _tasks = <TaskEntity>[].obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxBool _isLoading = false.obs;

  // Getters
  List<TaskEntity> get tasks => _tasks;
  DateTime get selectedDate => _selectedDate.value;
  Rx<DateTime> get selectedDateRx => _selectedDate;
  bool get isLoading => _isLoading.value;
  
  // Get tasks for selected date
  List<TaskEntity> get todayTasks {
    return _tasks.where((task) {
      return task.date.year == _selectedDate.value.year &&
          task.date.month == _selectedDate.value.month &&
          task.date.day == _selectedDate.value.day;
    }).toList();
  }

  // Get completed tasks count for today
  int get completedTasksCount {
    return todayTasks.where((task) => task.isCompleted).length;
  }

  // Get total tasks count for today
  int get totalTasksCount => todayTasks.length;

  // Format date for display
  String get formattedDate => DateFormat('d MMM').format(_selectedDate.value);
  String get dayOfWeek => DateFormat('EEEE').format(_selectedDate.value);

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Load all tasks
  Future<void> loadTasks() async {
    try {
      _isLoading.value = true;
      final tasks = await _taskRepository.getAllTasks();
      _tasks.assignAll(tasks);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Load tasks for specific date
  Future<void> loadTasksForDate(DateTime date) async {
    try {
      _isLoading.value = true;
      final tasks = await _taskRepository.getTasksByDate(date);
      _tasks.assignAll(tasks);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tasks for date: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add new task
  Future<void> addTask(TaskEntity task) async {
    try {
      await _taskRepository.addTask(task);
      // Reload tasks to get the updated list from Supabase
      await loadTasksForDate(_selectedDate.value);
      Get.snackbar('Success', 'Task added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  // Update task
  Future<void> updateTask(TaskEntity task) async {
    try {
      await _taskRepository.updateTask(task);
      // Reload tasks to get the updated list from Supabase
      await loadTasksForDate(_selectedDate.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
    }
  }

  // Toggle task completion
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
        await updateTask(updatedTask);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepository.deleteTask(taskId);
      // Reload tasks to get the updated list from Supabase
      await loadTasksForDate(_selectedDate.value);
      Get.snackbar('Success', 'Task deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  // Change selected date
  void changeSelectedDate(DateTime date) {
    _selectedDate.value = date;
    loadTasksForDate(date); // Load tasks for the new selected date
  }


}