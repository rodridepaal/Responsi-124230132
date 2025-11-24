import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class MealsScreen extends StatelessWidget {
  final String categoryName;

  const MealsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$categoryName Meals")),
      body: FutureBuilder<List<Meal>>(
        future: ApiService().getMealsByCategory(categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final meal = snapshot.data![index];
                return InkWell(
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(mealId: meal.id),
                        ),
                      );
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            meal.name, 
                            textAlign: TextAlign.center, 
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No meals found"));
        },
      ),
    );
  }
}