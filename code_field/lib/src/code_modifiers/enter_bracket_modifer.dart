import 'package:flutter/services.dart';

import '../../code_text_field.dart';

/// CodeModifier so when the user presses enter, and the last character
/// is a closing bracket [ } ] and the character before is an opening bracket [ { ]
/// it will add a new line and indent
///
/// This will look like this:
/// ```
/// void main() {|}
/// ```
/// 
/// The [ | ] shows where the cursor is located, when the user now presses enter
/// the code will look like this:
/// 
/// ```
/// void main() {
///   |
/// }
/// ```
class EnterBracketModifier extends CodeModifier {
  const EnterBracketModifier() : super('\n');

  @override
  TextEditingValue? updateString(
      String text, TextSelection sel, EditorParams params) {
    if (text.split('')[sel.end - 1] == '{' && text.split('')[sel.end] == '}') {
      return replace(
        text,
        sel.start,
        sel.end,
        '\n${' ' * params.tabSpaces}\n',
        selection: TextSelection.fromPosition(
          TextPosition(offset: sel.start + params.tabSpaces),
        ),
      );
    }

    return null;
  }
}
