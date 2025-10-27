import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';
import '../../bloc/todo_state.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: SafeArea(
        child: Center(
          child: Container(
            width: isDesktop ? 800 : double.infinity,
            constraints: BoxConstraints(
              maxHeight: screenHeight,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isTablet),
                    SizedBox(height: isTablet ? 32 : 24),
                    _buildProfileSection(isTablet),
                    SizedBox(height: isTablet ? 32 : 24),
                    _buildTaskToDoSection(isTablet),
                    SizedBox(height: isTablet ? 24 : 16),
                    _buildTodoList(isTablet),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-project');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Task Management',
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(bool isTablet) {
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
      child: Row(
        children: [
          CircleAvatar(
            radius: isTablet ? 30 : 24,
            backgroundColor: AppColors.primary,
            child: Text(
              'A',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Afees',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 20 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isTablet ? 4 : 2),
                Text(
                  'Let\'s organize your tasks',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 16 : 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskToDoSection(bool isTablet) {
    return Text(
      'Task To Do',
      style: GoogleFonts.poppins(
        fontSize: isTablet ? 24 : 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTodoList(bool isTablet) {
    return BlocBuilder<TodoBloc, TodoState>(
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
          return Column(
            children: state.todos
                .map((todo) => _buildTodoCard(todo, isTablet))
                .toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
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
            'No tasks yet',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            'Add your first task to get started',
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

  Widget _buildTodoCard(TodoEntity todo, bool isTablet) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/project-details',
          arguments: {'todoId': todo.id},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.task_outlined,
                    color: AppColors.primary,
                    size: isTablet ? 24 : 20,
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: Text(
                    todo.title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      // TODO: Navigate to edit screen
                    } else if (value == 'delete') {
                      context
                          .read<TodoBloc>()
                          .add(DeleteTodoEvent(id: todo.id));
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            if (todo.description.isNotEmpty) ...[
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                todo.description,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: isTablet ? 12 : 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: isTablet ? 16 : 14,
                  color: AppColors.textHint,
                ),
                SizedBox(width: isTablet ? 8 : 4),
                Text(
                  '${todo.startDate} - ${todo.endDate}',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14 : 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
