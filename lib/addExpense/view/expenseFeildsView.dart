import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import '../../settings/model/settingsMode.dart';

// class ExpenseFeild extends StatelessWidget {
//   final GlobalKey formKey;
//   final TextEditingController expenseController;
//   final TextEditingController tagController;
//   final TextEditingController categoryController;

//   final void Function(int typeId) transactionType;
//   final Color incomeTextColor;
//   final Color expenseTextColor;
//   final Color incomBgColor;
//   final Color expenseBgColor;
//   final void Function(String msg) callSnackbar;

//   ExpenseFeild(
//       {required this.formKey,
//       required this.expenseController,
//       required this.tagController,
//       required this.categoryController,
//       required this.transactionType,
//       required this.incomeTextColor,
//       required this.incomBgColor,
//       required this.expenseBgColor,
//       required this.expenseTextColor,
//       required this.callSnackbar});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: 100,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           color: const Color.fromARGB(15, 4, 49, 116),
//           borderRadius: BorderRadius.circular(10)),
//       child: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FeildLabel(
//                 label: "Amount",
//               ),
//               FeildPadding(padding: 5),
//               ExpenseView(controller: expenseController),
//               FeildPadding(padding: 30),
//               FeildLabel(label: "Category"),
//               FeildPadding(padding: 5),
//               Category(
//                   controller: categoryController, callSnackbar: callSnackbar),
//               FeildPadding(padding: 30),
//               FeildLabel(label: "Spend for"),
//               FeildPadding(padding: 5),
//               TagView(controller: tagController),
//               FeildPadding(padding: 30),
//               FeildLabel(label: "Transaction type"),
//               FeildPadding(padding: 5),
//               TransactionType(
//                 expenseBgColor: expenseBgColor,
//                 expenseTextColor: expenseTextColor,
//                 incomBgColor: incomBgColor,
//                 incomeTextColor: incomeTextColor,
//                 transactionSelected: transactionType,
//               )
//             ],
//           )),
//     );
//   }
// }

class Category extends StatefulWidget {
  final controller;
  final void Function(String msg) callSnackbar;
  Category({required this.controller, required this.callSnackbar});
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
              widget.callSnackbar("New category added");
              setState(() {});
            } catch (e) {
              widget.callSnackbar(
                  "Failed to create new category, Please again later");
            }
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
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 126, 42, 122)),
                      borderRadius: BorderRadius.circular(6)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 126, 42, 122)),
                      borderRadius: BorderRadius.circular(6)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 126, 42, 122)),
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
  final String label;
  ExpenseView({required this.controller, required this.label});

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
    return Column(
      children: [
        FeildLabel(
          label: label,
        ),
        FeildPadding(padding: 5),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) => expendeValidator(value),
          textCapitalization: TextCapitalization.sentences,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
              prefix: const Icon(
                Icons.currency_rupee,
                size: 11,
                color: Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 126, 42, 122)),
                  borderRadius: BorderRadius.circular(6)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 126, 42, 122)),
                  borderRadius: BorderRadius.circular(6)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 126, 42, 122)),
                  borderRadius: BorderRadius.circular(6))),
        ),
      ],
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
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
              borderRadius: BorderRadius.circular(6)),
          border: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 126, 42, 122)),
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

class TransactionType extends StatefulWidget {
  final void Function(int typeId) transactionSelected;
  final Color incomeTextColor;
  final Color expenseTextColor;
  final Color incomBgColor;
  final Color expenseBgColor;

  TransactionType(
      {required this.transactionSelected,
      required this.incomeTextColor,
      required this.incomBgColor,
      required this.expenseBgColor,
      required this.expenseTextColor});
  @override
  State<TransactionType> createState() => TransactionTypeState();
}

class TransactionTypeState extends State<TransactionType> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            TransactionSelector(
                text: "Expense",
                bgColor: widget
                    .expenseBgColor, //,const Color.fromARGB(255, 221, 221, 221),
                textColor: widget.expenseTextColor, //Colors.black,
                transactionSelected: () => widget.transactionSelected(0)),
            TransactionSelector(
              text: "Income",
              bgColor: widget
                  .incomBgColor, //const Color.fromARGB(255, 103, 34, 112),
              textColor: widget.incomeTextColor, //Colors.white,
              transactionSelected: () => widget.transactionSelected(1),
            )
          ],
        ));
  }
}

class TransactionSelector extends StatefulWidget {
  final String text;
  final textColor;
  final bgColor;
  final void Function() transactionSelected;
  TransactionSelector(
      {required this.text,
      required this.textColor,
      required this.bgColor,
      required this.transactionSelected});
  @override
  State<TransactionSelector> createState() => TransactionSelectorState();
}

class TransactionSelectorState extends State<TransactionSelector> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 50,
      color: widget.bgColor,
      child: InkWell(
        onTap: widget.transactionSelected,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(color: widget.textColor),
          ),
        ),
      ),
    ));
  }
}
