import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/workout_plan_list_viewmodel.dart';
import '../viewmodels/exercise_list_viewmodel.dart';

import '../../data/models/workout_plan.dart';
import 'workout_plan_edit_screen.dart';
import 'workout_plan_run_screen.dart'; // będzie za chwilę
import 'exercise_list_screen.dart';
import 'workout_plan_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plansVm = Provider.of<WorkoutPlanListViewModel>(context);
    final exerciseVm = Provider.of<ExerciseListViewModel>(context);

    final today = _today();
    final todayPlan = plansVm.plans.firstWhere(
      (p) => p.dayOfWeek == today,
      orElse: () => WorkoutPlan.empty(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitaplikacja"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await exerciseVm.loadExercises();
          await plansVm.loadPlans();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTodayPlanCard(context, todayPlan),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildRecentExercises(context, exerciseVm),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // TODAY'S PLAN CARD
  // -----------------------------------------------------------
  Widget _buildTodayPlanCard(BuildContext context, WorkoutPlan? plan) {
    if (plan == null || plan.exercises.isEmpty) {
      return _emptyTodayPlanCard(context);
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dzisiejszy plan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              plan.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text("${plan.exercises.length} ćwiczeń"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutPlanRunScreen(plan: plan),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Start"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyTodayPlanCard(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Brak planu na dziś",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Dodaj plan i przypisz go do dnia tygodnia."),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkoutPlanListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today),
              label: const Text("Przejdź do planów"),
            )
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // QUICK ACTION BUTTONS
  // -----------------------------------------------------------
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickButton(
          context,
          icon: Icons.add,
          label: "Nowy plan",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutPlanEditScreen(plan: WorkoutPlan.empty()),
              ),
            );
          },
        ),
        _quickButton(
          context,
          icon: Icons.fitness_center,
          label: "Ćwiczenia",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ExerciseListScreen(),
              ),
            );
          },
        ),
        _quickButton(
          context,
          icon: Icons.list_alt,
          label: "Wszystkie plany",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WorkoutPlanListScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _quickButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, size: 28, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // RECENT EXERCISES
  // -----------------------------------------------------------
  Widget _buildRecentExercises(
      BuildContext context, ExerciseListViewModel vm) {
    final recent = vm.filteredExercises.take(3).toList();

    if (recent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ostatnie ćwiczenia",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...recent.map(
          (e) => ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  e.imageUrl.isNotEmpty ? NetworkImage(e.imageUrl) : null,
              child: e.imageUrl.isEmpty
                  ? const Icon(Icons.fitness_center)
                  : null,
            ),
            title: Text(e.name),
            subtitle: Text(e.bodyParts.join(', ')),
            onTap: () {}, // możesz otworzyć szczegóły
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // TODAY STRING
  // -----------------------------------------------------------
  static String _today() {
    const days = [
      "Poniedziałek",
      "Wtorek",
      "Środa",
      "Czwartek",
      "Piątek",
      "Sobota",
      "Niedziela",
    ];
    return days[DateTime.now().weekday - 1];
  }
}
