import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_model.dart';

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List).map((e) => Meal.fromJsonSimple(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<Meal> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJsonDetail(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }
}