import 'package:dot_test/controllers/main_controller.dart';
import 'package:handlerz/handlerz.dart';

part 'auth_event.dart';

class AuthController extends HandlerzController<AuthController> {
  AuthController._state() : super(MainController.state.handlerz);

  static final state = AuthController._state();

  void route() async {
    // MainController.state.pushAndRemoveAll(routePath)
  }
}
