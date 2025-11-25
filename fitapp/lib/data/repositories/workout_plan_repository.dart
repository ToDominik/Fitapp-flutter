import 'package:hive/hive.dart';
import '../models/workout_plan.dart';

class WorkoutPlanRepository {
  static const String boxName = 'workout_plans_box';

  final Box<WorkoutPlan> box;

  WorkoutPlanRepository(this.box);

  Future<List<WorkoutPlan>> loadPlans() async {
    return box.values.toList();
  }

  Future<void> savePlan(WorkoutPlan plan) async {
    await box.put(plan.id, plan);
  }

  Future<void> deletePlan(String id) async {
    await box.delete(id);
  }

  Future<void> saveAll(List<WorkoutPlan> plans) async {
    final map = {for (var p in plans) p.id: p};
    await box.putAll(map);
  }
}
