import 'package:flutter/material.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:re_highlight/styles/all.dart';

class EditorProvider extends ChangeNotifier {
  Map<String, TextStyle> _theme = atomOneDarkTheme;
  Map<String, TextStyle> get theme => _theme;
  set theme(Map<String, TextStyle> theme) {
    _theme = theme;
    notifyListeners();
  }

  Map<String, Map<String, TextStyle>> get themeList => builtinAllThemes;
}
