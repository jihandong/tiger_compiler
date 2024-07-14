/* MIT License Copyright (c) 2024 jhd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <iomanip>
#include <iostream>
#include <string_view>
#include <unordered_map>

#include "scanner.ih"

int main(int argc, char **argv) {
  static std::unordered_map<tiger::Token, std::string_view> table = {
      {tiger::ID, "ID"},
      {tiger::STRING, "STRING"},
      {tiger::INT, "INT"},
      {tiger::COMMA, "COMMA"},
      {tiger::COLON, "COLON"},
      {tiger::SEMICOLON, "SEMICOLON"},
      {tiger::LPAREN, "LPAREN"},
      {tiger::RPAREN, "RPAREN"},
      {tiger::LBRACK, "LBRACK"},
      {tiger::RBRACK, "RBRACK"},
      {tiger::LBRACE, "LBRACE"},
      {tiger::RBRACE, "RBRACE"},
      {tiger::DOT, "DOT"},
      {tiger::PLUS, "PLUS"},
      {tiger::MINUS, "MINUS"},
      {tiger::TIMES, "TIMES"},
      {tiger::DIVIDE, "DIVIDE"},
      {tiger::EQ, "EQ"},
      {tiger::NEQ, "NEQ"},
      {tiger::LT, "LT"},
      {tiger::LE, "LE"},
      {tiger::GT, "GT"},
      {tiger::GE, "GE"},
      {tiger::AND, "AND"},
      {tiger::OR, "OR"},
      {tiger::ASSIGN, "ASSIGN"},
      {tiger::ARRAY, "ARRAY"},
      {tiger::IF, "IF"},
      {tiger::THEN, "THEN"},
      {tiger::ELSE, "ELSE"},
      {tiger::WHILE, "WHILE"},
      {tiger::FOR, "FOR"},
      {tiger::TO, "TO"},
      {tiger::DO, "DO"},
      {tiger::LET, "LET"},
      {tiger::IN, "IN"},
      {tiger::END, "END"},
      {tiger::OF, "OF"},
      {tiger::BREAK, "BREAK"},
      {tiger::NIL, "NIL"},
      {tiger::FUNCTION, "FUNCTION"},
      {tiger::VAR, "VAR"},
      {tiger::TYPE, "TYPE"},
  };

  if (argc != 2) {
    std::cerr << "Usage: test_lex filename" << std::endl;
    exit(1);
  }

  Scanner scanner(argv[1]);

  while (auto token = static_cast<tiger::Token>(scanner.lex())) {
    switch (token) {
    case tiger::ID:
    case tiger::STRING:
      std::cout << std::setw(10) << std::left << table[token]
                << " line:" << std::setw(4) << scanner.getLine()
                << " pos:" << std::setw(4) << scanner.getPos() << " \""
                << (!scanner.matched().empty() ? scanner.matched().data()
                                               : "(NULL)")
                << "\"" << std::endl;
      break;
    case tiger::INT:
      std::cout << std::setw(10) << std::left << table[token]
                << " line:" << std::setw(4) << scanner.getLine()
                << " pos:" << std::setw(4) << scanner.getPos() << " "
                << std::stoi(scanner.matched()) << std::endl;
      break;
    default:
      std::cout << std::setw(10) << std::left << table[token]
                << " line:" << std::setw(4) << scanner.getLine()
                << " pos:" << std::setw(4) << scanner.getPos() << std::endl;
    }
  }

  return 0;
}
