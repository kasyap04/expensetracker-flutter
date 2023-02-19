import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../addExpense/view/expenseFeildsView.dart';
// import '../controller/monthlyPlanController.dart';

class ViewAllMonthlyExpense extends StatefulWidget {
  @override
  State<ViewAllMonthlyExpense> createState() => ViewAllMonthlyExpenseState();
}

class ViewAllMonthlyExpenseState extends State<ViewAllMonthlyExpense> {
  @override
  Widget build(BuildContext context) {
    // getMontlyPlan();
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          // color: const Color.fromARGB(31, 158, 158, 158),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "My monthly plan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          MonthlyPlan(),
        ],
      ),
    );
  }
}

class MonthlyPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: [
        MonltyPlanItems(),
        MonltyPlanItems(),
      ],
      options: CarouselOptions(
          // height: 360,
          enableInfiniteScroll: false,
          viewportFraction: 0.98),
    );
  }
}

class MonltyPlanItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: const Color.fromARGB(14, 197, 17, 116),
          borderRadius: BorderRadius.circular(8)),
      child: GridView.count(
        primary: false,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 24, 80),
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              onTap: () {
                print("ok");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "100/1500",
                    style: TextStyle(color: Colors.white),
                  ),
                  FeildPadding(
                    padding: 5,
                  ),
                  Text("Fuel",
                      style:
                          TextStyle(color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 24, 80),
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                print("ok");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "100/1500",
                    style: TextStyle(color: Colors.white),
                  ),
                  FeildPadding(
                    padding: 5,
                  ),
                  Text("Fuel",
                      style:
                          TextStyle(color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 24, 80),
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                print("ok");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "100/1500",
                    style: TextStyle(color: Colors.white),
                  ),
                  FeildPadding(
                    padding: 5,
                  ),
                  Text("Fuel",
                      style:
                          TextStyle(color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 24, 80),
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                print("ok");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "100/1500",
                    style: TextStyle(color: Colors.white),
                  ),
                  FeildPadding(
                    padding: 5,
                  ),
                  Text("Fuel",
                      style:
                          TextStyle(color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 24, 80),
                borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              highlightColor: Colors.grey,
              onTap: () {
                print("ok");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "100/1500",
                    style: TextStyle(color: Colors.white),
                  ),
                  FeildPadding(
                    padding: 5,
                  ),
                  Text("Fuel",
                      style:
                          TextStyle(color: Color.fromARGB(255, 190, 190, 190))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
