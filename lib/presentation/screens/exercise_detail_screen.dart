import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/exercise.dart';
import '../viewmodels/exercise_detail_viewmodel.dart';
import '../viewmodels/view_state.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseDetailViewModel>(
      builder: (context, vm, _) {
        final exercise = vm.exercise;

        return Scaffold(
          appBar: AppBar(
            title: Text(exercise.name),
          ),
          body: _buildBody(context, vm, exercise),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context, ExerciseDetailViewModel vm, Exercise exercise) {
    switch (vm.state) {
      case ViewState.loading:
        return const LoadingView(message: 'Ładowanie szczegółów...');
      case ViewState.error:
  return ErrorView(
    message: 'Nie udało się wczytać ćwiczenia.',
    onRetry: vm.loadExercise,
  );
      case ViewState.empty:
        return const Center(child: Text('Brak danych.'));
      case ViewState.success:
      case ViewState.offline:
        return _buildDetails(context, exercise);
    }
  }

  Widget _buildDetails(BuildContext context, Exercise exercise) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(exercise),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),

                _infoTile(
                  icon: Icons.fitness_center,
                  title: "Typ ćwiczenia",
                  value: exercise.exerciseType,
                ),
                const SizedBox(height: 12),

                _infoTile(
                  icon: Icons.accessibility_new,
                  title: "Partie ciała",
                  value: exercise.bodyParts.join(", "),
                ),
                const SizedBox(height: 12),

                _infoTile(
                  icon: Icons.sports_gymnastics,
                  title: "Sprzęt",
                  value: exercise.equipments.join(", "),
                ),

                const SizedBox(height: 32),

                Text(
                  "Instrukcje",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...exercise.generatedInstructions.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${entry.key + 1}. ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(Exercise exercise) {
    if (exercise.imageUrl.isEmpty) {
      return Container(
        height: 230,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 64),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        exercise.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 64),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    if (value.isEmpty) value = "Brak danych";

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blueAccent),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
