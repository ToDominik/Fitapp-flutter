
import 'package:hive/hive.dart';
import 'exercise.dart';

part 'workout_plan.g.dart';

@HiveType(typeId: 1)
class WorkoutExerciseEntry {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final List<String> bodyParts;

  @HiveField(4)
  final List<String> equipments;

  @HiveField(5)
  int sets;

  @HiveField(6)
  int reps;

  @HiveField(7)
  int restSeconds;

  @HiveField(8)
  String notes;

  WorkoutExerciseEntry({
    required this.exerciseId,
    required this.name,
    required this.imageUrl,
    required this.bodyParts,
    required this.equipments,
    this.sets = 3,
    this.reps = 10,
    this.restSeconds = 60,
    this.notes = '',
  });

  factory WorkoutExerciseEntry.fromExercise(Exercise e) {
    return WorkoutExerciseEntry(
      exerciseId: e.id,
      name: e.name,
      imageUrl: e.imageUrl,
      bodyParts: e.bodyParts,
      equipments: e.equipments,
    );
  }

  factory WorkoutExerciseEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseEntry(
      exerciseId: json['exerciseId'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      bodyParts: List<String>.from(json['bodyParts'] ?? []),
      equipments: List<String>.from(json['equipments'] ?? []),
      sets: json['sets'] ?? 3,
      reps: json['reps'] ?? 10,
      restSeconds: json['restSeconds'] ?? 60,
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'name': name,
        'imageUrl': imageUrl,
        'bodyParts': bodyParts,
        'equipments': equipments,
        'sets': sets,
        'reps': reps,
        'restSeconds': restSeconds,
        'notes': notes,
      };
}

@HiveType(typeId: 2)
class WorkoutPlan {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? dayOfWeek;

  @HiveField(3)
  String notes;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  List<WorkoutExerciseEntry> exercises;

  WorkoutPlan({
    required this.id,
    required this.name,
    this.dayOfWeek,
    this.notes = '',
    required this.createdAt,
    required this.exercises,
  });

  factory WorkoutPlan.empty() => WorkoutPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Nowy plan',
        createdAt: DateTime.now(),
        exercises: [],
      );

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      name: json['name'],
      dayOfWeek: json['dayOfWeek'],
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      exercises: (json['exercises'] as List<dynamic>? ?? [])
          .map((e) => WorkoutExerciseEntry.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dayOfWeek': dayOfWeek,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };
}
