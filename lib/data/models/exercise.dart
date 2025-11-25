class Exercise {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> bodyParts;
  final List<String> equipments;
  final String exerciseType;
  final List<String> targetMuscles;
  final List<String> secondaryMuscles;
  final List<String> keywords;

  Exercise({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bodyParts,
    required this.equipments,
    required this.exerciseType,
    required this.targetMuscles,
    required this.secondaryMuscles,
    required this.keywords,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // ----------- Format LISTY (flat) -----------
    if (json.containsKey("bodyParts") && json["bodyParts"] is List) {
      return Exercise(
        id: json['exerciseId'] ?? '',
        name: json['name'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        bodyParts: List<String>.from(json['bodyParts'] ?? []),
        equipments: List<String>.from(json['equipments'] ?? []),
        exerciseType: json['exerciseType'] ?? '',
        targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
        secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
        keywords: List<String>.from(json['keywords'] ?? []),
      );
    }

    // ----------- Format SZCZEGÓŁÓW (nested) -----------
    final meta = json["metadata"] ?? {};
    final image = json["image"] ?? {};

    return Exercise(
      id: json['exerciseId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: image["imageUrl"] ?? '',
      bodyParts: List<String>.from(meta['bodyParts'] ?? []),
      equipments: List<String>.from(meta['equipments'] ?? []),
      exerciseType: meta['exerciseType'] ?? '',
      targetMuscles: List<String>.from(meta['targetMuscles'] ?? []),
      secondaryMuscles: List<String>.from(meta['secondaryMuscles'] ?? []),
      keywords: List<String>.from(meta['keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': id,
      'name': name,
      'imageUrl': imageUrl,
      'bodyParts': bodyParts,
      'equipments': equipments,
      'exerciseType': exerciseType,
      'targetMuscles': targetMuscles,
      'secondaryMuscles': secondaryMuscles,
      'keywords': keywords,
    };
  }
}


// AUTO-GENEROWANE INSTRUKCJE

extension ExerciseInstructions on Exercise {
  List<String> get generatedInstructions {
    final muscle =
        (targetMuscles.isNotEmpty ? targetMuscles.first : "ciała").toLowerCase();

    return [
      "Przyjmij pozycję startową odpowiednią dla tego ćwiczenia.",
      "Zaangażuj mięśnie $muscle i utrzymuj stabilną sylwetkę.",
      "Wykonuj ruch płynnie w pełnym zakresie.",
      "Oddychaj miarowo i nie spinaj szyi ani barków.",
      "Wróć do pozycji startowej i powtórz.",
    ];
  }
}
