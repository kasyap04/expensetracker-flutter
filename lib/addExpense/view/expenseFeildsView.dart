import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ExpenseFeild extends StatelessWidget {
  final formKey;
  final expenseController;
  final tagController;
  final descriptionController;

  ExpenseFeild(
      {required this.formKey,
      required this.expenseController,
      required this.tagController,
      required this.descriptionController});
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
                label: "Expense",
              ),
              FeildPadding(padding: 5),
              ExpenseView(controller: expenseController),
              FeildPadding(padding: 30),
              FeildLabel(label: "Tag"),
              FeildPadding(padding: 5),
              TagView(controller: tagController),
              FeildPadding(padding: 30),
              FeildLabel(label: "Description (Optional)"),
              FeildPadding(padding: 5),
              DescriptionView(controller: descriptionController),
            ],
          )),
    );
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
      style: const TextStyle(fontSize: 23),
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
          return 'Enter your expense';
        } else {
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 23),
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

class DescriptionView extends StatelessWidget {
  final controller;
  DescriptionView({required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: true,
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 23),
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
