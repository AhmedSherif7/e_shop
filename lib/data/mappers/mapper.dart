const String emptyString = '';
const int zeroInt = 0;
const double zeroDouble = 0.0;
const bool falseValue = false;

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return '';
    }
    return this!;
  }
}

extension NonNullInteger on int? {
  int orEmpty() {
    if (this == null) {
      return 0;
    }
    return this!;
  }
}

extension NonNullDouble on double? {
  double orEmpty() {
    if (this == null) {
      return 0.0;
    }
    return this!;
  }
}

extension NonNullBoolean on bool? {
  bool orEmpty() {
    if (this == null) {
      return false;
    }
    return this!;
  }
}
