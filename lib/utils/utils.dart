// CIRCULAR PROGRESS INDICATOR
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/utils/neubox.dart';
import 'package:stokvel_go/utils/theme_data.dart';

// double textfieldWidth = 310.0;
const double h1 = 30.0;
const double h2 = 22.0;
const double h3 = 15.0;
const double h4 = 12.0;

Widget spacer1() => const SizedBox(height: 50.0);
Widget spacer2() => const SizedBox(height: 30.0);
Widget spacer3() => const SizedBox(height: 10.0);

TextStyle contentTextStyle({
  double fontSize = h3,
  FontWeight fontWeight = FontWeight.normal,
  Color fontColor = dark_fonts_grey}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: fontColor
  );
}

// APPBAR
AppBar appBar() => AppBar(
    elevation: 0.0,
    backgroundColor: offwhite_background,
  );
  

// CIRCULAR PROGRESS INDICATOR
Future<void> showCircularProgressIndicator({required BuildContext context}) async => showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return const AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: dark_fonts_grey,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Please wait...',
                      style: TextStyle(
                        color: dark_fonts_grey,
                        fontWeight: FontWeight.w600,
                        fontSize: h2
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
    );


Future<void> getCircularProgressIndicator() async
{
  return Get.defaultDialog(
    radius: 8.0,
    backgroundColor: Colors.white,
    barrierDismissible: false,
    title: 'Please wait',
    titleStyle: contentTextStyle(),
    titlePadding: const EdgeInsets.all(10.0),
    content: const SizedBox(
      width: 300.0,
      child: Center(
        child: CircularProgressIndicator(
          color: dark_fonts_grey,
        ),
      ),
    ),
    contentPadding: const EdgeInsets.all(20.0),
  );
}


// G E T    D I A L O G S
const double borderRadius = 8.0;
Row _dialogHeading(String tittle) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.info_outline,
        size: 30.0,
      ),
      const SizedBox(width: 10.0),
      Text(
        tittle,
        style: contentTextStyle(),
      ),
    ],
  );

// ALERT DIALOG
Future<void> showMyDialog(BuildContext buildContext, title, message) async => showDialog(
      context: buildContext,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          icon: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: h1,
              fontWeight: FontWeight.bold,
              color: dark_fonts_grey
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: h3,
                    color: dark_fonts_grey
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h2,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );


Future<void> showGetMessageDialog(String tittle, String message)
{
  return Get.defaultDialog(
    radius: borderRadius,
    backgroundColor: Colors.white,
    barrierDismissible: false,
    title: '',
    titlePadding: const EdgeInsets.all(0.0),
    titleStyle: const TextStyle(fontSize: 0.0),
    content: Column(
      children: [
        _dialogHeading(tittle),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: contentTextStyle()
          ),
        ),
      ],
    ),
    contentPadding: const EdgeInsets.all(10.0),
    cancel: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              'Back',
              style: contentTextStyle(
                fontWeight: FontWeight.bold,
                fontColor: Colors.lightBlue
              ),
            ),
          )
        ],
      )
    ),
  );
}

