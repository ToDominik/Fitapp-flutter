class ApiConfig {
  // NOWY baseUrl dla exercisedb-api1
  static const String baseUrl = 'https://exercisedb-api1.p.rapidapi.com';

  // NOWY host
  static const String host = 'exercisedb-api1.p.rapidapi.com';

  /// Klucz pobierany z --dart-define.
  /// Przykład uruchomienia:
  /// flutter run --dart-define=RAPIDAPI_KEY=TWÓJ_KLUCZ
  static const String apiKey = String.fromEnvironment(
    'RAPIDAPI_KEY',
    defaultValue: 'fbb1034631msh5ebed1e55c3254ep11808fjsna9b1212b4ff9',
  );

  static Map<String, String> get headers => {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': host,
      };
}
