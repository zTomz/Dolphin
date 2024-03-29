import 'dart:io';

extension FileSystemEntityExtension on FileSystemEntity {
  bool get isDirectory => this is Directory;
  String get name => path.split('\\').last;
}
