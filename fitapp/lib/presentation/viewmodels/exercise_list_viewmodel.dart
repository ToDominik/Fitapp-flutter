import 'package:flutter/foundation.dart';
import '../../data/models/exercise.dart';
import '../../data/repositories/exercise_repository.dart';
import 'view_state.dart';

class ExerciseListViewModel extends ChangeNotifier {
  final ExerciseRepository repository;

  ViewState state = ViewState.loading;
  String? errorMessage;
  bool isOffline = false;

  final List<Exercise> _allExercises = [];
  List<Exercise> filteredExercises = [];

  String _searchQuery = '';
  String? _selectedBodyPart;

  ExerciseListViewModel({required this.repository});

  
  Future<void> loadExercises() async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      _allExercises.clear();

      String? cursor;
      int downloaded = 0;
      const int maxLimit = 350; // limit pobierania

      do {
        final page = await repository.getExercises(after: cursor);
        cursor = page.nextCursor;

        _allExercises.addAll(page.items);
        downloaded += page.items.length;

        isOffline = page.isFromCache;

        if (page.isFromCache) break;
        if (downloaded >= maxLimit) break;

      } while (cursor != null);

      if (_allExercises.isEmpty) {
        state = ViewState.empty;
      } else {
        state = isOffline ? ViewState.offline : ViewState.success;
      }

      _applyFilters();
    } catch (e) {
      errorMessage = "Błąd podczas pobierania danych.";
      state = ViewState.error;
    }

    notifyListeners();
  }

  // SEARCH
 
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

 
  // FILTER BODY PART

  void selectBodyPart(String? bodyPart) {
    _selectedBodyPart = bodyPart;
    _applyFilters();
    notifyListeners();
  }


  // AVAILABLE BODY PARTS
  List<String> get bodyParts {
    final set = <String>{};

    for (final e in _allExercises) {
      for (final part in e.bodyParts) {
        set.add(part.trim());
      }
    }

    final list = set.toList()..sort();
    return list;
  }

  // GETTERS
  
  List<Exercise> get allExercises => _allExercises;
  String? get selectedBodyPart => _selectedBodyPart;
  String get searchQuery => _searchQuery;

  // FILTERING LOGIC

  void _applyFilters() {
    Iterable<Exercise> list = _allExercises;

    // search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((e) {
        return e.name.toLowerCase().contains(q) ||
            e.bodyParts.any((bp) => bp.toLowerCase().contains(q));
      });
    }

    // body part filter
    if (_selectedBodyPart != null && _selectedBodyPart!.isNotEmpty) {
      final part = _selectedBodyPart!.toLowerCase();
      list = list.where(
        (e) => e.bodyParts.map((bp) => bp.toLowerCase()).contains(part),
      );
    }

    filteredExercises = list.toList();
  }
}
