import 'package:drp_dwn_check/database/category_db.dart';
import 'package:drp_dwn_check/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  CategoryProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _categories = await CategoryDatabase().getCategories();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await CategoryDatabase().insertCategory(category);
    await loadCategories();
  }

  Future<void> removeCategory(int id) async {
    await CategoryDatabase().deleteCategory(id);
    await loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await CategoryDatabase().updateCategory(category);
    await loadCategories();
  }
}
