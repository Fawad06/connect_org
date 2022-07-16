import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../utils/constants.dart';

class MyPercentIndicator extends StatelessWidget {
  const MyPercentIndicator({
    Key? key,
    required this.percent,
    this.centerChild,
    this.bottomChild,
    this.topChild,
    this.height = 120,
    this.width = 120,
  }) : super(key: key);
  final double percent;
  final Widget? centerChild;
  final Widget? bottomChild;
  final Widget? topChild;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (topChild != null) topChild!,
        if (topChild != null) kDefaultSpaceVerticalHalf,
        SizedBox(
          height: height,
          width: width,
          child: SfRadialGauge(
            axes: [
              RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                minimum: 0,
                maximum: 1,
                radiusFactor: 1,
                axisLineStyle: const AxisLineStyle(
                  thicknessUnit: GaugeSizeUnit.factor,
                  thickness: 0.12,
                ),
                annotations: <GaugeAnnotation>[
                  if (centerChild != null)
                    GaugeAnnotation(
                      angle: 180,
                      widget: centerChild!,
                    ),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                    value: percent,
                    cornerStyle: CornerStyle.bothCurve,
                    enableAnimation: true,
                    animationDuration: 1200,
                    animationType: AnimationType.ease,
                    sizeUnit: GaugeSizeUnit.factor,
                    gradient: SweepGradient(
                      colors: <Color>[
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                      stops: const <double>[0.25, 0.75],
                    ),
                    pointerOffset: -0.075,
                    color: Colors.white,
                    width: 0.3,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (bottomChild != null) kDefaultSpaceVerticalHalf,
        if (bottomChild != null) bottomChild!,
      ],
    );
  }
}
