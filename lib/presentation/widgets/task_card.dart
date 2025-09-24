import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/task_controller.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;

  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.isCompleted ? AppColors.lightPurple : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? AppColors.primaryPurple : AppColors.pendingTask,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time section
          Container(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm').format(task.startTime),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: task.isCompleted ? AppColors.primaryPurple : AppColors.primaryText,
                  ),
                ),
                Text(
                  '- ${DateFormat('HH:mm').format(task.endTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isCompleted ? AppColors.primaryPurple : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          
          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: task.isCompleted ? AppColors.primaryPurple : AppColors.primaryText,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: task.isCompleted ? AppColors.primaryPurple : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          
          // Checkbox
          GestureDetector(
            onTap: () => controller.toggleTaskCompletion(task.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.primaryPurple : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? AppColors.primaryPurple : AppColors.pendingTask,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}