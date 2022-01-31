class PhoneType {
  static String? validatePhone({required String? phone}) {
    if (phone == null) {
      return null;
    }

    if (phone.isEmpty) {
      return 'Phone can\'t be empty';
    } else if (phone.length < 10) {
      return 'Le numéro ne contient pas assez de chiffres';
    } else if (phone.length > 10) {
      return 'Le numéro contient trop de chiffres';
    }

    return null;
  }
}
