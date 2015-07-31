library angular2.src.router.helpers;

import "package:angular2/src/facade/lang.dart" show isPresent;

void parseAndAssignParamString(
    String splitToken, String paramString, Map<String, String> keyValueMap) {
  var first = paramString[0];
  if (first == "?" || first == ";") {
    paramString = paramString.substring(1);
  }
  paramString.split(splitToken).forEach((entry) {
    var tuple = entry.split("=");
    var key = tuple[0];
    if (!isPresent(keyValueMap[key])) {
      var value = tuple.length > 1 ? tuple[1] : true;
      keyValueMap[key] = value;
    }
  });
}
