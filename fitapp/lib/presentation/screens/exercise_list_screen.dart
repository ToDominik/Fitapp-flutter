import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/exercise_list_viewmodel.dart';
import '../viewmodels/view_state.dart';
import '../viewmodels/exercise_detail_viewmodel.dart';
import '../widgets/exercise_list_item.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseListViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Ćwiczenia"),
          ),
          body: _buildBody(vm),
        );
      },
    );
  }

  Widget _buildBody(ExerciseListViewModel vm) {
    switch (vm.state) {
      case ViewState.loading:
        return const LoadingView(message: "Ładowanie ćwiczeń...");

      case ViewState.error:
        return ErrorView(
          message: vm.errorMessage ?? "Błąd pobierania",
          onRetry: vm.loadExercises,
        );

      case ViewState.empty:
        return const Center(child: Text("Brak ćwiczeń"));

      case ViewState.success:
      case ViewState.offline:
        return Column(
          children: [
            _buildSearch(vm),
            _buildFilter(vm),

            if (vm.isOffline)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Tryb offline • dane z pamięci",
                  style: TextStyle(color: Colors.orange),
                ),
              ),

            Expanded(child: _buildList(vm)),
          ],
        );
    }
  }

  Widget _buildSearch(ExerciseListViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: vm.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Szukaj ćwiczenia...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilter(ExerciseListViewModel vm) {
    final parts = vm.bodyParts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        initialValue: vm.selectedBodyPart,
        decoration: const InputDecoration(
          labelText: "Część ciała",
          border: OutlineInputBorder(),
        ),
        items: [
          const DropdownMenuItem(value: null, child: Text("Wszystkie")),
          ...parts.map((p) => DropdownMenuItem(value: p, child: Text(p))),
        ],
        onChanged: vm.selectBodyPart,
      ),
    );
  }

  Widget _buildList(ExerciseListViewModel vm) {
    final items = vm.filteredExercises;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final ex = items[i];

        return ExerciseListItem(
          exercise: ex,
          onTap: () {
            Navigator.push(
              _,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => ExerciseDetailViewModel(exercise: ex),
                  child: const ExerciseDetailScreen(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
