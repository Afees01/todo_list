import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/data/repositories/todo_repository_impl.dart';
import 'package:todo_list/data/services/supabase_service.dart';
import 'package:todo_list/presentation/bloc/todo_bloc.dart';
import 'package:todo_list/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:todo_list/presentation/screens/home/home_screen.dart';
import 'package:todo_list/presentation/screens/add_project/add_project_screen.dart';
import 'package:todo_list/presentation/screens/project_details/project_details_screen.dart';
import 'package:todo_list/presentation/utils/app_colors.dart';

const supabaseUrl = 'https://jgftasqqrdwrtqkswuor.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpnZnRhc3FxcmR3cnRxa3N3dW9yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjcyODgsImV4cCI6MjA3NzE0MzI4OH0.duggOftdhm8nG3SAFaxrII7_Jg0qKEjDsVZxOnTAXgg';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(
        todoRepository: TodoRepositoryImpl(
          supabaseService: SupabaseService(),
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Management & To-Do List',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const OnboardingScreen(),
          '/home': (context) => const HomeScreen(),
          '/add-project': (context) => const AddProjectScreen(),
          '/project-details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return ProjectDetailsScreen(todoId: args['todoId']);
          },
        },
      ),
    );
  }
}
