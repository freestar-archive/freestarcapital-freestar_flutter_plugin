class FreestarUtils {

  //Use only for non-error callbacks
  static String? placement(String str) {
    if ((str.trim().isEmpty)) {
      return null;
    }
    return str.trim();
  }

  //Use only for error callbacks where str needs to be split
  static String? placementFromError(String str) {
    List<String> list = str.split("\\|");
    if (list.first.trim().isEmpty) {
      return null;
    } else {
      return list.first.trim();
    }
  }

  //Use only for error callbacks where str needs to be split
  static String errorMessageFromError(String str) {
    List<String> list = str.split("\\|");
    return list.last;
  }
}