import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/exercise.dart';
import '../viewmodels/exercise_list_viewmodel.dart';
import '../widgets/exercise_list_item.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  final Function(Exercise) onSelected;

  const ExerciseSelectionScreen({
    super.key,
    required this.onSelected,
  });

  @override
  State<ExerciseSelectionScreen> createState() =>
      _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseListViewModel>(builder: (context, vm, _) {
      final base = vm.allExercises;

      final list = query.isEmpty
          ? base
          : base
              .where((e) =>
                  e.name.toLowerCase().contains(query.toLowerCase()) ||
                  e.bodyParts.any((bp) =>
                      bp.toLowerCase().contains(query.toLowerCase())))
              .toList();

      return Scaffold(
        appBar: AppBar(title: const Text("Wybierz ćwiczenie")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Szukaj...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final ex = list[i];
                  return ExerciseListItem(
                    exercise: ex,
                    onTap: () {
                      widget.onSelected(ex);
                      Navigator.pop(context, ex);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
