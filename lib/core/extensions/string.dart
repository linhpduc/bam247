
extension StringExtension on String {

  bool get isValidUrl {
    final regex = RegExp(
        r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:\/?#[\]@!\$&'\(\)\*\+,;=.]+$");
    return regex.hasMatch(this);
  }

  bool parseBool() {
    return toLowerCase() == "true";
  }

  bool get isOnlyNumber {
    RegExp regex = RegExp(r'^\d*\.?\d*$');
    return regex.hasMatch(this);
  }

  String get toUpperCaseFirst {
    if (length > 0) {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
    return this;
  }

  bool get isValidEmail {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regex.hasMatch(this);
  }

  bool get isValidPhone {
    RegExp regex = RegExp(r'^([0-9]{9,13}$)');
    return regex.hasMatch(this);
  }

  String fileName() {
    if (!isValidUrl) return this;
    return substring(lastIndexOf('/') + 1);
  }

  bool isStorage() => RegExp(r'^\/(storage|data|blob)[^\.]').hasMatch(this);

  bool isWebPicker() => startsWith('blob');

  bool isAssetsSvg() => startsWith('assets') && endsWith('.svg');

  bool isAssetsPng() => RegExp(r'^assets\/').hasMatch(this) && endsWith('.png');
}
