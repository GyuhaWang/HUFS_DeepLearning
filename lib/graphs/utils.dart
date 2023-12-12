List<ChartData> ListToChartDataConverter(
    List<String> labels, List<double> values) {
  assert(labels.length == values.length);
  List<ChartData> result = [];
  for (int i = 0; i < labels.length; i++) {
    ChartData chartData = ChartData(labels[i].toString(), values[i]);

    result.add(chartData);
  }
  return result;
}

List<ChartData> ListToSortedData(List<String> label, List<double> values) {
  List<ChartData> result = [];

  List<MapEntry<int, double>> indexedList = values.asMap().entries.toList();
  indexedList.sort((a, b) => a.value.compareTo(b.value));
  List<int> sortedIndices = indexedList.map((entry) => entry.key).toList();
  List<double> sortedValue = indexedList.map((entry) => entry.value).toList();

  List<MapEntry<int, String>> indexedLabels = label.asMap().entries.toList();
  indexedLabels.sort((a, b) =>
      sortedIndices.indexOf(a.key).compareTo(sortedIndices.indexOf(b.key)));
  List<String> sortedLabels =
      indexedLabels.map((entry) => entry.value).toList();

  for (int i = 0; i < sortedLabels.length; i++) {
    result.add(ChartData(sortedLabels[i], sortedValue[i]));
  }
  return result;
}

List<ChartData> selectTopData(int rank, List<ChartData> data) {
  List<ChartData> result = [];
  for (int i = data.length - 1; i >= data.length - rank; i--) {
    if (data.length - rank >= 0) {
      result.add(data[i]);
    }
  }
  return result;
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
