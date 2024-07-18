import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.color,
      this.onEditTap,
      this.onDeleteTap});
  final String title;
  final String description;
  final Color color;
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 99,
        width: 345,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 0.5,
                offset: Offset(0, 2),
                spreadRadius: 0.1)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    color: color,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    description,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: onEditTap,
                      child: Text(
                        "Edit",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    InkWell(
                      onTap: onDeleteTap,
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
