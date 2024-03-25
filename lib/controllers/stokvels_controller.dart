import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import '../init_packages.dart';

class StokvelsController extends GetxController
{
  static StokvelsController instance = Get.find();

  final RxList<dynamic> _stokvels = [].obs;
  final RxBool _stokvelsLoading = false.obs;
  final RxString _stokvelsError = "".obs;


  Future<void> getStokvels() async {
    _stokvelsLoading.value = true;
    _stokvelsError.value = "";
    try {
      final getStokvels = functions.httpsCallable("getStokvels");
      final response = await getStokvels.call({"uid": authController.uid});
      _stokvels.value = List<dynamic>.from(response.data);
    } on FirebaseFunctionsException catch (e) {
      _stokvelsError.value = e.message!;
    }
    _stokvelsLoading.value = false;
  }


  List<dynamic> get stokvels => _stokvels;
  bool get stokvelsLoading => _stokvelsLoading.value;
  String get stokvelsError => _stokvelsError.value;


}