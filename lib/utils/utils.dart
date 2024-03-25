// CIRCULAR PROGRESS INDICATOR
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/pages/onboarding/login.dart';
import 'package:stokvel_go/utils/neubox.dart';
import 'package:stokvel_go/utils/theme_data.dart';

// double textfieldWidth = 310.0;
const double h1 = 30.0;
const double h2 = 22.0;
const double h3 = 15.0;
const double h4 = 12.0;

Widget spacer1() => const Gap(60.0);
Widget spacer2() => const Gap(40.0);
Widget spacer3() => const Gap(20.0);
Widget spacer4() => const Gap(10.0);
Widget spacer5() => const Gap(5.0);

TextStyle contentTextStyle({
  double fontSize = h3,
  FontWeight fontWeight = FontWeight.normal,
  Color fontColor = dark_fonts_grey,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: fontColor
  );
}

Text contentText({
  double fontSize = h3,
  FontWeight fontWeight = FontWeight.normal,
  Color fontColor = dark_fonts_grey,
  TextAlign textAlign = TextAlign.center,
  required String data
}) {
  return Text(
    data,
    textAlign: textAlign,
    style: contentTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontColor: fontColor
    ),
  );
}

// APPBAR
AppBar appBar() => AppBar(
    elevation: 0.0,
    backgroundColor: light_neumorphic_blue,
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


Future<void> getCircularProgressIndicator() async {
  return Get.defaultDialog(
    radius: 8.0,
    backgroundColor: white,
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


// G E T    D I A L O G 

const double borderRadius = 8.0;

Container _dialogHeading(String tittle) 
{
  IconData iconData = tittle == "Error" 
    ? Icons.error_outline_outlined 
    : tittle == "Success" 
      ? Icons.check_circle_outline_rounded
      : Icons.info_outline_rounded;
  
  Color tittleColor = tittle == "Error" 
    ? Colors.red 
    : tittle == "Success" 
      ? Colors.green
      : Colors.blue;
  
  return Container(
    color: tittleColor, 
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 50.0, 
          color: white,
        ),
        spacer4(),
        Text(
          tittle,
          style: contentTextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: h2, 
            fontColor: white
          ),
        ),
      ],
    ),
  );
}

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

// MESSAGE DIALOG
Future<void> showGetMessageDialog({
  String? tittle, 
  required String message, 
  VoidCallback? yes, 
}) {
  return Get.defaultDialog(
    radius: borderRadius, 
    backgroundColor: white,
    barrierDismissible: false,
    title: "", 
    titlePadding: const EdgeInsets.all(0.0),
    titleStyle: const TextStyle(fontSize: 0.0),
    content: Column(
      children: [
        _dialogHeading(tittle ?? "Info"),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message, 
            textAlign: TextAlign.center, 
            style: contentTextStyle()
          ),
        ),
      ],
    ),
    contentPadding: const EdgeInsets.all(10.0),
    // confirm
    confirm: yes == null ? null : Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: yes,
        child: Text(
          "Yes",
          style: contentTextStyle(
            fontWeight: FontWeight.bold,
            fontColor: Colors.lightGreen
          ),
        ),
      )
    ), 
    // cancel
    cancel: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Text(
          yes == null ? "Back" : "No",
          style: contentTextStyle(
            fontWeight: FontWeight.bold,
            fontColor: yes == null 
              ? Colors.lightBlue 
              : Colors.redAccent
          ),
        ),
      )
    ),
  );
}


// RETRIEVING DATA
Column retrievingData({String? message}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Center(child: CircularProgressIndicator()),
      spacer2(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message ?? "Retrieving data...",
          textAlign: TextAlign.center,
          style: contentTextStyle(
            fontColor: primary_blue,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    ],
  );
}

// ERROR
Widget error404({String? message}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: appController.hsp),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage("assets/icons/cloud.png"),
          fit: BoxFit.cover, 
          width: appController.screenHeight * 0.20,
        ),
        spacer1(),
        Text(
          message ?? "Oops! Something went wrong. Please ensure you have an internet connection.",
          textAlign: TextAlign.center,
          style: contentTextStyle(
            fontColor: primary_blue, 
            fontWeight: FontWeight.bold
          )
        )
      ],
    ),
  );
}

// NOTHING
Column nothing() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image(
        image: const AssetImage("assets/icons/file.png"),
        width: appController.screenWidth * 0.50,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text("Nothing to show here.",
          style: contentTextStyle(
              fontColor: primary_blue, 
              fontWeight: FontWeight.bold
            )
        ),
      )
    ],
  );
}



// form data field
Widget formDataField({
  required TextEditingController fieldController,
  required String lableText,
  required TextInputType textInputType,
  double? width
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
    width: width ?? appController.widgetWidth,
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(borderRadius)
    ),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {return 'Please enter some text';}
        return null;
      },
      controller: fieldController,
      style: contentTextStyle(),
      decoration: InputDecoration(
        labelText: lableText,
        labelStyle: contentTextStyle(
          fontColor: primary_blue,
          fontSize: h4
        ),
      ),
      keyboardType: textInputType,
    ),
  );
}

// neubox
const double neuBoxDistance = 5.0;

Widget neuBox({
  VoidCallback? onTap,
  Color? color,
  EdgeInsets? edgeInsets,
  bool wide = false,
  required Widget child,
}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: Container(
      decoration: BoxDecoration(
        color: color ?? light_neumorphic_blue,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          // lighter shdow on top left
          BoxShadow(
            color: white,
            offset: Offset(-neuBoxDistance, -neuBoxDistance),
            blurRadius: 7.0,
          ),
          // darker shdow on bottom right
          BoxShadow(
            color: dark_neumorphic_blue,
            offset: Offset(neuBoxDistance, neuBoxDistance),
            blurRadius: 7.0
          ),
        ]
      ),
      padding: edgeInsets ?? const EdgeInsets.all(12.0),
      child: wide 
        ? SizedBox(
            width: appController.widgetWidth,
            child: child
          ) 
        : child,
    ),
  );
}

Divider get divider => Divider(
  color: white,
  endIndent: appController.hsp,
);

