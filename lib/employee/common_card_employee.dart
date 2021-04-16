import 'package:flutter/material.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/widgetproperties.dart';

class CommonCardEmployee extends StatelessWidget {
  final Widget nextScreen;
  final IconData icon;
  final String title;
  final String text;

  var _decoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        15.0,
      ),
      border: Border.all(width: 1.5, color: AppColors.primaryColor),
      shape: BoxShape.rectangle);

  CommonCardEmployee({this.nextScreen, this.icon, this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetProperties.goToNextPage(context, nextScreen);
      },
      child: Container(
        width: WidgetProperties.screenWidth(context) * .5,
        height: WidgetProperties.screenHeight(context) * .20,
        decoration: _decoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: AppColors.primaryColor,
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: [
                  Textview2(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    title: title,
                    color: AppColors.primaryColor,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Textview2(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      title: text,
                      color: AppColors.primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
