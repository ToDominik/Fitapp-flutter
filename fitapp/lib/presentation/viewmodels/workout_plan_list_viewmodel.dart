import 'package:flutter/material.dart';

import '../../data/models/workout_plan.dart';
import '../../data/models/exercise.dart';
import '../../data/repositories/workout_plan_repository.dart';
import 'view_state.dart';

class WorkoutPlanListViewModel extends ChangeNotifier {
  final WorkoutPlanRepository repository;

  WorkoutPlanListViewModel({required this.repository});

  ViewState state = ViewState.loading;
  String? errorMessage;
  List<WorkoutPlan> plans = [];

 
  // LOAD
 
  Future<void> loadPlans() async {
    state = ViewState.loading;
    notifyListeners();

    try {
      plans = await repository.loadPlans();
      state = plans.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      errorMessage = 'Nie udało się wczytać planów.';
      state = ViewState.error;
    }

    notifyListeners();
  }

  
  // INTERNAL SAVE
 
  Future<void> _persist() async {
    await repository.saveAll(plans); 
  }

 
  // CRUD
  Future<void> addPlan(WorkoutPlan plan) async {
    plans.add(plan);
    state = ViewState.success;
    notifyListeners();
    await _persist();
  }

  Future<void> updatePlan(WorkoutPlan plan) async {
    final index = plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      plans[index] = plan;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deletePlan(String id) async {
    plans.removeWhere((p) => p.id == id);
    state = plans.isEmpty ? ViewState.empty : ViewState.success;
    notifyListeners();
    await _persist();
  }


  // HELPERS
  WorkoutPlan duplicatePlan(WorkoutPlan plan) {
    return WorkoutPlan.fromJson(plan.toJson());
  }

  WorkoutPlan createNewPlan() => WorkoutPlan.empty();

  WorkoutPlan addExerciseToPlan(WorkoutPlan plan, Exercise exercise) {
    plan.exercises.add(WorkoutExerciseEntry.fromExercise(exercise));
    return plan;
  }
}
