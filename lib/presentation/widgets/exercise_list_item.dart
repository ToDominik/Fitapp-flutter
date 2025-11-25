import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- OBRAZEK (NOWE API: imageUrl) ---
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: exercise.imageUrl.isNotEmpty
                  ? Image.network(
                      exercise.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.fitness_center),
                    ),
            ),

            const SizedBox(width: 12),

            /// TEKSTY 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///  NAZWA 
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  ///  BODY PARTS 
                  Text(
                    exercise.bodyParts.join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// EQUIPMENT 
                  Text(
                    'Sprzęt: ${exercise.equipments.join(', ')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
