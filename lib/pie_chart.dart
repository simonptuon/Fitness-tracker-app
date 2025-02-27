import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

const _toRadians = math.pi / 100.0;

class PieChart extends StatelessWidget{
  final List<int> values;
  final List<Color> colors;

  const PieChart({
    Key key,
    @required this.values,
    this.colors,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: CustomPaint(
              painter: PieChartPainter(values: colors),
            ),
        ),
      ],
    );
  }
}

