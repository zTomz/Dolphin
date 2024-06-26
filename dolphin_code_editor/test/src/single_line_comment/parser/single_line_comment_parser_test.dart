import 'package:dolphin_code_editor/src/single_line_comments/parser/highlight_single_line_comment_parser.dart';
import 'package:dolphin_code_editor/src/single_line_comments/parser/single_line_comment_parser.dart';
import 'package:dolphin_code_editor/src/single_line_comments/parser/single_line_comments.dart';
import 'package:dolphin_code_editor/src/single_line_comments/parser/text_single_line_comment_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/java.dart';

void main() {
  group('SingleLineCommentParser', () {
    test('uses text parser without language', () {
      const text = '''
public class MyClass {
  // comment
}
''';

      final result = SingleLineCommentParser.parseHighlighted(
        text: text,
        highlighted: null,
        singleLineCommentSequences: ['//', '#'],
      );

      expect(result.runtimeType, TextSingleLineCommentParser);
    });

    test('when type highlight fails, falls back to text', () {
      final examples = [
        _Example(
          'Java. Highlight',
          language: java,
          parserType: HighlightSingleLineCommentParser,
          text: '''
// slashed comment1 
/* multi
line */
public class MyClass {
  text // slashed comment2 // still comment2
}
''',
        ),

        // If the number sign bug gets fixed, find another example
        // that breaks highlighting.
        _Example(
          'Java. Text with number sign',
          language: java,
          parserType: TextSingleLineCommentParser,
          text: '''
// slashed comment1
text
  text // slashed comment2 // still comment2
text # not a comment
''',
        ),
      ];

      for (final example in examples) {
        highlight.registerLanguage('language', example.language);
        final highlighted = highlight.parse(example.text, language: 'language');

        final result = SingleLineCommentParser.parseHighlighted(
          text: example.text,
          highlighted: highlighted,
          singleLineCommentSequences:
              SingleLineComments.byMode[example.language] ?? [],
        );

        expect(result.runtimeType, example.parserType);
      }
    });
  });
}

class _Example {
  final Mode language;
  final String name;
  final Type parserType;
  final String text;

  _Example(
    this.name, {
    required this.language,
    required this.parserType,
    required this.text,
  });
}
