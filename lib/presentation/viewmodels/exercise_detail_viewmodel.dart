import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import 'view_state.dart';


// Korzysta z danych, które przekazaliśmy z listy,

class ExerciseDetailViewModel extends ChangeNotifier {
  final Exercise exercise;

  ExerciseDetailViewModel({
    required this.exercise,
  });

  ViewState state = ViewState.success;

  Future<void> loadExercise() async {
    
    state = ViewState.success;
    notifyListeners();
  }
}
