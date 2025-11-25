import 'package:dio/dio.dart';
import '../datasources/exercise_api_service.dart';
import '../datasources/exercise_local_data_source.dart';
import '../models/exercise.dart';

class ExercisePageResult {
  final List<Exercise> items;
  final String? nextCursor;
  final bool isFromCache;

  ExercisePageResult({
    required this.items,
    required this.nextCursor,
    required this.isFromCache,
  });
}

class ExerciseRepository {
  final ExerciseApiService apiService;
  final ExerciseLocalDataSource localDataSource;

  ExerciseRepository({
    required this.apiService,
    required this.localDataSource,
  });

  /// Pobiera STRONĘ ćwiczeń — backend wspiera paginację cursorową
  /// Zwraca: items + nextCursor
  Future<ExercisePageResult> getExercises({String? after}) async {
    try {
      final result = await apiService.fetchExercises(
        limit: 25,
        after: after,
      );

      final items = result['items'] as List<Exercise>;
      final nextCursor = result['nextCursor'] as String?;

      // cache lokalny 
      await localDataSource.cacheExercises(items);

      return ExercisePageResult(
        items: items,
        nextCursor: nextCursor,
        isFromCache: false,
      );
    } on DioException {
      final cached = await localDataSource.getCachedExercises();
      return ExercisePageResult(
        items: cached,
        nextCursor: null,
        isFromCache: true,
      );
    } catch (_) {
      final cached = await localDataSource.getCachedExercises();
      return ExercisePageResult(
        items: cached,
        nextCursor: null,
        isFromCache: true,
      );
    }
  }

  /// Pobiera szczegóły ćwiczenia
  Future<Exercise> getExerciseById(String id) async {
    try {
      return await apiService.fetchExerciseById(id);
    } on DioException {
      final cached = await localDataSource.getCachedExerciseById(id);
      if (cached != null) return cached;
      rethrow;
    } catch (_) {
      final cached = await localDataSource.getCachedExerciseById(id);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
