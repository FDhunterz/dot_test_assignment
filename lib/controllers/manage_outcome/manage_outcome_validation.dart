part of 'manage_outcome_controller.dart';

extension ManageOutcomeValidation on ManageOutcomeController {
  validateAll() {
    if (nama?.text.isEmpty ?? true) {
      return false;
    }

    if (typeC?.text.isEmpty ?? true) {
      return false;
    }

    if (tanggalC?.text.isEmpty ?? true) {
      return false;
    }

    if (nominal?.text.isEmpty ?? true) {
      return false;
    }

    return true;
  }
}
