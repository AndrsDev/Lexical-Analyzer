import 'token.dart';

class Word extends Token {
  final String lexeme;
  Word(int t, this.lexeme) : super(t);
}