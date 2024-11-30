import 'package:get/get.dart';

import '../../../core/utils/shared_pref_methods.dart';
class TutorialController extends GetxController {
  /// Observable to keep track of whether the tutorial has been shown.
  final RxBool hasSeenTutorial = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // Load the tutorial status when the controller is initialized
    await loadTutorialStatus();
  }

  /// Loads the tutorial status from persistent storage.
  Future<void> loadTutorialStatus() async {
    final status = await CacheUtils.checkTutorialStatus();
    hasSeenTutorial.value = status;
  }

  /// Marks the tutorial as seen and updates the persistent storage.
  Future<void> markTutorialAsSeen() async {
    hasSeenTutorial.value = true;
    await CacheUtils.updateHasSeenTutorialStatus(true);
  }
}
