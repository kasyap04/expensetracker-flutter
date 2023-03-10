import 'package:flutter/material.dart';

import '../../trackexpenses/controller/colors.dart';

class CardWidget extends StatelessWidget {
  final void Function() menuPressed;
  final String expenseTime;
  final String expense;

  late Map? monthlyPlan;
  // final String cardType;

  final void Function(String value) itemSelected;

  CardWidget(
      {required this.menuPressed,
      required this.expenseTime,
      required this.expense,
      // required this.cardType,
      required this.itemSelected(String value),
      this.monthlyPlan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      margin: const EdgeInsets.only(bottom: 20),
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColor().primary, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expenseTime,
                style: TextStyle(color: AppColor().lightTextOnPrimary),
              ),
              PopupMenuButton(
                  iconSize: 20,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color.fromARGB(255, 170, 170, 170),
                  ),
                  onSelected: (choice) {
                    itemSelected(choice.toString());
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "Today",
                          child: Text("Today"),
                        ),
                        const PopupMenuItem(
                          value: "This week",
                          child: Text("This week"),
                        ),
                        const PopupMenuItem(
                          value: "This month",
                          child: Text("This month"),
                        ),
                      ])
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 15)),
          Visibility(
              visible: monthlyPlan != null ? true : false,
              child: MonthlyPlanExpenseView(
                expData: monthlyPlan!,
              )),
          Visibility(
              visible: monthlyPlan == null ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.currency_rupee,
                    color: AppColor().rupeeOnPrimaryColor,
                  ),
                  Text(
                    expense,
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       "card name",
          //       style: TextStyle(color: AppColor().lightTextOnPrimary),
          //     ),
          //     const Padding(padding: EdgeInsets.only(left: 10))
          //   ],
          // )
        ],
      ),
    );
  }
}

class MonthlyPlanExpenseView extends StatelessWidget {
  final Map expData;
  MonthlyPlanExpenseView({required this.expData});
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.currency_rupee,
              color: AppColor().rupeeOnPrimaryColor,
            ),
            Text(
              expData['spend'],
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "/",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.currency_rupee,
              size: 15,
              color: AppColor().rupeeOnPrimaryColor,
            ),
            Text(
              expData['total'],
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Text(
          expData['name'],
          style: TextStyle(color: AppColor().lightTextOnPrimary, fontSize: 20),
        )
      ],
    );
  }
}
