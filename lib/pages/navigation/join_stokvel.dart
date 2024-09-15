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

class _JoinStokvelState extends State<JoinStokvel> {
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
                                String stokvelName =
                                    stokvelsController.stokvels[index]["name"];
                                String joiningFee =
                                    "${stokvelsController.stokvels[index]["joining_fee"]}";
                                String numberOfMembers =
                                    "${stokvelsController.stokvels[index]["members"].length}";
                                return _buildStokvelItem(
                                    stokvelName: stokvelName,
                                    joiningFee: joiningFee,
                                    numberOfMembers: numberOfMembers);
                              },
                            )))
        ],
      ),
    );
  }

  Widget _buildStokvelItem({
    required String stokvelName,
    required String joiningFee,
    required String numberOfMembers,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () async => await _joinStokvel(stokvelName: stokvelName),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              const BoxShadow(color: Colors.black26, blurRadius: 8.0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stokvelName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Joining Fee: $joiningFee',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Members: $numberOfMembers',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _joinStokvel({required String stokvelName}) async {
    await showGetMessageDialog(
        tittle: "Join stokvel?",
        message: "Are you sure you want to join $stokvelName?",
        yes: _yes);

    if (!appController.proceed) return;

    getCircularProgressIndicator();

    try {
      final joinStokvel = functions.httpsCallable("joinStokvel");
      final result = await joinStokvel.call({"stokvelName": stokvelName});

      Get.back();
      await showGetMessageDialog(
          tittle: result.data["status"], message: result.data["message"]);
    } on FirebaseFunctionsException catch (e) {
      Get.back();
      await showGetMessageDialog(tittle: "Error", message: e.message!);
    }

    appController.setProceed(value: false);
  }

  void _yes() {
    appController.setProceed(value: true);
    Get.back();
  }
}
