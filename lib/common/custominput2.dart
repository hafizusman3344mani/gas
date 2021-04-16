import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/values.dart';
import 'package:gas_station/utils/widgetproperties.dart';

class FormInput2 extends StatelessWidget {
  final String hint;
  final String errorText;
  final Color hintColor;
  final Function onSaved;
  final Function onPressed;
  final IconData iconData;
  final bool obsecureText;
  final int maxLength;
  final TextInputFormatter formatter;
  final TextEditingController myController;
  final FocusNode focusNode;
  final bool enabled;

  FormInput2(
      {this.hint,
      this.errorText,
      this.hintColor,
      this.onSaved,
      this.onPressed,
      this.iconData,
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
      child: Column(
        children: [
          TextFormField(
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            style: WidgetProperties.textStyleInputFiled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: WidgetProperties.textStyleInputFiled,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.0),
              ),
              border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: errorText == null || errorText.isEmpty
                    ? BorderSide(
                        color: Colors.grey.withOpacity(0.7), width: 2.0)
                    : BorderSide(
                        color: Colors.red.withOpacity(0.7), width: 2.0),
              ),
              counter: Offstage(),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                splashColor: AppColors.primaryColor.withOpacity(0.5),
                splashRadius: 18.0,
                onPressed: onPressed,
                icon: Icon(
                  iconData,
                  color: Colors.grey,
                  size: 18.0,
                ),
              ),
            ),
            obscureText: obsecureText,
            maxLength: maxLength,
            inputFormatters: <TextInputFormatter>[formatter],
            controller: myController,
            onSaved: onSaved,
            onChanged: onSaved,
            enabled: enabled,
          ),
          if (errorText != null)
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
    );
  }
}
