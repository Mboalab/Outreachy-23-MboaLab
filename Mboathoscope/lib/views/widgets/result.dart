import 'package:flutter/material.dart';
import 'package:mboathoscope/views/widgets/resultChild.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatelessWidget{
  final List<dynamic>? predictionResult;
  ResultPage({Key? key, required this.predictionResult}) : super(key: key);
    final  diseaseName = [
      'Artifact',
      'Extrahls',
      'Extrastole',
      'Murmur',
      'Normal'
    ];


  @override
  Widget build(BuildContext context) {
    List? flattenedData = predictionResult?.expand((element) => element).toList();
    print("Prediction from result screen: ${predictionResult.toString()}");

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
        onPressed: () =>      Navigator.of(context)
            .pushNamedAndRemoveUntil('/homepage',  (Route<dynamic> route) => false),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Center( child: Text('Result',style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),),

              ),
            ),
           //SafeArea( child: Lottie.asset('assets/animations/doc.json'), ),
            Padding(
                padding: const EdgeInsets.only(
                  right: 0,
                  left: 70,
                  top: 0,
                  bottom: 0,
                ),
                child : Row (
                  children:   [Container(
                    height: h * .2,
                    width: w * .7,
                    child: Lottie.asset('assets/animations/doc.json'),
                  ),
                  ],
                )
            ),
            GridView.builder(

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0, childAspectRatio: (1 / .7),
              ),

              shrinkWrap: true, // You won't see infinite size error
              physics: ScrollPhysics(),
              itemCount: flattenedData?.length,
              itemBuilder: (BuildContext ctx, index) =>
                  AddCard(  name: diseaseName[index],predictionResult: flattenedData?[index]),
            ),
          ],
        ),
      ),
    );
  }
}