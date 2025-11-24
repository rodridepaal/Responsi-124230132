class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String category;
  final String area;
  final String instructions;
  final String youtubeUrl;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.youtubeUrl = '',
    this.ingredients = const [],
  });

  factory Meal.fromJsonSimple(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }

  factory Meal.fromJsonDetail(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredientsList.add('$measure $ingredient');
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredientsList,
    );
  }
}