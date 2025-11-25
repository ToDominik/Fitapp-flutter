class ApiConfig {
  // NOWY baseUrl dla exercisedb-api1
  static const String baseUrl = 'https://exercisedb-api1.p.rapidapi.com';

 
  static const String host = 'exercisedb-api1.p.rapidapi.com';

 
  static const String apiKey = String.fromEnvironment(
    'RAPIDAPI_KEY',
    defaultValue: 'Api Key here',
  );

  static Map<String, String> get headers => {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': host,
      };
}
