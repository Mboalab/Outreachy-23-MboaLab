import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';



class AddCard extends StatelessWidget {


  final dynamic  predictionResult;
  final String name;

  AddCard( {Key? key, required this.predictionResult,required this.name}) : super(key: key);
  String formatValuesAsPercentage(double value) {

      double percentage = (value * 100);
      return '${percentage.toStringAsFixed(2)}%';

  }
  /*String formatFirstValueAsPercentage() {
    double firstValue = predictionResult[0];
    double percentage = firstValue * 100;
    return '${percentage.toStringAsFixed(2)}%';
  }*/


  @override
  Widget build(BuildContext context) {


     double squareWidth = MediaQuery.of(context).size.width;
     String formattedValues = formatValuesAsPercentage(predictionResult);


    return Container(
      width: squareWidth / 2 ,
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {},
        child: DottedBorder(
          color: Colors.grey[700]!,
          dashPattern: const [60,10],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    name,
                textAlign: TextAlign.center ,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(formattedValues ,textAlign: TextAlign.center , style: TextStyle(
                    fontSize: 15.0,
                  ),),
                ],
              ),
            ),

          ),
        ),

      ),
    );
  }
}
