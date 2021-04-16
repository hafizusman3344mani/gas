import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/loading.dart';



class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Loading(
              //    indicator: BallPulseIndicator(),
              indicator: BallScaleIndicator(),
              size: 100.0,
              color: AppColors.primaryColor)),
    );
  }


}
