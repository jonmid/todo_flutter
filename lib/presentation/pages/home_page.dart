import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/task_controller.dart';
import '../widgets/date_selector.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import '../controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Purple header section
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Top bar with menu and timer icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: PopupMenuButton<String>(
                            padding: const EdgeInsets.all(4),
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, size: 18),
                                    SizedBox(width: 8),
                                    Text('Cerrar sesión'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'logout') {
                                authController.signOut();
                              }
                            },
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              // Aquí puedes agregar lógica adicional si es necesario
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                controller.formattedDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.timer_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Today section with task count and Add New button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(
                              () => Text(
                                '${controller.totalTasksCount} Tasks',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => const AddTaskPage()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Add New',
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // White content section
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Date selector
                      const DateSelector(),

                      const SizedBox(height: 24),

                      // My Tasks header with reload button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Obx(() => GestureDetector(
                            onTap: controller.isLoading 
                                ? null 
                                : () => controller.loadTasksForDate(controller.selectedDate),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: controller.isLoading 
                                    ? AppColors.primaryPurple.withOpacity(0.3)
                                    : AppColors.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryPurple.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: controller.isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryPurple,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.refresh,
                                      color: AppColors.primaryPurple,
                                      size: 16,
                                    ),
                            ),
                          )),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tasks list
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryPurple,
                              ),
                            );
                          }

                          final todayTasks = controller.todayTasks;

                          if (todayTasks.isEmpty) {
                            return const Center(
                              child: Text(
                                'No tasks for today',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: todayTasks.length,
                            itemBuilder: (context, index) {
                              return TaskCard(task: todayTasks[index]);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
