import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SerialDataGraph extends StatefulWidget {
  List<String> labels;
  List<double> values;

  SerialDataGraph({super.key, required this.labels, required this.values});

  @override
  State<SerialDataGraph> createState() => _SerialDataGraphState();
}

class _SerialDataGraphState extends State<SerialDataGraph> {
  List<ChartData> chartData = [];
  List<ChartData> resultData = [];
  @override
  void initState() {
    chartData = ListToChartDataConverter(widget.labels, widget.values);
    resultData =
        selectTopData(1, ListToSortedData(widget.labels, widget.values));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '에측 결과:${resultData[0].x}  확률:${(resultData[0].y * 100).toStringAsFixed(2)}%',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SfCartesianChart(
            // Transpose the chart

            primaryXAxis: CategoryAxis(isVisible: true, axisLine: null),
            primaryYAxis: CategoryAxis(isVisible: true, axisLine: null),
            isTransposed: false,
            series: <CartesianSeries>[
              SplineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              )
            ]),
      ],
    );
  }
}
