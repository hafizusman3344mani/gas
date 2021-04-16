import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_station/common/text_view.dart';
import 'package:gas_station/utils/colors.dart';
import 'package:gas_station/utils/values.dart';
import 'package:gas_station/utils/widgetproperties.dart';

class FormInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String errorText;
  final Color hintColor;
  final Function onSaved;
  final Function onChanged;
  final bool obsecureText;
  final int maxLength;
  final TextInputFormatter formatter;
  final TextEditingController myController;
  final FocusNode focusNode;
  final Widget prefixIxon;
  final bool enabled;
  final TextInputType textInputType;

  FormInput(
      {this.hint,
        this.errorText,
        this.prefixIxon,
        this.hintColor,
        this.textInputType,
        this.icon,
        this.onSaved,
        this.onChanged,
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
              child: Row(
                children: [
                 icon!=null?Padding(
                   padding: const EdgeInsets.only(left:2.0,right: 2),
                   child: Icon(icon,size: 24,color: AppColors.primaryColor,),
                 ):Text(''),
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        prefixIcon: prefixIxon,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: hint,
                        hintStyle: WidgetProperties.textStyleInputFiled,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.textWhiteColor, width: 1.0),
                        ),
                        counter: Offstage(),
                      ),
                      obscureText: obsecureText,
                      maxLength: maxLength,
                      inputFormatters: <TextInputFormatter>[formatter],
                      controller: myController,
                      onFieldSubmitted: onSaved,
                      onChanged: onChanged,
                      enabled: enabled,
                    ),
                  ),
                ],
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
