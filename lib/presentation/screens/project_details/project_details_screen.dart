import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';
import '../../bloc/todo_state.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../utils/app_colors.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String todoId;

  const ProjectDetailsScreen({super.key, required this.todoId});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodosEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Task Details',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      //  BlocListener<TodoBloc, TodoState>(
      //   listener: (context, state) {
      //     if (state is TodoLoaded) {
      //       // Check if the current todo was deleted (not in the list anymore)
      //       final todoExists =
      //           state.todos.any((todo) => todo.id == widget.todoId);
      //       if (!todoExists) {
      //         // Todo was deleted, navigate back to home
      //         Navigator.of(context).pushNamedAndRemoveUntil(
      //           '/home',
      //           (route) => false,
      //         );
      //       }
      //     }
      //   },
      //   child:
      body: Center(
        child: Container(
          width: isDesktop ? 800 : double.infinity,
          constraints: BoxConstraints(
            maxHeight: screenHeight,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 32 : 24),
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TodoError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: GoogleFonts.poppins(color: AppColors.error),
                      ),
                    );
                  } else if (state is TodoLoaded) {
                    if (state.todos.isEmpty) {
                      return _buildEmptyState(isTablet);
                    }

                    try {
                      final todo = state.todos.firstWhere(
                        (t) => t.id == widget.todoId,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTodoInfoCard(todo, isTablet),
                          SizedBox(height: isTablet ? 32 : 24),
                          _buildActionsSection(isTablet),
                        ],
                      );
                    } catch (e) {
                      return _buildTodoNotFoundState(isTablet);
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildTodoInfoCard(TodoEntity todo, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.task_outlined,
                  color: AppColors.primary,
                  size: isTablet ? 28 : 24,
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: Text(
                  todo.title,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (todo.description.isNotEmpty) ...[
            SizedBox(height: isTablet ? 20 : 16),
            Text(
              'Description',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: isTablet ? 8 : 4),
            Text(
              todo.description,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          SizedBox(height: isTablet ? 20 : 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: isTablet ? 20 : 16,
                color: AppColors.textHint,
              ),
              SizedBox(width: isTablet ? 8 : 4),
              Text(
                'Start Date: ${todo.startDate}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: isTablet ? 20 : 16,
                color: AppColors.textHint,
              ),
              SizedBox(width: isTablet ? 8 : 4),
              Text(
                'End Date: ${todo.endDate}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: isTablet ? 20 : 16,
                color: AppColors.textHint,
              ),
              SizedBox(width: isTablet ? 8 : 4),
              Text(
                'Created: ${_formatDate(todo.createdAt)}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit functionality coming soon!'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
            label: Text(
              'Edit Task',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showDeleteConfirmation();
            },
            icon: const Icon(Icons.delete_outlined),
            label: Text(
              'Delete Task',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Task',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<TodoBloc>().add(DeleteTodoEvent(id: widget.todoId));
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildEmptyState(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 40 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_outlined,
            size: isTablet ? 80 : 64,
            color: AppColors.textHint,
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            'No tasks available',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            'There are no tasks to display at the moment.',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodoNotFoundState(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 40 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: isTablet ? 80 : 64,
            color: AppColors.error,
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            'Task has been deleted',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            'The requested task has been deleted.',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32 : 24,
                vertical: isTablet ? 16 : 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Go Back',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
