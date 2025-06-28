// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';

void printGreen(dynamic msg) {
  if (kDebugMode) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(msg.toString())
        .map((match) => match.group(0))
        .forEach((m) => print('\x1B[32m$m\x1B[0m'));
  }
}

void printYellow(dynamic msg) {
  if (kDebugMode) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(msg.toString())
        .map((match) => match.group(0))
        .forEach((m) => print('\x1B[33m$m\x1B[0m'));
  }
}

void printPink(dynamic msg) {
  if (kDebugMode) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(msg.toString())
        .map((match) => match.group(0))
        .forEach((m) => print('\x1B[35m$m\x1B[0m'));
  }
}

void printRed(dynamic msg) {
  if (kDebugMode) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches(msg.toString())
        .map((match) => match.group(0))
        .forEach((m) => print('\x1B[31m$m\x1B[0m'));
  }
}
