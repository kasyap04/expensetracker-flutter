import 'package:flutter/material.dart';
import 'package:trackexpense/trackexpenses/controller/colors.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() action;
  final String buttonLabel;
  PrimaryButton({required this.action, required this.buttonLabel});
  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(backgroundColor: AppColor().primary),
      child: Text(buttonLabel));
}
