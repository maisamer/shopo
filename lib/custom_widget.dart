import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomWidget {
  static Widget buildFormInputText(
      {TextEditingController controller,
      String hint = '',
      String label,
      String errorMessage,
      RegExp expression,
      String valueResult,
      String expErrorMessage,
      int maxLength,
      double maxValue,
      double minValue,
      bool isPassword = false,
      TextInputType inputType = TextInputType.text,
      bool isEnabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
        SizedBox(height: 10,),
        TextFormField(
            controller: controller,
            enabled: isEnabled,
            maxLength: maxLength,
            obscureText: isPassword,
            keyboardType: inputType,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[900]),
                borderRadius: BorderRadius.circular(10)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green[900],width: 0.8),
                  borderRadius: BorderRadius.circular(10)
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300],width: 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              hintText: hint,
            ),
            validator: (String value) {
              if (errorMessage != null) {
                if (value.isEmpty) {
                  return errorMessage;
                }
              }
              if (value.isNotEmpty &&
                  expression != null &&
                  !expression.hasMatch(value)) {
                return expErrorMessage;
              }
              if (maxValue != null && minValue != null) {
                if (double.parse(value) > maxValue ||
                    double.parse(value) < minValue) {
                  return errorMessage;
                }
              }
              return null;
            })
      ],
    );
  }

  static buildButton(BuildContext context, Function onPress,
      {double size,
      String title,
      Color fontColor = Colors.black,
      FontWeight fontWeight = FontWeight.w300,
      double fontSize = 18,
      Color backgroundColor = Colors.white}) {
    return InkWell(
      onTap: () {
        onPress(context);
      },
      child: Container(
        width: size,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            border: Border.all(color: Color(0xFF0E7859)),
            color: backgroundColor),
        child: Text(
          title,
          style: TextStyle(
              color: fontColor, fontWeight: fontWeight, fontSize: fontSize),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  static Widget buildSpinner(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 0.75*size.height ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitRing(
            color: Colors.black,
            size: 200.0,
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Text("Loading"),
          )
        ],
      ),
    );
  }
}
