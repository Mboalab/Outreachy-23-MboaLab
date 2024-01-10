import 'package:flutter/material.dart';
import 'package:mboathoscope/views/widgets/resultChild.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatelessWidget{
  ResultPage({super.key});
  /*  final  randomTexts = [
      'Healthy',
       'Chronic Obstructic pulmonary Disease',
      'Upper Respiratory Tract Infection',
      'Pneumonia',
      'Bronchiectasis',
      'other'
    ];*/
  final List<Map<String, String>> randomTexts = [
    {'title': 'Healthy', 'subtitle': ' 1'},
    {'title': 'Chronic Obstructic pulmonary Disease', 'subtitle': ' 2'},
    {'title': 'Upper Respiratory Tract Infection', 'subtitle': ' 3'},
    {'title': 'Pneumonia', 'subtitle': ' 4'},
    {'title': 'Bronchiectasis', 'subtitle': ' 5'},
    {'title': 'other', 'subtitle': ' 6'},
    // Add more items as needed
  ];


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () =>   Navigator.pushNamed(context, '/homepage'),
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
              itemCount: randomTexts.length,
              itemBuilder: (BuildContext ctx, index) =>
                  AddCard(randomText: randomTexts[index]['title']!
                      , ind: randomTexts[index]['subtitle']!),
            ),
          ],
        ),
      ),
    );
  }
}