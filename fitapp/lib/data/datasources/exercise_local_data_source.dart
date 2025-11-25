import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise.dart';

class ExerciseLocalDataSource {
  static const String exercisesBoxName = 'exercisesBox';
  static const String exercisesKey = 'exercises';

  final Box _box;

  ExerciseLocalDataSource(this._box);

  Future<void> cacheExercises(List<Exercise> exercises) async {
    final list = exercises.map((e) => e.toJson()).toList();
    await _box.put(exercisesKey, list);
  }

  Future<List<Exercise>> getCachedExercises() async {
    final list = _box.get(exercisesKey);
    if (list == null) return [];
    final dynamicList = List<dynamic>.from(list as List);
    return dynamicList
        .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<Exercise?> getCachedExerciseById(String id) async {
    final cached = await getCachedExercises();
    try {
      return cached.firstWhere((exercise) => exercise.id == id);
    } catch (_) {
      return null;
    }
  }
}
