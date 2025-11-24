import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

class DetailScreen extends StatelessWidget {
  final String mealId;

  const DetailScreen({super.key, required this.mealId});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Detail")),
      body: FutureBuilder<Meal>(
        future: ApiService().getMealDetail(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(meal.thumbnail, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    meal.name, 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  Text(
                    "${meal.category} | ${meal.area}", 
                    style: TextStyle(color: Colors.grey[700], fontSize: 16)
                  ),
                  const Divider(height: 30),
                  const Text(
                    "Ingredients", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  ...meal.ingredients.map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $i"),
                  )),
                  const Divider(height: 30),
                  const Text(
                    "Instructions", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  Text(meal.instructions, textAlign: TextAlign.justify),
                  const SizedBox(height: 24),
                  if (meal.youtubeUrl.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(meal.youtubeUrl),
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text("Watch Tutorial"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, 
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return const Center(child: Text("Error loading detail"));
        },
      ),
    );
  }
}