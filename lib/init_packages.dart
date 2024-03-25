import 'package:cloud_functions/cloud_functions.dart';
import 'package:stokvel_go/controllers/stokvels_controller.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';

final appController = AppController.instance;
final authController = AuthController.instance;
final stokvelsController = StokvelsController.instance;
final functions = FirebaseFunctions.instance;