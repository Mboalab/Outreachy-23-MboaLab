import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';



class AddCard extends StatelessWidget {

  final String randomText;
  final String ind;


  AddCard({Key? key, required this.randomText, required this.ind}) : super(key: key);



  @override
  Widget build(BuildContext context) {


    double squareWidth = MediaQuery.of(context).size.width;
    return Container(
      width: squareWidth / 2 ,
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {},
        child: DottedBorder(
          color: Colors.grey[700]!,
          dashPattern: const [60,10],
          child: Center(
            child: Text('$randomText $ind ' ,textAlign: TextAlign.center , style: TextStyle(
              fontSize: 15.0,
            ),),

          ),
        ),

      ),
    );
  }
}
