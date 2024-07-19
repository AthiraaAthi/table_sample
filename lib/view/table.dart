import 'package:drp_dwn_check/database/table_db.dart';
import 'package:drp_dwn_check/providers/category_provider.dart';
import 'package:drp_dwn_check/utils/color_constant.dart';
import 'package:drp_dwn_check/view/category_screen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class BudgetGoalScreen extends StatefulWidget {
  const BudgetGoalScreen({super.key});

  @override
  State<BudgetGoalScreen> createState() => _BudgetGoalScreenState();
}

class _BudgetGoalScreenState extends State<BudgetGoalScreen> {
  List<String> numbers = [
    // for year
    "year",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
  ];

  String dropDownValue = "year";
  List<String> months = [
    // for month
    "month",

    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];
  String dropDownMonthValue = "month";
  List<String> MonthOrWeek = ["monthly", "weekly"]; // week or month selection
  String dropDownMonthOrWeekValue = "monthly";

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      //for showing the picked date
      BuildContext context,
      TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  TableDb tableDb = TableDb();
  List<Map<String, String>> enteredvalues = [];
  int? editingIndex;
  String categorydropdownValue = '';
  String selectedCategory = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      bool categoriesAvailable = categoryProvider.categories.isNotEmpty;
      categorydropdownValue = categoriesAvailable
          ? categoryProvider.categories[0].title
          : 'Add categories';
      selectedCategory = categorydropdownValue;
    });
    fetchData();
  }

  void fetchData() async {
    List<Map<String, dynamic>> entries = await tableDb.fetchEntries();
    setState(() {
      enteredvalues = entries
          .map((entry) {
            return {
              "amount": entry['amount'].toString(),
              "month": entry['month'].toString(),
              "year": entry['year'].toString(),
              "category": entry['category'].toString(),
            };
          })
          .toList()
          .cast<Map<String, String>>();
    });
  }

  List<String> getDatesInRange(String start, String end) {
    List<String> dates = [];
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime startDate = dateFormat.parse(start);
    DateTime endDate = dateFormat.parse(end);

    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(Duration(days: 1))) {
      dates.add(dateFormat.format(date));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    double hintSize = 12;
    double buttonSize = 15;
    double tabhint = 18;
    double tabPadding = 80;

    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstant.bgBlue,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.width < 600 ? 60 : 80,
        backgroundColor: ColorConstant.defIndigo,
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
        title: MediaQuery.of(context).size.width < 600
            ? Text(
                "budget_goal_title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                "budget_goal_title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(),
                    ));
              },
              icon: Icon(
                Icons.category,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      underline: Container(),
                      value: dropDownValue,
                      items:
                          numbers.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 70, left: 10),
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropDownValue = value!;
                        });
                      },
                    ),
                  ),
                  Container(
                    // WEEK or MONTH Selection
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                      underline: Container(),
                      value: dropDownMonthOrWeekValue,
                      items: MonthOrWeek.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(right: 50, left: 10),
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropDownMonthOrWeekValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ), // first row dropdown
              SizedBox(
                height: 20,
              ),
              if (dropDownMonthOrWeekValue == "monthly") ...[
                //Mothly dropdowns
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<String>(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        underline: Container(),
                        value: dropDownMonthValue,
                        items: months
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(right: 50, left: 10),
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropDownMonthValue = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          // Check if categories are available
                          bool categoriesAvailable =
                              categoryProvider.categories.isNotEmpty;
                          // Set the initial dropdown value
                          String categorydropdownValue = categoriesAvailable
                              ? categoryProvider.categories[0].title
                              : 'No categories available';

                          return DropdownButton<String>(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                            underline: Container(),
                            value: selectedCategory,
                            items: categoriesAvailable
                                ? categoryProvider.categories
                                    .map<DropdownMenuItem<String>>((category) {
                                    return DropdownMenuItem<String>(
                                      value: category.title,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 50, left: 10),
                                        child: Text(
                                          category.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    DropdownMenuItem<String>(
                                      value: 'Add categories',
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoriesScreen(),
                                                ));
                                          },
                                          child: Text(
                                            'Add categories',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                            onChanged: categoriesAvailable
                                ? (String? value) {
                                    setState(() {
                                      categorydropdownValue = value!;
                                      selectedCategory = value;
                                    });
                                  }
                                : null, // Disable the dropdown if no categories are available
                          );
                        },
                      ),
                    ), //ADDED CATEGORY SCREEN ADDED CATEGORIES DISPLAY ON BUDGET GOAL SCREEN
                  ],
                ),
              ] else if (dropDownMonthOrWeekValue == "weekly") ...[
                //the extra dropdowns for weekly
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: startDateController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: hintSize),
                            hintText: "startDate",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await _selectDate(context, startDateController);
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        controller: endDateController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: hintSize),
                            hintText: "endDate",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10)),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await _selectDate(context, endDateController);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    width: 323,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        // Check if categories are available
                        bool categoriesAvailable =
                            categoryProvider.categories.isNotEmpty;
                        // Set the initial dropdown value
                        String categorydropdownValue = categoriesAvailable
                            ? categoryProvider.categories[0].title
                            : 'Add categories';

                        return DropdownButton<String>(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          underline: Container(),
                          value: selectedCategory,
                          items: categoriesAvailable
                              ? categoryProvider.categories
                                  .map<DropdownMenuItem<String>>((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.title,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 200, left: 10),
                                      child: Text(
                                        category.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()
                              : [
                                  DropdownMenuItem<String>(
                                    value: 'Add categories',
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoriesScreen(),
                                              ));
                                        },
                                        child: Text(
                                          'Add categories',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                          onChanged: categoriesAvailable
                              ? (String? value) {
                                  setState(() {
                                    categorydropdownValue = value!;
                                    selectedCategory = value;
                                  });
                                }
                              : null, // Disable the dropdown if no categories are available
                        );
                      },
                    ) //ADDED CATEGORY SCREEN ADDED CATEGORIES DISPLAY ON BUDGET GOAL SCREEN

                    ),
              ],
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 323,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "enterAmount",
                      hintStyle: TextStyle(fontSize: 13),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                // onTap: () async {
                //   setState(() async {
                //     String enteredAmount = amountController.text;
                //     if (dropDownMonthOrWeekValue == 'monthly') {
                //       Map<String, String> entry = {
                //         "amount": enteredAmount,
                //         "month": "$dropDownMonthValue $dropDownValue",
                //         "category": selectedCategory,
                //       };
                //       await tableDb.insertEntry(entry);
                //       fetchData();

                //       // enteredvalues.add({
                //       //   "amount": enteredAmount,
                //       //   "month": "$dropDownMonthValue  $dropDownValue",
                //       //   "category": selectedCategory,
                //       // });
                //       setState(() {
                //         enteredvalues.add(entry);
                //         dropDownMonthValue = "month";
                //         dropDownValue = "year";
                //       });
                //       amountController.clear();
                //     } else if (dropDownMonthOrWeekValue == 'weekly') {
                //       List<String> dates = getDatesInRange(
                //           startDateController.text, endDateController.text);
                //       for (String date in dates) {
                //         // enteredvalues.add({
                //         //   "amount": enteredAmount,
                //         //   "month": date,
                //         //   "category": selectedCategory,
                //         // });
                //         Map<String, String> entry = {
                //           "amount": enteredAmount,
                //           "month": date,
                //           "category": selectedCategory,
                //         };

                //         await tableDb.insertEntry(entry);
                //         fetchData();

                //         setState(() {
                //           enteredvalues.add(entry);
                //         });
                //       }
                //       startDateController.clear();
                //       endDateController.clear();
                //     }
                //     amountController
                //         .clear(); // Clear the text field after submission
                //   });
                // },
                onTap: () async {
                  setState(() async {
                    String enteredAmount = amountController.text;
                    if (dropDownMonthOrWeekValue == 'monthly') {
                      Map<String, String> entry = {
                        "amount": enteredAmount,
                        "month": "$dropDownMonthValue $dropDownValue",
                        "year": dropDownValue,
                        "category": selectedCategory,
                      };
                      await tableDb.insertEntry(entry);
                      fetchData();

                      setState(() {
                        enteredvalues.add(entry);
                        dropDownMonthValue = "month";
                        dropDownValue = "year";
                      });
                      amountController.clear();
                    } else if (dropDownMonthOrWeekValue == 'weekly') {
                      List<String> dates = getDatesInRange(
                          startDateController.text, endDateController.text);
                      for (String date in dates) {
                        Map<String, String> entry = {
                          "amount": enteredAmount,
                          "month": date,
                          "year": " ",
                          "category": selectedCategory,
                        };

                        await tableDb.insertEntry(entry);
                        fetchData();

                        setState(() {
                          enteredvalues.add(entry);
                        });
                      }
                      startDateController.clear();
                      endDateController.clear();
                    }
                    amountController
                        .clear(); // Clear the text field after submission
                  });
                },

                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    color: ColorConstant.defIndigo,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              enteredvalues.isEmpty
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text("No Data Available"),
                    ))
                  : DataTable(
                      dataRowMaxHeight: 60,
                      columnSpacing: 30,
                      border: TableBorder.all(color: Colors.grey, width: 0.5),
                      columns: [
                        DataColumn(
                            label: Text(
                          dropDownMonthOrWeekValue == "monthly"
                              ? "month"
                              : "date", //changed table date column according to week or month selection
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                        )),
                        DataColumn(
                            label: Text(
                          'category',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                        )),
                        DataColumn(
                            label: Text(
                          'amount',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                        )),
                        DataColumn(
                            label: Text(
                          'action',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 13),
                        )),
                      ],
                      rows: enteredvalues.map<DataRow>((entry) {
                        return DataRow(cells: [
                          DataCell(
                            Text(entry['month'] ?? ''),
                          ),
                          DataCell(Text(entry['category'] ?? '')),
                          DataCell(Text(entry['amount'] ?? '')),
                          DataCell(Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  /////////////////FOR EDIT DIALOG
                                  onTap: () {
                                    _showEditDialog(
                                        entry, enteredvalues.indexOf(entry));
                                  },
                                  child: Text(
                                    'edit',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: buttonSize),
                                  ),
                                ),
                              ),
                              InkWell(
                                // onTap: () async {
                                //   String amountToDelete = entry['amount']!;
                                //   String monthToDelete = entry['month']!;
                                //   String categoryToDelete = entry['category']!;

                                //   await tableDb.deleteEntry(amountToDelete,
                                //       monthToDelete, categoryToDelete);
                                //   fetchData();

                                //   setState(() {
                                //     enteredvalues
                                //         .remove(entry); // Remove the selected entry
                                //   });
                                // },
                                onTap: () async {
                                  ////////
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        "Are you sure?",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      title: Text(
                                        "This will delete the whole Row",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            String amountToDelete =
                                                entry['amount']!;
                                            String monthToDelete =
                                                entry['month']!;
                                            String categoryToDelete =
                                                entry['category']!;
                                            String yearToDelete =
                                                entry['year']!;

                                            await tableDb.deleteEntry(
                                                amountToDelete,
                                                monthToDelete,
                                                categoryToDelete,
                                                yearToDelete);
                                            fetchData();

                                            setState(() {
                                              enteredvalues.remove(
                                                  entry); // Remove the selected entry
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'delete',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: buttonSize),
                                ),
                              )
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    ));
  }

  // void _showEditDialog(Map<String, String> entry, int index) {
  //   final TextEditingController amountController =
  //       TextEditingController(text: entry['amount']);
  //   final TextEditingController startDateController =
  //       TextEditingController(text: entry['month']);
  //   String selectedCategory = entry['category'] ?? '';
  //   String editMonthValue = entry['month'] ?? '';
  //   String editYearValue = entry['year'] ?? '';

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Center(
  //             child: Text(
  //           "Edit your Budget Goal",
  //           style: TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //               color: ColorConstant.defIndigo),
  //         )),
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (dropDownMonthOrWeekValue == 'monthly') ...[
  //                     Container(
  //                       height: 50,
  //                       width: 250,
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey)),
  //                       child: DropdownButton<String>(
  //                         underline: Container(),
  //                         value: editMonthValue,
  //                         items: months.map((String value) {
  //                           return DropdownMenuItem<String>(
  //                             value: value,
  //                             child: Padding(
  //                               padding: EdgeInsets.all(8),
  //                               child: Text(value),
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onChanged: (String? newValue) {
  //                           setState(() {
  //                             editMonthValue = newValue!;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     Container(
  //                       height: 50,
  //                       width: 250,
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey)),
  //                       child: DropdownButton<String>(
  //                         underline: Container(),
  //                         value: editYearValue,
  //                         items: numbers.map((String value) {
  //                           return DropdownMenuItem<String>(
  //                             value: value,
  //                             child: Padding(
  //                               padding: EdgeInsets.all(8.0),
  //                               child: Text(value),
  //                             ),
  //                           );
  //                         }).toList(),
  //                         onChanged: (String? newValue) {
  //                           setState(() {
  //                             editYearValue = newValue!;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ] else if (dropDownMonthOrWeekValue == 'weekly') ...[
  //                     Container(
  //                       height: 50,
  //                       width: 250,
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.grey)),
  //                       child: Padding(
  //                         padding: EdgeInsets.all(8.0),
  //                         child: TextField(
  //                           controller: startDateController,
  //                           decoration: InputDecoration(
  //                               hintText: "Start Date",
  //                               border: InputBorder.none),
  //                           onTap: () async {
  //                             FocusScope.of(context).requestFocus(FocusNode());
  //                             await _selectDate(context, startDateController);
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Container(
  //                     height: 50,
  //                     width: 250,
  //                     decoration:
  //                         BoxDecoration(border: Border.all(color: Colors.grey)),
  //                     child: Padding(
  //                       padding: EdgeInsets.all(16),
  //                       child: TextField(
  //                         controller: amountController,
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: "Enter Amount",
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Consumer<CategoryProvider>(
  //                     builder: (context, categoryProvider, child) {
  //                       bool categoriesAvailable =
  //                           categoryProvider.categories.isNotEmpty;
  //                       return Container(
  //                         height: 50,
  //                         width: 250,
  //                         decoration: BoxDecoration(
  //                             border: Border.all(color: Colors.grey)),
  //                         child: DropdownButton<String>(
  //                           underline: Container(),
  //                           value: selectedCategory,
  //                           items: categoriesAvailable
  //                               ? categoryProvider.categories.map((category) {
  //                                   return DropdownMenuItem<String>(
  //                                     value: category.title,
  //                                     child: Padding(
  //                                       padding: EdgeInsets.all(8.0),
  //                                       child: Text(category.title),
  //                                     ),
  //                                   );
  //                                 }).toList()
  //                               : [
  //                                   DropdownMenuItem<String>(
  //                                     value: 'Add categories',
  //                                     child: InkWell(
  //                                       onTap: () {
  //                                         Navigator.push(
  //                                           context,
  //                                           MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 CategoriesScreen(),
  //                                           ),
  //                                         );
  //                                       },
  //                                       child: Text('Add categories'),
  //                                     ),
  //                                   ),
  //                                 ],
  //                           onChanged: categoriesAvailable
  //                               ? (String? newValue) {
  //                                   setState(() {
  //                                     selectedCategory = newValue!;
  //                                   });
  //                                 }
  //                               : null,
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               // Map<String, String> updatedEntry = {
  //               //   'amount': amountController.text,
  //               //   'month': dropDownMonthOrWeekValue == 'monthly'
  //               //       ? "$editMonthValue $editYearValue"
  //               //       : startDateController.text,
  //               //   'category': selectedCategory,
  //               // };
  //               // int idToUpdate = index;
  //               // print('Updating entry: $updatedEntry'); // Debugging
  //               // await TableDb().updateEntry(idToUpdate, updatedEntry);
  //               // setState(() {
  //               //   enteredvalues[index] = updatedEntry;
  //               // });
  //               // // setState(() {
  //               // //   // Update local UI state
  //               // //   if (index >= 0 && index < enteredvalues.length) {
  //               // //     enteredvalues[index] = updatedEntry;
  //               // //   } else {
  //               // //     print('Error: Index out of range for updating entry');
  //               // //   }
  //               // // });

  //               // Navigator.of(context).pop(); // Close the edit dialog

  //               // // // Update the local state
  //               // // setState(() {
  //               // //   enteredvalues[index] = entry;
  //               // // });
  //               Map<String, String> updatedEntry = {
  //                 'amount': amountController.text,
  //                 'month': dropDownMonthOrWeekValue == 'monthly'
  //                     ? editMonthValue
  //                     : startDateController.text,
  //                 'year': dropDownMonthOrWeekValue == 'monthly'
  //                     ? editYearValue
  //                     : "",
  //                 'category': selectedCategory,
  //               };
  //               await TableDb().updateEntry(index, updatedEntry);
  //               setState(() {
  //                 enteredvalues[index] = updatedEntry;
  //               });
  //               Navigator.of(context).pop(); // Close the edit dialog
  //             },
  //             child: Text("Save"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showEditDialog(Map<String, String> entry, int index) {
    final TextEditingController amountController =
        TextEditingController(text: entry['amount']);
    final TextEditingController startDateController =
        TextEditingController(text: entry['month']);
    final TextEditingController yearController =
        TextEditingController(text: entry['year'] ?? 'N/A');
    String selectedCategory = entry['category'] ?? '';
    String editMonthValue = entry['month'] ?? '';
    String editYearValue = entry['year'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "Edit your Budget Goal",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorConstant.defIndigo),
          )),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (dropDownMonthOrWeekValue == 'monthly') ...[
                      Container(
                        height:
                            MediaQuery.of(context).size.width < 600 ? 50 : 70,
                        width:
                            MediaQuery.of(context).size.width < 600 ? 250 : 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: editMonthValue,
                          items: months.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              editMonthValue = newValue!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: editYearValue,
                          items: numbers.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              editYearValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ] else if (dropDownMonthOrWeekValue == 'weekly') ...[
                      // For Weekly Entries
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: startDateController,
                            decoration: InputDecoration(
                                hintText: "Start Date",
                                border: InputBorder.none),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await _selectDate(context, startDateController);
                            },
                          ),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                          controller: amountController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Amount",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Consumer<CategoryProvider>(
                      builder: (context, categoryProvider, child) {
                        bool categoriesAvailable =
                            categoryProvider.categories.isNotEmpty;
                        return Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: DropdownButton<String>(
                            underline: Container(),
                            value: selectedCategory,
                            items: categoriesAvailable
                                ? categoryProvider.categories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category.title,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(category.title),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    DropdownMenuItem<String>(
                                      value: 'Add categories',
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoriesScreen(),
                                            ),
                                          );
                                        },
                                        child: Text('Add categories'),
                                      ),
                                    ),
                                  ],
                            onChanged: categoriesAvailable
                                ? (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue!;
                                    });
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Map<String, String> updatedEntry = {
                  'amount': amountController.text,
                  'month': dropDownMonthOrWeekValue == 'monthly'
                      ? editMonthValue
                      : startDateController.text,
                  'year': dropDownMonthOrWeekValue == 'monthly'
                      ? editYearValue
                      : 'N/A',
                  'category': selectedCategory,
                };
                await TableDb().updateEntry(index, updatedEntry);
                setState(() {
                  enteredvalues[index] = updatedEntry;
                });
                Navigator.of(context).pop(); // Close the edit dialog
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
