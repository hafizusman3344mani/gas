import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/values.dart';
import 'package:gas_station/utils/widgetproperties.dart';

class FormInput3 extends StatelessWidget {
  final String hint;
  final String initialValue;
  final String errorText;
  final Color hintColor;
  final Function onSaved;
  final bool obsecureText;
  final int maxLength;
  final TextInputFormatter formatter;
  final TextEditingController myController;
  final FocusNode focusNode;
  final bool enabled;
  final TextInputType textInputType;

  FormInput3(
      {
        this.initialValue,
        this.hint,
      this.errorText,
      this.hintColor,
      this.textInputType,
      this.onSaved,
      this.enabled,
      this.formatter,
      this.obsecureText,
      this.maxLength,
      this.myController,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 0.0, horizontal: AppValues.horizontalMarginForm),
      child: Container(
        height: 50.0,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue:initialValue ,
                focusNode: focusNode,
                keyboardType: textInputType,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                style: WidgetProperties.textStyleInputFiled,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: WidgetProperties.textStyleInputFiled,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.underlineColor, width: 2.0),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors.underlineColor, width: 2.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: errorText == null || errorText.isEmpty
                        ? BorderSide(
                            color: Colors.grey.withOpacity(0.7), width: 5.0)
                        : BorderSide(
                            color: Colors.red.withOpacity(0.7), width: 5.0),
                  ),
                  counter: Offstage(),
                ),
                obscureText: obsecureText,
                maxLength: maxLength,
                inputFormatters: <TextInputFormatter>[formatter],
                controller: myController,
                onSaved: onSaved,
                onChanged: onSaved,
                enabled: enabled,
              ),
            ),
            if (errorText == null || errorText.isEmpty)
              Container()
            else
              Container(
                alignment: Alignment.topLeft,
                child: Textview2(
                  fontSize: 12.0,
                  title: errorText,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              )
          ],
        ),
      ),
    );
  }
}
