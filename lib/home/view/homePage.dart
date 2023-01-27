import 'package:flutter/material.dart';
import 'package:trackexpense/addExpense/view/addExpenses.dart';
// import 'package:trackexpense/trackexpenses/controller/common.dart';
import 'cardView.dart';
import '../../trackexpenses/view/appBarView.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // removeAll();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBarView(
            icon: Icons.settings,
            iconClicked: () {},
          ),
          body: ListView(
            padding: const EdgeInsets.only(left: 10, right: 10),
            children: [CardView()],
          )),
    );
  }
}

// class ButtonAddExpenses extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: 140,
//           child: ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => AddExpenses()));
//               },
//               icon: const Icon(
//                 Icons.add,
//                 size: 30,
//               ),
//               label: const Text("Add expense", style: TextStyle(fontSize: 17)),
//               style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.all(5),
//                   primary: const Color.fromARGB(255, 121, 52, 134))),
//         ),
//       ],
//     );
//   }
// }
