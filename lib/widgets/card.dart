import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key, @required this.text, @required this.icon, this.radius})
      : super(key: key);
  final IconData? icon;
  final String? text;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(radius!),
        ),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon!,
            color: Colors.grey,
            size: 55,
          ),
          Text(
            text!,
            textAlign: TextAlign.center,
            style: kBodyText3.copyWith(
              // fontFamily:
              textBaseline: TextBaseline.alphabetic,
              fontSize: 19,
            ),
          )
        ],
      ),
    );
  }
}
