import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Barchart extends StatefulWidget {
  List<String> labels;
  List<double> values;
  int maxNum;
  Barchart(
      {super.key, required this.labels, required this.values, this.maxNum = 7});

  @override
  State<Barchart> createState() => _BarchartState();
}

class _BarchartState extends State<Barchart> {
  List<ChartData> chartData = [];
  @override
  void initState() {
    chartData = selectTopData(
        widget.maxNum, ListToSortedData(widget.labels, widget.values));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '에측 결과:${chartData[0].x}  확률:${(chartData[0].y * 100).toStringAsFixed(2)}%',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: <ChartSeries>[
              BarSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  // Width of the bars
                  width: 0.6,
                  // Spacing between the bars
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  spacing: 0.3)
            ]),
      ],
    );
  }
}
