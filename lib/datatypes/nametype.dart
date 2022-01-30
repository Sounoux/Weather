import 'dart:core';

class NameType {
  final String _nameType;
  NameType._(this._nameType);
  factory NameType.create(String nameType) {
    if (nameType.isEmpty) {
      throw AssertionError('Invalid name');
    }
    if (nameType.length > 7) {
      throw AssertionError('Le nom contient trop de lettres');
    }
    if (nameType.length > 3) {
      throw AssertionError('Le nom ne contient pas assez de lettres');
    }
    return NameType._(nameType);
  }
}
