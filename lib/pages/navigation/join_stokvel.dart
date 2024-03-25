import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stokvel_go/init_packages.dart';
import 'package:stokvel_go/utils/theme_data.dart';
import 'package:stokvel_go/utils/utils.dart';

class JoinStokvel extends StatefulWidget {
  const JoinStokvel({super.key});

  @override
  State<JoinStokvel> createState() => _JoinStokvelState();
}

class _JoinStokvelState extends State<JoinStokvel> 
{
  @override
  void initState() {
    stokvelsController.getStokvels();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), 
      body: Column(
        children: [
          spacer1(), 
          Obx(() => Expanded(
          child: stokvelsController.stokvelsLoading 
            ? retrievingData() 
            : stokvelsController.stokvelsError.isNotEmpty 
              ? error404(message: stokvelsController.stokvelsError)
              : stokvelsController.stokvels.isEmpty 
                ? nothing() 
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: stokvelsController.stokvels.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: appController.hsp, horizontal: appController.hsp),
                        child: neuBox(
                          onTap: () async => await _joinStokvel(stokvelName: stokvelsController.stokvels[index]["name"]),
                          color: purple,
                          child: Text(
                            stokvelsController.stokvels[index]["name"], 
                            style: contentTextStyle(
                              fontColor: white
                            ),
                          ) 
                        )
                      );
                    },
                  )
        )) 
        ],
      ),
    );
  }

  Future<void> _joinStokvel({required String stokvelName}) async {
    await showGetMessageDialog(
      tittle: "Join stokvel?",
      message: "Are you sure you want to join $stokvelName?", 
      yes: _yes
    );

    if (!appController.proceed) return;

    getCircularProgressIndicator();

    try {
      final joinStokvel = functions.httpsCallable("joinStokvel");
      final result = await joinStokvel.call({"stokvelName": stokvelName});

      Get.back();
      await showGetMessageDialog(
        tittle: result.data["status"],
        message: result.data["message"]
      );
    } on FirebaseFunctionsException catch (e) {
      Get.back();
      await showGetMessageDialog(
        tittle: "Error",
        message: e.message!
      );
    }

    appController.setProceed(value: false);
  }

  void _yes() {
    appController.setProceed(value: true);
    Get.back();
  }
}