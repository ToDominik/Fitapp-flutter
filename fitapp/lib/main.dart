import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'data/datasources/exercise_api_service.dart';
import 'data/datasources/exercise_local_data_source.dart';

import 'data/models/workout_plan.dart';
import 'data/repositories/exercise_repository.dart';
import 'data/repositories/workout_plan_repository.dart';

import 'presentation/viewmodels/exercise_list_viewmodel.dart';
import 'presentation/viewmodels/workout_plan_list_viewmodel.dart';

// EKRANY
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/exercise_list_screen.dart';
import 'presentation/screens/workout_plan_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // HIVE INIT
  await Hive.initFlutter();

  Hive.registerAdapter(WorkoutExerciseEntryAdapter());
  Hive.registerAdapter(WorkoutPlanAdapter());

  final exerciseBox =
      await Hive.openBox(ExerciseLocalDataSource.exercisesBoxName);

  final workoutPlanBox =
      await Hive.openBox<WorkoutPlan>(WorkoutPlanRepository.boxName);


  // NETWORK

  final apiClient = ApiClient();
  final apiService = ExerciseApiService(apiClient);


  // DATA SOURCE

  final localDataSource = ExerciseLocalDataSource(exerciseBox);


  // REPOSITORIES
 
  final exerciseRepository = ExerciseRepository(
    apiService: apiService,
    localDataSource: localDataSource,
  );

  final workoutPlanRepository = WorkoutPlanRepository(workoutPlanBox);

  runApp(MyApp(
    exerciseRepository: exerciseRepository,
    workoutPlanRepository: workoutPlanRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ExerciseRepository exerciseRepository;
  final WorkoutPlanRepository workoutPlanRepository;

  const MyApp({
    super.key,
    required this.exerciseRepository,
    required this.workoutPlanRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: exerciseRepository),
        Provider.value(value: workoutPlanRepository),

        ChangeNotifierProvider(
          create: (_) =>
              ExerciseListViewModel(repository: exerciseRepository)
                ..loadExercises(),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              WorkoutPlanListViewModel(repository: workoutPlanRepository)
                ..loadPlans(),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const MainHome(),
      ),
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int page = 0;

  // 3 EKRANY
  final pages = const [
    HomeScreen(),
    ExerciseListScreen(),
    WorkoutPlanListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (i) => setState(() => page = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: "Ćwiczenia",
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_calendar),
            label: "Plany",
          ),
        ],
      ),
    );
  }
}
