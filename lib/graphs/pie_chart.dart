import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatefulWidget {
  List<String> labels;
  List<double> values;
  int maxNum;
  PieChart(
      {super.key, required this.labels, required this.values, this.maxNum = 2});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<ChartData> chartData = [];
  @override
  void initState() {
    chartData = selectTopData(
        widget.maxNum, ListToSortedData(widget.labels, widget.values));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(series: <CircularSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) {
            return "${(data.y * 100).round()}%:${data.x}";
          },
          onPointTap: (pointInteractionDetails) {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                            '${chartData[pointInteractionDetails.pointIndex!].x}'),
                        Text(
                            '${(chartData[pointInteractionDetails.pointIndex!].y * 100).round()}%')
                      ]),
                    ),
                  );
                });
          },
          radius: '60%',
          dataLabelSettings: DataLabelSettings(
              isVisible: true,
              // Avoid labels intersection
              labelIntersectAction: LabelIntersectAction.shift,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve, length: '25%')))
    ]);
  }
}
