import 'dart:io';
import 'dart:collection';
import 'token.dart';
import 'label.dart';
import 'num.dart';
import 'word.dart';


class LexicalAnalyzer {
  int index = 0;
  int line = 1;
  String char = ' ';
  String digits = "0123456789";
  String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

  HashMap words = HashMap();

  reserve(Word word) {
    words[word.lexeme] = word;
  }

  LexicalAnalyzer() {
    reserve(Word(Label.TRUE, "true"));
    reserve(Word(Label.FALSE, "false"));
  }

  read(String text){
    if(this.index < text.length) 
      this.char = text[index];
    else 
      this.char = "#EOF";
    index++;
  }

  Token explore(String text) {

    for (int i = index; i < text.length; i++) {
      read(text);
      if(this.char == ' ' || this.char =='\t') continue;
      else if (this.char == '\n') line++;
      else break;
    }

    if(digits.contains(this.char)){
      int v = 0;
      do {
        v = 10 * v + this.char.codeUnitAt(0);
        read(text);
      } while (digits.contains(this.char));
      return Num(v);
    }

    if(letters.contains(this.char)){
      String buffer = "";
      do {
        buffer+= this.char;
        read(text);
      } while (letters.contains(this.char) || digits.contains(this.char));

      Word w = words[buffer];
      if(w != null) return w;
      w = Word(Label.ID, buffer);
      words[buffer] = w;
      return w; 
    }

    Token t = Token(this.char.codeUnitAt(0));
    this.char = ' ';
    return t;
    
  }
}


Future<void> main() async {
  LexicalAnalyzer analyzer = LexicalAnalyzer();
  String expression = stdin.readLineSync();
  Token token = analyzer.explore(expression);
  print(token.toString());
}
