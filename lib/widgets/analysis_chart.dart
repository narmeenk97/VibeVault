import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String label;
  final double value;
  ChartData(this.label, this.value);
}
class AnalysisChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final String title;

  const AnalysisChart({
    Key ? key,
    required this.labels,
    required this.values,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //convert the values into FlSpot objects
    List<ChartData> data= [];
    for (int i = 0; i < values.length; i++) {
      data.add(ChartData(labels[i], values[i]));
    }
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display the chart title using your app's theme.
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.deepPurple[900]),
          ),
          Expanded(
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(
                labelRotation: 45,
                title: AxisTitle(text: 'Date', textStyle: TextStyle(color: Colors.deepPurple[900])),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Intensity', textStyle: TextStyle(color: Colors.deepPurple[900]),),
              ),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: data,
                  xValueMapper: (ChartData datum, _) => datum.label,
                  yValueMapper: (ChartData datum, _) => datum.value,
                  color: Colors.deepPurple,
                  markerSettings: MarkerSettings(isVisible: true, color: Colors.deepPurple),
                  width: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}