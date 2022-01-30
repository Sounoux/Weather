class PhoneType {
  final String _phoneType;
  PhoneType._(this._phoneType);
  factory PhoneType.create(String phoneType) {
    if (phoneType.isEmpty) {
      throw AssertionError('Invalid mobile number');
    }
    if (phoneType.length > 10) {
      throw AssertionError('Le numéro contient trop de chiffres');
    }
    if (phoneType.length > 10) {
      throw AssertionError('Le numéro ne contient pas assez de chiffres');
    }
    /*if(int.tryParse(phoneType) = null) {
      throw AssertionError('Le numéro ne devrait contenir que des chiffres')
    }*/
    return PhoneType._(phoneType);
  }
}
