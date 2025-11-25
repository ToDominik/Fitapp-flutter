import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/workout_plan.dart';
import '../viewmodels/workout_plan_list_viewmodel.dart';
import 'exercise_selection_screen.dart';
import 'workout_plan_run_screen.dart';

class WorkoutPlanEditScreen extends StatefulWidget {
  final WorkoutPlan plan;

  const WorkoutPlanEditScreen({
    super.key,
    required this.plan,
  });

  @override
  State<WorkoutPlanEditScreen> createState() => _WorkoutPlanEditScreenState();
}

class _WorkoutPlanEditScreenState extends State<WorkoutPlanEditScreen> {
  late WorkoutPlan _plan;
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  String? _dayOfWeek;

  @override
  void initState() {
    super.initState();
    _plan = WorkoutPlan.fromJson(widget.plan.toJson());
    _nameController.text = _plan.name;
    _notesController.text = _plan.notes;
    _dayOfWeek = _plan.dayOfWeek;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePlan(BuildContext context) async {
    final vm = Provider.of<WorkoutPlanListViewModel>(context, listen: false);

    _plan
      ..name = _nameController.text.trim().isEmpty
          ? "Plan bez nazwy"
          : _nameController.text.trim()
      ..notes = _notesController.text.trim()
      ..dayOfWeek = _dayOfWeek;

    final exists = vm.plans.any((p) => p.id == _plan.id);

    if (exists) {
      await vm.updatePlan(_plan);
    } else {
      await vm.addPlan(_plan);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickExercise() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseSelectionScreen(
          onSelected: (exercise) {
            setState(() {
              _plan.exercises.add(WorkoutExerciseEntry.fromExercise(exercise));
            });
          },
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context) {
    if (_plan.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Dodaj przynajmniej jedno ćwiczenie do planu."),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutPlanRunScreen(plan: _plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const days = [
      "Poniedziałek",
      "Wtorek",
      "Środa",
      "Czwartek",
      "Piątek",
      "Sobota",
      "Niedziela",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edytuj plan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: "Uruchom trening",
            onPressed: () => _startWorkout(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _savePlan(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nazwa planu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _dayOfWeek,
              decoration: const InputDecoration(
                labelText: "Dzień tygodnia (opcjonalnie)",
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text("Brak")),
                ...days.map(
                  (d) => DropdownMenuItem(
                    value: d,
                    child: Text(d),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _dayOfWeek = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Notatki (opcjonalnie)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Ćwiczenia",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _pickExercise,
                  icon: const Icon(Icons.add),
                  label: const Text("Dodaj ćwiczenie"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _plan.exercises.isEmpty
                  ? const Center(
                      child: Text('Brak ćwiczeń w planie.'),
                    )
                  : ListView.separated(
                      itemCount: _plan.exercises.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final e = _plan.exercises[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: e.imageUrl.isNotEmpty
                                ? NetworkImage(e.imageUrl)
                                : null,
                            child: e.imageUrl.isEmpty
                                ? const Icon(Icons.fitness_center)
                                : null,
                          ),
                          title: Text(e.name),
                          subtitle: Text(
                              '${e.sets}x${e.reps} • Odpoczynek: ${e.restSeconds}s'),
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (_) => _EditExerciseDialog(entry: e),
                            );
                            setState(() {});
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() {
                                _plan.exercises.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditExerciseDialog extends StatefulWidget {
  final WorkoutExerciseEntry entry;

  const _EditExerciseDialog({required this.entry});

  @override
  State<_EditExerciseDialog> createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<_EditExerciseDialog> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _restController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _setsController =
        TextEditingController(text: widget.entry.sets.toString());
    _repsController =
        TextEditingController(text: widget.entry.reps.toString());
    _restController =
        TextEditingController(text: widget.entry.restSeconds.toString());
    _notesController = TextEditingController(text: widget.entry.notes);
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry.name),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _setsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Serie'),
            ),
            TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Powtórzenia'),
            ),
            TextField(
              controller: _restController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Odpoczynek (sekundy)',
              ),
            ),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notatki (opcjonalnie)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.entry.sets =
                int.tryParse(_setsController.text) ?? widget.entry.sets;
            widget.entry.reps =
                int.tryParse(_repsController.text) ?? widget.entry.reps;
            widget.entry.restSeconds =
                int.tryParse(_restController.text) ??
                    widget.entry.restSeconds;
            widget.entry.notes = _notesController.text.trim();
            Navigator.pop(context);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
