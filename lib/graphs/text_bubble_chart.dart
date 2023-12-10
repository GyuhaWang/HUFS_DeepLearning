import 'package:flutter/material.dart';
import 'package:image_classification_proj/graphs/utils.dart';

class TextBubbleChart extends StatefulWidget {
  List<String> labels;
  List<double> values;
  TextBubbleChart({super.key, required this.labels, required this.values});

  @override
  State<TextBubbleChart> createState() => _TextBubbleChartState();
}

class _TextBubbleChartState extends State<TextBubbleChart> {
  List<ChartData> chartData = [];
  @override
  void initState() {
    chartData = ListToChartDataConverter(widget.labels, widget.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        children: [
          for (int i = 0; i < widget.labels.length; i++)
            Bubble(widget.labels[i], widget.values[i])
        ],
      ),
    );
  }

  Widget Bubble(String label, double ratio) {
    return Container(
      height: 500 * ratio,
      width: 500 * ratio,
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      child: Text(label),
    );
  }
}
