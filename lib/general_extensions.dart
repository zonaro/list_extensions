import 'package:innerlibs/innerlibs.dart';

extension ObjectExtensions on dynamic {
  // return a string of this object as a SQL Value
  String get asSqlValue {
    if (this == null) {
      return 'NULL';
    } else if (this is num) {
      return toString();
    } else if (this is bool) {
      return this == true ? "1" : "0";
    } else {
      return "'${this?.toString().replaceAll("'", "''")}'";
    }
  }

  /// Checks if [this] is a Blank value:
  ///( Null, empty or only white spaces for [String], 0 for [num] , [DateExtension.min] for [DateTime], Call [isBlank] recursively on [List] or [Map] values. Other class types, call [ToString()] and check ).
  bool get isBlank {
    if (this == null) {
      return true;
    }
    if (this is String) {
      return (this as string).trim().isEmpty;
    }
    if (this is num) {
      return this == 0;
    }
    if (this is DateTime) {
      return (this as DateTime) == DateExtensions.min;
    }
    if (this is Iterable) {
      var l = (this as Iterable).toList();
      return l.isEmpty || l.where((x) => x.isBlank).isEmpty;
    }
    if (this is Map) {
      var m = (this as Map);
      return m.isEmpty || m.values.isBlank;
    }

    return ToString().isBlank;
  }

  /// Checks if the `String` is not blank (null, empty or only white spaces).
  bool get isNotBlank => !isBlank;

  bool asBool({bool everythingIsTrue = true}) => asNullableBool(everythingIsTrue: everythingIsTrue) ?? false;

  bool? asNullableBool({bool everythingIsTrue = true}) {
    if (this == null) return null;
    var x = '$this'.toUpperCase().removeDiacritics();
    switch (x) {
      case 'NULL':
      case 'CANCEL':
      case 'CANCELAR':
        return null;
      case '':
      case '!':
      case '0':
      case 'FALSE':
      case 'NOT':
      case 'NAO':
      case 'NO':
      case 'NOP':
      case 'DISABLED':
      case 'DISABLE':
      case 'OFF':
      case 'DESATIVADO':
      case 'DESATIVAR':
      case 'DESATIVO':
      case 'N':
        return false;
      case '1':
      case 'S':
      case 'TRUE':
      case 'YES':
      case 'YEP':
      case 'SIM':
      case 'ENABLED':
      case 'ENABLE':
      case 'ON':
      case 'Y':
      case 'ATIVO':
      case 'ATIVAR':
      case 'ATIVADO':
        return true;
      default:
        return everythingIsTrue ? true : throw ArgumentError('The object does not represent a valid option and the EverythingIsTrue flag is set to false.');
    }
  }
}
