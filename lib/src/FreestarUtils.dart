
class FreestarUtils {

  static Map paramsFrom(String? placement, Map? targetingParams) {
    Map params = Map();
    if (placement != null && !placement.trim().isEmpty) {
      params["placement"] = placement;
    }
    if (targetingParams != null) {
      params["targetingParams"] = targetingParams;
    }
    return params;
  }

}