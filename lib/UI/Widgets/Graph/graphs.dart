import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget chartToRunLine(Map<String, dynamic> data) {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();

  List<double> monthlyData = List.filled(12, 0.0);
  List<String> monthlyLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  SharedPreferences.getInstance().then((prefs) {
    String? monthlyDataJson = prefs.getString('monthlyData');
    if (monthlyDataJson != null) {
      List<dynamic> monthlyDataList = json.decode(monthlyDataJson);
      for (int i = 0; i < monthlyDataList.length; i++) {
        monthlyData[i] = monthlyDataList[i] as double;
      }
    }
  });

  chartData = ChartData(
    dataRows: [monthlyData],
    xUserLabels: monthlyLabels,
    dataRowsLegends: ['Monthly Data'],
    chartOptions: chartOptions,
  );

  var lineChartContainer = LineChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var lineChart = LineChart(
    painter: LineChartPainter(
      lineChartContainer: lineChartContainer,
    ),
  );
  return lineChart;
}

Widget chartToRunVertical(Map<String, dynamic> data) {
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;
  ChartData chartData;
  ChartOptions chartOptions = const ChartOptions();

  List<double> weeklyData = List.filled(7, 0.0);
  List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  print('Graph Data: $data');
  SharedPreferences.getInstance().then((prefs) {
    String? weeklyDataJson = prefs.getString('weeklyData');
    if (weeklyDataJson != null) {
      Map<String, dynamic> weeklyDataMap = json.decode(weeklyDataJson);
      for (int i = 0; i < weekDays.length; i++) {
        if (weeklyDataMap.containsKey(weekDays[i])) {
          weeklyData[i] = weeklyDataMap[weekDays[i]] as double;
        }
      }
    }
  });

  chartData = ChartData(
    dataRows: [weeklyData],
    xUserLabels: weekDays,
    dataRowsLegends: ['Weekly Data'],
    chartOptions: chartOptions,
  );

  var verticalBarChartContainer = VerticalBarChartTopContainer(
    chartData: chartData,
    xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
  );

  var verticalBarChart = VerticalBarChart(
    painter: VerticalBarChartPainter(
      verticalBarChartContainer: verticalBarChartContainer,
    ),
  );
  return verticalBarChart;
}
