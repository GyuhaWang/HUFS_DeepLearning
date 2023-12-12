import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/utils.dart';

class InstaResultWidget extends StatelessWidget {
  File image;
  List<List<String>> labels;
  List<List<double>> predictions;
  InstaResultWidget(
      {super.key,
      required this.image,
      required this.labels,
      required this.predictions});
  List<ChartData> result = [];
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < labels.length; i++) {
      result.add(compareRatio(predictions[i], labels[i]));
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.heart_broken),
                      Icon(Icons.chat),
                      Icon(Icons.send)
                    ],
                  ),
                  Icon(Icons.bookmark)
                ],
              ),
            ),
            Wrap(
              children: [
                for (ChartData text in result)
                  text.x != '0' ? Text('#${text.x}') : const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget roundContainer(String text){
  //   return Container()
  // }
  ChartData compareRatio(List<double> prediction, List<String> label) {
    int topIndex = 0;
    double currentRatio = 0;
    for (int i = 0; i < prediction.length; i++) {
      if (currentRatio <= prediction[i]) {
        topIndex = i;
        currentRatio = prediction[i];
      }
    }
    return ChartData(label[topIndex], (currentRatio * 100));
  }
}
