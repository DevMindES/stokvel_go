import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class AppData extends ChangeNotifier
{
  double? _screenHeight;
  double? _screenWidth;
  double? _widgetWidth;

  static const double _mediumScreenWidth = 641.0;
  static const double _smallScreenWidth = 376.0;

  AppData({
    required double screenHeight,
    required double screenWidth,
  }) {
    _screenHeight = screenHeight;
    _screenWidth = screenWidth;
    _setWidgetWidth();
  }

  // double getScreenHeight() => _screenHeight!;
  double getWidgetWidth() => _widgetWidth!;

  void _setWidgetWidth()
  {
    if (_screenWidth! < _mediumScreenWidth) {
      _widgetWidth = 0.80 * _screenWidth!;
    } else {
      _widgetWidth = _mediumScreenWidth;
    }

    notifyListeners();
  }

  // TEXTFORM FIELD
  Widget formDataField({
    required TextEditingController fieldController,
    required String lableText,
    required TextInputType textInputType
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          width: _widgetWidth,
          decoration: BoxDecoration(
            color: Colors.white, //.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {return 'Please enter some text';}
              return null;
            },
            controller: fieldController,
            style: const TextStyle(
              fontSize: h3,
              color: dark_fonts_grey
            ),
            decoration: InputDecoration(
              labelText: lableText,
              labelStyle: const TextStyle(
                color: dark_fonts_grey
              ),
            ),
            keyboardType: textInputType,
          ),
        ),
      );
  }

  Widget neuBox({
    required VoidCallback onTap,
    required double? width,
    required Widget child,
  }) {
    const double distance = 5.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? _widgetWidth!,
        decoration: BoxDecoration(
          color: primary_blue,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            // lighter shdow on top left
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-distance, -distance),
              blurRadius: 8.0,
            ),
            // darker shdow on bottom right
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(distance, distance),
              blurRadius: 6.0
            ),
          ]
        ),
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}