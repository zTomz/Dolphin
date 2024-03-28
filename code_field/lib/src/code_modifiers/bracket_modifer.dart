import 'package:flutter/widgets.dart';

import '../../code_text_field.dart';

/// CodeModifier for round brackets "()"
///
/// This modifier does automatic insertion of the closing bracket
/// and moves the cursor between them.
class RoundBracketModifier extends BracketModifier {
  const RoundBracketModifier() : super(type: BracketType.round);
}

/// CodeModifier for curly brackets "{}"
///
/// This modifier does automatic insertion of the closing bracket
/// and moves the cursor between them.
class CurlyBracketModifier extends BracketModifier {
  const CurlyBracketModifier() : super(type: BracketType.curly);
}

/// CodeModifier for square brackets "[]"
///
/// This modifier does automatic insertion of the closing bracket
/// and moves the cursor between them.
class SquareBracketModifier extends BracketModifier {
  const SquareBracketModifier() : super(type: BracketType.square);
}

/// A list of all bracket modifiers.
/// [CurlyBracketModifier], [RoundBracketModifier], and [SquareBracketModifier].
const List<BracketModifier> bracketModifiers = [
  CurlyBracketModifier(),
  RoundBracketModifier(),
  SquareBracketModifier(),
];

/// A code modifier for inserting bracket pairs.
///
/// When the user types an opening bracket, this modifier will insert the
/// closing bracket and place the caret in between.
class BracketModifier extends CodeModifier {
  /// The type of bracket to insert.
  final BracketType type;

  /// Creates a new bracket modifier.
  ///
  /// The [type] parameter specifies the type of bracket to insert.
  const BracketModifier({
    required this.type,
  }) : super(
          // The opening bracket.
          type == BracketType.curly
              ? '{'
              : type == BracketType.round
                  ? '('
                  : '[',
        );

  @override
  TextEditingValue? updateString(
    String text, // The current text.
    TextSelection sel, // The user's current selection.
    EditorParams params, // Configuration parameters.
  ) {
    // Replace the user's selection with the bracket pair.
    final newString = replace(
      text,
      sel.start,
      sel.end,

      // The bracket pair to insert.
      bracketPair,

      // Place the caret in between the brackets.
      selection: TextSelection.fromPosition(
        TextPosition(offset: sel.end + 1),
      ),
    );
    return newString;
  }

  /// The bracket pair to insert.
  String get bracketPair => type == BracketType.curly
      ? '{}'
      : type == BracketType.round
          ? '()'
          : '[]';
}

/// The type of bracket to insert.
enum BracketType {
  /// A curly bracket pair: `{}`.
  curly,

  /// A round bracket pair: `()`.
  round,

  /// A square bracket pair: `[]`.
  square,
}
