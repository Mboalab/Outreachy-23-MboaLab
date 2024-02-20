import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddCard extends StatelessWidget {
  final String name;
  final bool isNormal;
  final bool highlighted;

  AddCard({Key? key, required this.name, required this.isNormal, required this.highlighted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color borderColor = highlighted ? (isNormal ? Colors.blueAccent : Colors.red) : Colors.black;
    //Color textColor = highlighted ? Colors.black : Colors.black;
    Color textColor = highlighted ? (isNormal ? Colors.blueAccent : Colors.red) : Colors.black;
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {},
        child: DottedBorder(
          color: borderColor,
          dashPattern: const [60, 10],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
