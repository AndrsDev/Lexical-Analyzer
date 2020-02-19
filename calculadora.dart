import 'dart:io';
import 'dart:math';

int preced(String ch) {
  if (ch == '+' || ch == '-') {
    return 1;
  } else if (ch == '*' || ch == '/') {
    return 2;
  } else if (ch == '^') {
    return 3;
  } else {
    return 0;
  }
}

List infixToPostfix(String infix) {
  List<String> stk = List();
  stk.add('#');
  String simbols = "+-*/^";
  String digits = "0123456789";
  // String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  List postfix = List();
  String number = "";

  for (var i = 0; i < infix.length; i++) {
    String char = infix[i];

    if (digits.contains(char)) {
      number += char;
      if (i == infix.length - 1) {
        postfix.add(number);
      }
    } else {
      if (number.isNotEmpty) {
        postfix.add(number);
        number = "";
      }

      if (char == '(')
        stk.add('(');
      else if (char == '^')
        stk.add('^');
      else if (char == ')') {
        while (stk.last != '#' && stk.last != '(') {
          postfix.add(stk.last); //store and pop until ( has found
          stk.removeLast();
        }
        stk.removeLast(); //remove the '(' from stack
      } else if(simbols.contains(char)) {
        if (preced(char) > preced(stk.last))
          stk.add(char); //push if precedence is high
        else {
          while (stk.last != '#' && preced(char) <= preced(stk.last)) {
            postfix.add(stk.last); //store and pop until higher precedence is found
            stk.removeLast();
          }
          stk.add(char);
        }
      }
    }
  }

  while (stk.last != '#') {
    postfix.add(stk.last); //store and pop until stack is not empty.
    stk.removeLast();
  }

  return postfix;
}

double operate(List postfix) {
  List<double> numbersStk = List<double>();
  String simbols = "-+*/^";

  try {
    for (var i = 0; i < postfix.length; i++) {
      var item = postfix[i];
      double num1 = 0;
      double num2 = 0;

      if (simbols.contains(item)) {
        num1 = numbersStk.last;
        numbersStk.removeLast();
        num2 = numbersStk.last;
        numbersStk.removeLast();

        switch (item) {
          case "*":
            numbersStk.add(num2 * num1);
            break;
          case "/":
            numbersStk.add(num2 / num1);
            break;
          case "+":
            numbersStk.add(num2 + num1);
            break;
          case "-":
            numbersStk.add(num2 - num1);
            break;
          case "^":
            numbersStk.add(pow(num2, num1));
            break;
        }
      } else {
        numbersStk.add(double.parse(item));
      }
    }

    return numbersStk.last;
  } catch (e) {
    print('Error: Operación inválida.');
    return 0.0;
  }
}

Future<void> main() async {
  print('Ingrese una operación: ');
  String expression = stdin.readLineSync();
  List postfix = infixToPostfix(expression);
  double result = operate(postfix);
  print('Resultado: ${result}');
}
