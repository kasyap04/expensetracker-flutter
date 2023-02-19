import 'package:flutter/material.dart';

import '../../trackexpenses/controller/colors.dart';

class NavSectionView extends StatelessWidget {
  final String navheader;
  final String slug;
  final void Function(int index) optionPressed;
  NavSectionView(
      {required this.navheader,
      required this.slug,
      required this.optionPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColor().mildPrimary,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              navheader,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          slug == "monthly"
              ? MontlyPlanExpenseActions(
                  optionPressed: (index) => optionPressed(index),
                )
              : NormalExpenseActions(
                  optionPressed: (index) => optionPressed(index)),
        ],
      ),
    );
  }
}

class MontlyPlanExpenseActions extends StatelessWidget {
  final void Function(int index) optionPressed;
  MontlyPlanExpenseActions({required this.optionPressed});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: (1 / .6),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: [
        NavOptions(
          optionPressed: () => optionPressed(1),
          icon: Icons.add_chart,
          label: "Make a plan",
        ),
        NavOptions(
          optionPressed: () => optionPressed(2),
          icon: Icons.add_card_outlined,
          label: "Add an expense",
        ),
        NavOptions(
          optionPressed: () => optionPressed(3),
          icon: Icons.area_chart_outlined,
          label: "View active plans",
        ),
        NavOptions(
          optionPressed: () => optionPressed(4),
          icon: Icons.view_agenda,
          label: "All plans",
        ),
      ],
    );
  }
}

class NormalExpenseActions extends StatelessWidget {
  final void Function(int index) optionPressed;

  NormalExpenseActions({required this.optionPressed});
  @override
  Widget build(BuildContext context) => GridView.count(
        childAspectRatio: (1 / .4),
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        children: [
          NavOptions(
            optionPressed: () => optionPressed(5),
            icon: Icons.add_card_outlined,
            label: "Add an expense",
          ),
          NavOptions(
            optionPressed: () => optionPressed(6),
            icon: Icons.list_alt_outlined,
            label: "View my expenses",
          ),
        ],
      );
}

class NavOptions extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() optionPressed;
  NavOptions(
      {required this.label, required this.icon, required this.optionPressed});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Material(
        child: InkWell(
          onTap: optionPressed,
          // highlightColor: AppColor().navActionColor,
          splashColor: AppColor().navActionSplashColor,
          child: Ink(
            color: AppColor().mildPrimary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColor().primary,
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
