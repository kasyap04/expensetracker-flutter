import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:searchfield/searchfield.dart';

import '../../settings/model/settingsMode.dart';

class ExpenseFeild extends StatelessWidget {
  final formKey;
  final expenseController;
  final tagController;
  final categoryController;

  ExpenseFeild(
      {required this.formKey,
      required this.expenseController,
      required this.tagController,
      required this.categoryController});
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(15, 4, 49, 116),
          borderRadius: BorderRadius.circular(10)),
      child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeildLabel(
                label: "Amount",
              ),
              FeildPadding(padding: 5),
              ExpenseView(controller: expenseController),
              FeildPadding(padding: 30),
              FeildLabel(label: "Category"),
              FeildPadding(padding: 5),
              Category(controller: categoryController),
              FeildPadding(padding: 30),
              FeildLabel(label: "Spend for"),
              FeildPadding(padding: 5),
              TagView(controller: tagController),
            ],
          )),
    );
  }
}

class Category extends StatefulWidget {
  final controller;
  Category({required this.controller});
  @override
  State<Category> createState() => CategoryState();
}

class CategoryState extends State<Category> {
  final categories = <SearchFieldListItem>[];
  @override
  Widget build(BuildContext context) {
    dynamic addCategory = InkWell(
        onTap: () async {
          String name = widget.controller.text;
          if (name.isNotEmpty) {
            try {
              var categoryId = await addNewCategory(name);
              setState(() {});
            } catch (e) {}
          }
        },
        child: const Text(
          "Add new",
          style: TextStyle(fontSize: 12),
        ));

    return FutureBuilder(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            categories.clear();
            dynamic categoryDb = snapshot.data;
            for (var cat in categoryDb) {
              categories.add(SearchFieldListItem(cat['name'],
                  child: Row(children: [
                    const Padding(
                        padding:
                            EdgeInsets.only(right: 10, top: 20, bottom: 20)),
                    Text(
                      cat['name'],
                      style: const TextStyle(fontSize: 20),
                    )
                  ])));
            }

            return SearchField(
              controller: widget.controller,
              suggestions: categories,
              suggestionState: Suggestion.expand,
              searchStyle: const TextStyle(fontSize: 18),
              searchInputDecoration: InputDecoration(
                  suffix: addCategory,
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose category';
                } else {
                  return null;
                }
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class ExpenseView extends StatelessWidget {
  final controller;
  ExpenseView({required this.controller});

  dynamic expendeValidator(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Enter your expense';
    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Please enther valid amount';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: (value) => expendeValidator(value),
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
          prefix: const Icon(
            Icons.currency_rupee,
            size: 16,
            color: Colors.grey,
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6))),
    );
  }
}

class TagView extends StatelessWidget {
  final controller;
  TagView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        } else {
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(6))),
    );
  }
}

class FeildLabel extends StatelessWidget {
  final String label;
  FeildLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 7)),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class FeildPadding extends StatelessWidget {
  final double padding;
  FeildPadding({required this.padding});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: padding));
  }
}
