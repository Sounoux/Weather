class PasswordType {
  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    } else if (!password.contains(RegExp(r'[A-Z]')) &&
        !password.contains(RegExp(r'[0-9]')) &&
        !password.contains(RegExp(r'[a-z]')) &&
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Entrez un mot de passe plus fort';
    }
    return null;
  }
}
