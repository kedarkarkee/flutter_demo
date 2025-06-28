import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:demo/core/logger/logger.dart';

// Copied from pretty_http_logger

class HttpLogger {
  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');

  /// percentage of width the logger takes to print, defaults to 90
  final int maxWidth = 90;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  static const int initialTab = 1;

  static const String tabStep = '    ';

  /// whether the print will be compact or not, defaults to true
  final bool compact = true;

  HttpLogger();

  void logResponse(dynamic body) {
    final responseHeaders = <String, String>{};
    // data.headers?.forEach((k, list) => responseHeaders[k] = list.toString());
    _printMapAsTable(responseHeaders, header: 'Headers');
    printYellow('╔ Body');
    printYellow('║');
    _printResponse(body);
    printYellow('║');
    _printLine('╚');
  }

  void logError(error) {
    _printBoxed(header: 'Error', text: '$error');
  }

  static void prettyPrintJson(String? input) {
    var object = decoder.convert(input ?? '');
    var prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((element) => printGreen(element));
  }

  void _printBoxed({String? header, String? text}) {
    printRed('');
    printRed('╔╣ $header');
    printRed('║  $text');
    _printLine('╚');
  }

  void _printResponse(dynamic body) {
    try {
      if (body is Map) {
        _printPrettyMap((body));
      } else if ((body) is Uint8List) {
        printPink('║${_indent()}[');
        _printUint8List((body));
        printPink('║${_indent()}]');
      } else if ((body) is List) {
        printPink('║${_indent()}[');
        _printList((body));
        printPink('║${_indent()}]');
      } else {
        _printBlock(body.toString());
      }
    } catch (e) {
      _printBlock(body.toString());
    }
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      printRed('$pre${'═' * maxWidth}$suf');

  void _printKV(String key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      printRed(pre);
      _printBlock(msg);
    } else {
      printRed('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    var lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      printRed(
        (i >= 0 ? '║ ' : '') +
            msg.substring(
              i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length),
            ),
      );
    }
  }

  String _indent([int tabCount = initialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int tabs = initialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    final isRoot = tabs == initialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) printRed('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, key) {
      final isLast = index == data.length - 1;
      var value = data[key];
      //      key = '\"$key\"';
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'(\r|\n)+'), " ")}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value)) {
          printGreen('║${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
        } else {
          printGreen('║${_indent(tabs)} $key: {');
          _printPrettyMap(value, tabs: tabs);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value)) {
          printGreen('║${_indent(tabs)} $key: ${value.toString()}');
        } else {
          printGreen('║${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs);
          printGreen('║${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length;
        if (msg.length + indent.length > linWidth) {
          var lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            printGreen(
              '║${_indent(tabs)} ${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}',
            );
          }
        } else {
          printGreen('║${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
        }
      }
    });

    printRed('║$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  void _printUint8List(Uint8List list, {int tabs = initialTab}) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    for (var element in chunks) {
      printGreen('║${_indent(tabs)} ${element.join(", ")}');
    }
  }

  void _printList(List list, {int tabs = initialTab}) {
    list.asMap().forEach((i, e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e)) {
          printGreen('║${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(e, tabs: tabs + 1, isListItem: true, isLast: isLast);
        }
      } else {
        printGreen('║${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  bool _canFlattenMap(Map map) {
    return map.values.where((val) => val is Map || val is List).isEmpty &&
        map.toString().length < maxWidth;
  }

  bool _canFlattenList(List list) {
    return (list.length < 10 && list.toString().length < maxWidth);
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    printRed('╔ $header ');
    map.forEach((key, value) => _printKV(key, value));
    _printLine('╚');
  }
}
