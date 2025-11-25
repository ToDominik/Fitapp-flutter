import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/workout_plan.dart';

class WorkoutPlanRunScreen extends StatefulWidget {
  final WorkoutPlan plan;

  const WorkoutPlanRunScreen({
    super.key,
    required this.plan,
  });

  @override
  State<WorkoutPlanRunScreen> createState() => _WorkoutPlanRunScreenState();
}

class _WorkoutPlanRunScreenState extends State<WorkoutPlanRunScreen> {
  late final List<WorkoutExerciseEntry> _exercises;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;

  bool _isResting = false;
  int _restRemaining = 0;
  Timer? _restTimer;

  WorkoutExerciseEntry get _currentEntry => _exercises[_currentExerciseIndex];

  @override
  void initState() {
    super.initState();
    // robimy kopię, żeby nie modyfikować oryginału
    _exercises = widget.plan.exercises
        .map((e) => WorkoutExerciseEntry.fromJson(e.toJson()))
        .toList();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _startRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = true;
      _restRemaining = _currentEntry.restSeconds;
    });

    if (_restRemaining <= 0) {
      // brak odpoczynku – od razu następna seria
      _goToNextSetOrExercise();
      return;
    }

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restRemaining <= 1) {
        timer.cancel();
        setState(() {
          _isResting = false;
          _restRemaining = 0;
        });
        _goToNextSetOrExercise(incrementSet: true);
      } else {
        setState(() {
          _restRemaining--;
        });
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
      _restRemaining = 0;
    });
    _goToNextSetOrExercise(incrementSet: true);
  }

  void _finishSet() {
    if (_currentEntry.restSeconds > 0) {
      _startRest();
    } else {
      _goToNextSetOrExercise(incrementSet: true);
    }
  }

  void _goToNextSetOrExercise({bool incrementSet = false}) {
    setState(() {
      if (incrementSet) {
        _currentSet++;
      }

      if (_currentSet > _currentEntry.sets) {
        // kolejny exercise
        if (_currentExerciseIndex < _exercises.length - 1) {
          _currentExerciseIndex++;
          _currentSet = 1;
        } else {
          // koniec treningu
          _showFinishDialog();
        }
      }
    });
  }

  void _skipExercise() {
    setState(() {
      if (_currentExerciseIndex < _exercises.length - 1) {
        _currentExerciseIndex++;
        _currentSet = 1;
        _isResting = false;
        _restTimer?.cancel();
        _restRemaining = 0;
      } else {
        _showFinishDialog();
      }
    });
  }

  void _showFinishDialog() async {
    _restTimer?.cancel();
    final ctx = context;

    await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Trening ukończony!"),
        content: const Text(
          "Gratulacje! Zakończyłeś cały plan treningowy.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    if (mounted) {
      Navigator.pop(ctx);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.plan.name),
        ),
        body: const Center(
          child: Text("Ten plan nie ma żadnych ćwiczeń."),
        ),
      );
    }

    final entry = _currentEntry;
    final totalExercises = _exercises.length;
    final exerciseNumber = _currentExerciseIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Trening: ${widget.plan.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Góra – info o postępie
            Row(
              children: [
                Chip(
                  label: Text("Ćwiczenie $exerciseNumber / $totalExercises"),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text("Seria $_currentSet / ${entry.sets}"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nazwa ćwiczenia + obrazek
            if (entry.imageUrl.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  entry.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 64),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.fitness_center, size: 64),
                ),
              ),
            const SizedBox(height: 16),

            Text(
              entry.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Wykonaj ${entry.reps} powtórzeń",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            // Sekcja odpoczynku
            if (_isResting)
              Column(
                children: [
                  const Text(
                    "Odpoczynek",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$_restRemaining s",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _skipRest,
                    child: const Text("Pomiń odpoczynek"),
                  ),
                ],
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _finishSet,
                    icon: const Icon(Icons.check),
                    label: Text(
                      "Zakończ serię $_currentSet / ${entry.sets}",
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (entry.restSeconds > 0)
                    OutlinedButton.icon(
                      onPressed: _startRest,
                      icon: const Icon(Icons.timer),
                      label: Text("Start odpoczynku (${entry.restSeconds}s)"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                      ),
                    ),
                ],
              ),

            const Spacer(),

            // Dół – akcje
            Row(
              children: [
                TextButton(
                  onPressed: _skipExercise,
                  child: const Text("Pomiń ćwiczenie"),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _showExitConfirm,
                  child: const Text(
                    "Zakończ trening",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirm() async {
    final ctx = context;
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Przerwać trening?"),
        content: const Text(
            "Czy na pewno chcesz zakończyć ten trening przed ukończeniem planu?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Anuluj"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Zakończ"),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      Navigator.pop(ctx);
    }
  }
}
