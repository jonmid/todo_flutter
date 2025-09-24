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
    _initializeSampleData();
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

  // Add new task
  Future<void> addTask(TaskEntity task) async {
    try {
      await _taskRepository.addTask(task);
      _tasks.add(task);
      Get.snackbar('Success', 'Task added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  // Update task
  Future<void> updateTask(TaskEntity task) async {
    try {
      await _taskRepository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
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
      _tasks.removeWhere((task) => task.id == taskId);
      Get.snackbar('Success', 'Task deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  // Change selected date
  void changeSelectedDate(DateTime date) {
    _selectedDate.value = date;
  }

  // Initialize sample data
  void _initializeSampleData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final sampleTasks = [
      TaskEntity(
        id: '1',
        title: 'Fitness',
        description: 'Exercise and gym',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 6, 0),
        endTime: DateTime(today.year, today.month, today.day, 7, 30),
        isCompleted: true,
      ),
      TaskEntity(
        id: '2',
        title: 'Check Emails and sms',
        description: 'Review and respond to emails and SMS',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 7, 30),
        endTime: DateTime(today.year, today.month, today.day, 8, 0),
        isCompleted: true,
      ),
      TaskEntity(
        id: '3',
        title: 'Work on Projects',
        description: 'Focus on all the tasks related to Project',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 8, 0),
        endTime: DateTime(today.year, today.month, today.day, 10, 0),
        isCompleted: true,
      ),
      TaskEntity(
        id: '4',
        title: 'Attend Meeting',
        description: 'Team meeting with the client ABC',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 10, 0),
        endTime: DateTime(today.year, today.month, today.day, 11, 0),
        isCompleted: false,
      ),
      TaskEntity(
        id: '5',
        title: 'Work of XYZ',
        description: 'Change theme and ideas in XYZ',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 11, 0),
        endTime: DateTime(today.year, today.month, today.day, 13, 0),
        isCompleted: false,
      ),
      TaskEntity(
        id: '6',
        title: 'Lunch Break',
        description: 'Enjoy a healthy lunch and take some rest',
        date: today,
        startTime: DateTime(today.year, today.month, today.day, 13, 0),
        endTime: DateTime(today.year, today.month, today.day, 14, 30),
        isCompleted: false,
      ),
    ];

    for (final task in sampleTasks) {
      _taskRepository.addTask(task);
      _tasks.add(task);
    }
  }
}