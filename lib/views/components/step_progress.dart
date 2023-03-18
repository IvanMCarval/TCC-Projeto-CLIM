import 'package:flutter/material.dart';
import 'package:flutter_application_project_clim/shared/themes/app_colors.dart';

class StepProgressView extends StatefulWidget {
  final double width;
  final int totalSteps;
  final int curStep;

  const StepProgressView(
      {Key? key,
      required this.curStep,
      required this.width,
      required this.totalSteps})
      : assert(curStep > 0 == true && curStep <= totalSteps),
        assert(width > 0),
        super(key: key);

  @override
  State<StepProgressView> createState() => _StepProgressViewState();
}

class _StepProgressViewState extends State<StepProgressView> {
  final double lineWidth = 4.0;

  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 43.0,
          left: 25.0,
          right: 25.0,
        ),
        width: widget.width,
        child: Column(
          children: <Widget>[
            Row(
              children: iconViews(),
            ),
          ],
        ));
  }

  List<Widget> iconViews() {
    var list = <Widget>[];
    for (var step = 1; step <= widget.totalSteps; step++) {
      //colors according to state
      var circleColor = (step == 1 || widget.curStep >= step)
          ? AppColors.green
          : AppColors.background;

      var lineColor =
          widget.curStep > step ? AppColors.green : AppColors.ligthGreen;

      var colorNumber = (step == 1 || widget.curStep >= step)
          ? AppColors.background
          : AppColors.green;
      list.add(
        //dot with icon view
        Container(
          width: 40.0,
          height: 40.0,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(
              color: AppColors.green,
              width: 2.0,
            ),
          ),
          child: (step < widget.curStep)
              ? Icon(
                  Icons.check,
                  color: AppColors.background,
                  size: 20.0,
                )
              : Center(
                  child: Text(
                    "$step",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Poppins',
                      color: colorNumber,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      );

      //line between icons
      if (step != widget.totalSteps) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    }

    return list;
  }
}
