import 'label.dart';
import 'token.dart';

class Num extends Token {
  final int value;
  Num(this.value) : super(Label.NUM);
}