import 'package:drp_dwn_check/model/category_model.dart';
import 'package:drp_dwn_check/providers/category_provider.dart';
import 'package:drp_dwn_check/providers/drop_provider.dart';
import 'package:drp_dwn_check/utils/color_constant.dart';
import 'package:drp_dwn_check/view/category_widget.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final titleController = TextEditingController();
  final desController = TextEditingController();
  List<Map<String, String>> mylist = [];
  List<String> categories = [
    "income",
    "expense",
  ];
  String dropdownValue = "income";

  final List<Color> colors = [
    ColorConstant.defGreen,
    ColorConstant.defIndigo,
    Color.fromARGB(255, 230, 57, 45),
    Colors.yellow
  ];
  final List<String> colorNames = [
    "Green",
    "Blue",
    "Red",
    "yellow",
  ];

  String selectedColorName = "Green";
  int selectedColorId = 1;
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    double fontSize = 12;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.bgBlue,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width < 600 ? 60 : 80,
          backgroundColor: ColorConstant.defIndigo,
          title: MediaQuery.of(context).size.width < 600
              ? Text(
                  "categoryscreen",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                )
              : Text(
                  "categoryscreen",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: MediaQuery.of(context).size.width < 600
                  ? Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String localDropdownValue = categories[0];
                      String localSelectedColorName = colorNames[0];
                      titleController.clear();
                      desController.clear();

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 500,
                                width: 440,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(
                                          "categoryTitle",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextField(
                                            controller: titleController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              border: InputBorder.none,
                                              hintText: "categoryNameHint",
                                              hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 130,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextField(
                                            controller: desController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              border: InputBorder.none,
                                              hintText:
                                                  "categoryDescriptionHint",
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 282,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                              underline: Container(),
                                              value: dropdownValue,
                                              items: categories.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 13),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                print(
                                                    "New dropdown value selected: $value");
                                                setState(() {
                                                  dropdownValue = value!;
                                                }); ///////////////
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 282,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "dropdownLabel",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 166.5,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: DropdownButton<String>(
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.black,
                                                  ),
                                                  underline: Container(),
                                                  value: selectedColorName,
                                                  items: colorNames.map<
                                                      DropdownMenuItem<String>>(
                                                    (String colorName) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: colorName,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            width: 120,
                                                            height: 24,
                                                            color: colors[
                                                                colorNames.indexOf(
                                                                    colorName)],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(
                                                      () {
                                                        selectedColorName =
                                                            newValue!;
                                                      },
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (titleController
                                                    .text.isNotEmpty &&
                                                desController.text.isNotEmpty) {
                                              final categoryProvider =
                                                  Provider.of<CategoryProvider>(
                                                      context,
                                                      listen: false);
                                              categoryProvider.addCategory(
                                                Category(
                                                  title: titleController.text,
                                                  description:
                                                      desController.text,
                                                  colorName: selectedColorName,
                                                ),
                                              );

                                              Navigator.pop(context);
                                              titleController.clear();
                                              desController.clear();
                                              // selectedColorName = "Green"; ////////////////
                                            } else {
                                              print(
                                                  "Please fill out all fields");
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: ColorConstant.defIndigo,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "submitButton",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      );
                    },
                  );
                },
                child: MediaQuery.of(context).size.width < 600
                    ? Text(
                        "New",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    : Text(
                        "New",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 18,
            right: 15,
          ),
          child: Consumer<CategoryProvider>(
            builder: (context, categoryprovider, child) {
              return ListView.builder(
                itemCount: categoryprovider.categories.length,
                itemBuilder: (context, index) {
                  final category = categoryprovider.categories[index];
                  return CategoryWidget(
                    title: category.title,
                    description: category.description,
                    color: colors[colorNames.indexOf(category.colorName)],
                    onEditTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String localDropdownValue = categories[0];
                          String localSelectedColorName = colorNames[0];

                          final titleController2 =
                              TextEditingController(text: category.title);
                          final descriptionController2 =
                              TextEditingController(text: category.description);
                          String colorNameController = category.colorName;

                          return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 500,
                                width: 440,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(
                                          "categoryTitle",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextField(
                                            controller: titleController2,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              border: InputBorder.none,
                                              hintText: "categoryNameHint",
                                              hintStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 130,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: TextField(
                                            controller: descriptionController2,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              border: InputBorder.none,
                                              hintText: "DescriptionHint",
                                              hintStyle: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 282,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Consumer<DropdownProvider>(
                                              builder:
                                                  (context, provider, child) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                ),
                                                underline: Container(),
                                                value: provider.dropdownValue2,
                                                items: provider.categories.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 13),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  print(
                                                      "New dropdown value selected: $value");
                                                  provider.setDropdownValue2(
                                                      value!);

                                                  ///added provider for income/expense drpdwn
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 282,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              Text(
                                                "dropdownLabel",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 166.5,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child:
                                                    Consumer<DropdownProvider>(
                                                        builder: (context,
                                                            provider, child) {
                                                  return DropdownButton<String>(
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.black,
                                                    ),
                                                    underline: Container(),
                                                    value: provider
                                                        .colorNameController,
                                                    items: provider.colorNames
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                      (String colorName) {
                                                        int index = provider
                                                            .colorNames
                                                            .indexOf(colorName);
                                                        Color color = index !=
                                                                -1
                                                            ? provider
                                                                .colors[index]
                                                            : Colors
                                                                .transparent; // Default color if not found
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: colorName,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                                width: 120,
                                                                height: 24,
                                                                color: color),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged: /////////////////
                                                        (String? newValue) {
                                                      provider
                                                          .setColorNameController(
                                                        newValue!,
                                                      );
                                                    },
                                                  );
                                                }),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            final updatedTitle =
                                                titleController2.text;
                                            final updatedDescription =
                                                descriptionController2.text;
                                            final updatedColorName =
                                                Provider.of<DropdownProvider>(
                                                        context,
                                                        listen: false)
                                                    .colorNameController;
                                            if (updatedTitle.isNotEmpty &&
                                                updatedDescription.isNotEmpty &&
                                                updatedColorName.isNotEmpty &&
                                                updatedColorName.isNotEmpty) {
                                              categoryProvider
                                                  .updateCategory(Category(
                                                id: category.id,
                                                title: updatedTitle,
                                                description: updatedDescription,
                                                colorName: updatedColorName,
                                              ));

                                              Navigator.of(context).pop();
                                            } else {
                                              print(
                                                  "Please fill out all fields");
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: ColorConstant.defIndigo,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "submit",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      );
                    },
                    onDeleteTap: () {
                      MediaQuery.of(context).size.width < 600
                          ? categoryProvider.removeCategory(category.id!)
                          : categoryProvider.removeCategory(category.id!);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
