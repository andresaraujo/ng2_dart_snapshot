library angular2.src.di.opaque_token;

class OpaqueToken {
  final String _desc;
  const OpaqueToken(String desc) : _desc = "Token(" + desc + ")";
  String toString() {
    return this._desc;
  }
}
