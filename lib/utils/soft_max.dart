import 'dart:math';

List<double> softmax(List<double> input) {
  double sumExp = 0.0;

  for (double value in input) {
    sumExp += exp(value);
  }
  print(sumExp);
  List<double> result = [];
  for (double value in input) {
    result.add(exp(value) / sumExp);
  }

  return result;
}
