import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  Function function;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;

  FollowButton({
    Key? key,
    required this.function,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.textColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          function();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(4)
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}