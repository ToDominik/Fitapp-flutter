import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/workout_plan.dart';
import '../viewmodels/workout_plan_list_viewmodel.dart';
import '../viewmodels/view_state.dart';
import 'workout_plan_edit_screen.dart';
import 'workout_plan_run_screen.dart';

class WorkoutPlanListScreen extends StatelessWidget {
  const WorkoutPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WorkoutPlanListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plany treningowe"),
      ),
      body: _buildBody(vm, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewPlan(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(WorkoutPlanListViewModel vm, BuildContext context) {
    switch (vm.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return Center(
          child: Text(vm.errorMessage ?? "Błąd ładowania danych."),
        );

      case ViewState.empty:
        return const Center(
          child: Text(
            "Brak planów treningowych.\nKliknij + aby dodać.",
            textAlign: TextAlign.center,
          ),
        );

      case ViewState.success:
      case ViewState.offline:
        return ListView.builder(
          itemCount: vm.plans.length,
          itemBuilder: (context, index) {
            final plan = vm.plans[index];
            return _planTile(context, vm, plan);
          },
        );
    }
  }

  Widget _planTile(
    BuildContext context,
    WorkoutPlanListViewModel vm,
    WorkoutPlan plan,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          plan.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${plan.exercises.length} ćwiczeń"
          "${plan.dayOfWeek != null ? " • ${plan.dayOfWeek}" : ""}",
        ),
        onTap: () => _openPlanEditor(context, plan),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.green),
              tooltip: "Start treningu",
              onPressed: () => _startWorkout(context, plan),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deletePlan(context, vm, plan),
            ),
          ],
        ),
      ),
    );
  }

  void _createNewPlan(BuildContext context) {
    final vm = Provider.of<WorkoutPlanListViewModel>(context, listen: false);
    final newPlan = vm.createNewPlan();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlanEditScreen(plan: newPlan),
      ),
    );
  }

  void _deletePlan(
    BuildContext context,
    WorkoutPlanListViewModel vm,
    WorkoutPlan plan,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Usuń plan"),
        content: Text('Czy na pewno chcesz usunąć plan "${plan.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Anuluj"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text("Usuń"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await vm.deletePlan(plan.id);
    }
  }

  void _openPlanEditor(BuildContext context, WorkoutPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlanEditScreen(plan: plan),
      ),
    );
  }

  void _startWorkout(BuildContext context, WorkoutPlan plan) {
    if (plan.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ten plan nie ma żadnych ćwiczeń."),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlanRunScreen(plan: plan),
      ),
    );
  }
}
