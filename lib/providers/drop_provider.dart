import 'package:drp_dwn_check/model/category_model.dart';
import 'package:drp_dwn_check/utils/color_constant.dart';
import 'package:flutter/material.dart';

class DropdownProvider extends ChangeNotifier {
  List<String> categories = ["income", "expense"];

  String _dropdownValue2 = "income";

  List<String> colorNames = ["Green", "Blue", "Red", "yellow"];
  List<Color> colors = [
    ColorConstant.defGreen,
    ColorConstant.defIndigo,
    Color.fromARGB(255, 230, 57, 45),
    Colors.yellow
  ];

  String _colorNameController = "Green";

  String get dropdownValue2 => _dropdownValue2;
  String get colorNameController => _colorNameController;

  void setDropdownValue2(String newValue) {
    _dropdownValue2 = newValue;
    notifyListeners();
  }

  void setColorNameController(String newValue) {
    _colorNameController = newValue;
    notifyListeners();
  }

  void updateCategoryWithColor(Category category) {
    // Ensure category.colorName exists in colorNames list
    if (colorNames.contains(category.colorName)) {
      // Get the index of category.colorName in colorNames list
      int index = colorNames.indexOf(category.colorName);

      // Update category with corresponding color from colors list
      category.title = category.title;
      category.description = category.description;
      category.colorName = colorNames[index]; // Assign the corresponding color
    } else {
      // Handle case where category.colorName is not found in colorNames list
      print(
          "Category color name not found in colorNames list: ${category.colorName}");
    }
  }
}
