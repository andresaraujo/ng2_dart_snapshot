library angular2.src.change_detection.coalesce;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, looseIdentical;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map;
import "proto_record.dart" show RecordType, ProtoRecord;

/**
 * Removes "duplicate" records. It assuming that record evaluation does not
 * have side-effects.
 *
 * Records that are not last in bindings are removed and all the indices
 * of the records that depend on them are updated.
 *
 * Records that are last in bindings CANNOT be removed, and instead are
 * replaced with very cheap SELF records.
 */
List<ProtoRecord> coalesce(List<ProtoRecord> records) {
  List<ProtoRecord> res = [];
  Map<num, num> indexMap = new Map<num, num>();
  for (var i = 0; i < records.length; ++i) {
    var r = records[i];
    var record = _replaceIndices(r, res.length + 1, indexMap);
    var matchingRecord = _findMatching(record, res);
    if (isPresent(matchingRecord) && record.lastInBinding) {
      res.add(_selfRecord(record, matchingRecord.selfIndex, res.length + 1));
      indexMap[r.selfIndex] = matchingRecord.selfIndex;
      matchingRecord.referencedBySelf = true;
    } else if (isPresent(matchingRecord) && !record.lastInBinding) {
      if (record.argumentToPureFunction) {
        matchingRecord.argumentToPureFunction = true;
      }
      indexMap[r.selfIndex] = matchingRecord.selfIndex;
    } else {
      res.add(record);
      indexMap[r.selfIndex] = record.selfIndex;
    }
  }
  return res;
}
ProtoRecord _selfRecord(ProtoRecord r, num contextIndex, num selfIndex) {
  return new ProtoRecord(RecordType.SELF, "self", null, [], r.fixedArgs,
      contextIndex, r.directiveIndex, selfIndex, r.bindingRecord,
      r.expressionAsString, r.lastInBinding, r.lastInDirective, false, false);
}
_findMatching(ProtoRecord r, List<ProtoRecord> rs) {
  return ListWrapper.find(rs,
      (rr) => !identical(rr.mode, RecordType.DIRECTIVE_LIFECYCLE) &&
          _sameDirIndex(rr, r) &&
          identical(rr.mode, r.mode) &&
          looseIdentical(rr.funcOrValue, r.funcOrValue) &&
          identical(rr.contextIndex, r.contextIndex) &&
          looseIdentical(rr.name, r.name) &&
          ListWrapper.equals(rr.args, r.args));
}
bool _sameDirIndex(ProtoRecord a, ProtoRecord b) {
  var di1 = isBlank(a.directiveIndex) ? null : a.directiveIndex.directiveIndex;
  var ei1 = isBlank(a.directiveIndex) ? null : a.directiveIndex.elementIndex;
  var di2 = isBlank(b.directiveIndex) ? null : b.directiveIndex.directiveIndex;
  var ei2 = isBlank(b.directiveIndex) ? null : b.directiveIndex.elementIndex;
  return identical(di1, di2) && identical(ei1, ei2);
}
_replaceIndices(ProtoRecord r, num selfIndex, Map<dynamic, dynamic> indexMap) {
  var args = ListWrapper.map(r.args, (a) => _map(indexMap, a));
  var contextIndex = _map(indexMap, r.contextIndex);
  return new ProtoRecord(r.mode, r.name, r.funcOrValue, args, r.fixedArgs,
      contextIndex, r.directiveIndex, selfIndex, r.bindingRecord,
      r.expressionAsString, r.lastInBinding, r.lastInDirective,
      r.argumentToPureFunction, r.referencedBySelf);
}
_map(Map<dynamic, dynamic> indexMap, num value) {
  var r = indexMap[value];
  return isPresent(r) ? r : value;
}
