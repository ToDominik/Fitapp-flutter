// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_plan.dart';


// TypeAdapterGenerator


class WorkoutExerciseEntryAdapter extends TypeAdapter<WorkoutExerciseEntry> {
  @override
  final int typeId = 1;

  @override
  WorkoutExerciseEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutExerciseEntry(
      exerciseId: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      bodyParts: (fields[3] as List).cast<String>(),
      equipments: (fields[4] as List).cast<String>(),
      sets: fields[5] as int,
      reps: fields[6] as int,
      restSeconds: fields[7] as int,
      notes: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutExerciseEntry obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.bodyParts)
      ..writeByte(4)
      ..write(obj.equipments)
      ..writeByte(5)
      ..write(obj.sets)
      ..writeByte(6)
      ..write(obj.reps)
      ..writeByte(7)
      ..write(obj.restSeconds)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExerciseEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 2;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      dayOfWeek: fields[2] as String?,
      notes: fields[3] as String,
      createdAt: fields[4] as DateTime,
      exercises: (fields[5] as List).cast<WorkoutExerciseEntry>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dayOfWeek)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.exercises);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
