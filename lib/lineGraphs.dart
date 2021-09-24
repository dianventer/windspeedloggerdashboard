import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartGraph extends StatefulWidget {
  const LineChartGraph({Key key, this.spots, this.metric}) : super(key: key);
  final String metric;
  final List<FlSpot> spots;

  @override
  LineChartGraphState createState() => LineChartGraphState();
}

class LineChartGraphState extends State<LineChartGraph> {
  String selectedJetson = "";
  bool hasSet = false;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  void initState() {
    super.initState();
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked =
        await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2019, 1), lastDate: DateTime(2111));
    if (picked != null) print(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          // alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white10),
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(
                    LineChartData(
                        lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (value) {
                            return value
                                .map((e) => LineTooltipItem(
                                    "${e.y < 0 ? '${widget.metric}:' : '${widget.metric}:'} ${e.y.toStringAsFixed(2)} \n Date: ${DateFormat('d MMM, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch((e.x * 1000).round()))}",
                                    TextStyle(color: Colors.black)))
                                .toList();
                          },
                          tooltipBgColor: Colors.white,
                        )),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          show: false,
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTitles: (value) {
                              if (value.toInt() % 5 == 0) {
                                return value.toString();
                              } else {
                                return '';
                              }
                            },
                            reservedSize: 28,
                            margin: 12,
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: widget.spots,
                            isCurved: false,
                            colors: gradientColors,
                            barWidth: 0.5,
                            // preventCurveOvershootingThreshold: 100,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                            ),
                            dotData: FlDotData(
                              show: false,
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
