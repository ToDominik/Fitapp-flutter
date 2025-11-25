import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/exercise.dart';

class ExerciseApiService {
  final Dio _dio;

  ExerciseApiService(ApiClient client) : _dio = client.dio;

  /// Pobiera listę ćwiczeń z paginacją cursorową
  Future<Map<String, dynamic>> fetchExercises({
    int limit = 25,
    String? after,
  }) async {
    final query = <String, dynamic>{
      'limit': limit.toString(),
      if (after != null) 'after': after,
    };

    final response = await _dio.get(
      '/api/v1/exercises',
      queryParameters: query,
    );

    final map = response.data as Map<String, dynamic>;
    final dataList = map['data'] as List<dynamic>? ?? [];

    final items = dataList
        .map((json) => Exercise.fromJson(json as Map<String, dynamic>))
        .toList();

    final meta = map['meta'] as Map<String, dynamic>? ?? {};
    final nextCursor = meta['nextCursor'] as String?;

    return {
      'items': items,
      'nextCursor': nextCursor,
    };
  }

  /// Pobiera szczegóły pojedynczego ćwiczenia
  Future<Exercise> fetchExerciseById(String id) async {
    final response = await _dio.get('/api/v1/exercises/$id');
    return Exercise.fromJson(response.data as Map<String, dynamic>);
  }
}
