/* MIT License Copyright (c) 2024 jhd
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%filenames = "scanner"
%x STR COMMENT
%%

/* Skip white spaces. */
[ \r\t]+    {adjust();}
"\n"        {adjust(); errmsg_.newLine();}

","     {adjust(); return tiger::COMMA;}
":"     {adjust(); return tiger::COLON;}
";"     {adjust(); return tiger::SEMICOLON;}
"("     {adjust(); return tiger::LPAREN;}
")"     {adjust(); return tiger::RPAREN;}
"["     {adjust(); return tiger::LBRACK;}
"]"     {adjust(); return tiger::RBRACK;}
"{"     {adjust(); return tiger::LBRACE;}
"}"     {adjust(); return tiger::RBRACE;}
"."     {adjust(); return tiger::DOT;}
"+"     {adjust(); return tiger::PLUS;}
"-"     {adjust(); return tiger::MINUS;}
"*"     {adjust(); return tiger::TIMES;}
"/"     {adjust(); return tiger::DIVIDE;}
"="     {adjust(); return tiger::EQ;}
"<>"    {adjust(); return tiger::NEQ;}
"<"     {adjust(); return tiger::LT;} 
"<="    {adjust(); return tiger::LE;}
">"     {adjust(); return tiger::GT;}
">="    {adjust(); return tiger::GE;}
"&"     {adjust(); return tiger::AND;}
"|"     {adjust(); return tiger::OR;}
":="    {adjust(); return tiger::ASSIGN;}

/* Reserved words */
"if"        {adjust(); return tiger::IF;}
"then"      {adjust(); return tiger::THEN;}
"else"      {adjust(); return tiger::ELSE;}
"while"     {adjust(); return tiger::WHILE;}
"for"       {adjust(); return tiger::FOR;}
"to"        {adjust(); return tiger::TO;}
"do"        {adjust(); return tiger::DO;}
"let"       {adjust(); return tiger::LET;}
"in"        {adjust(); return tiger::IN;}
"end"       {adjust(); return tiger::END;}
"of"        {adjust(); return tiger::OF;}
"break"     {adjust(); return tiger::BREAK;}
"nil"       {adjust(); return tiger::NIL;}
"function"  {adjust(); return tiger::FUNCTION;}
"var"       {adjust(); return tiger::VAR;}
"type"      {adjust(); return tiger::TYPE;}

/* Identifier and integer */
[a-zA-Z][_a-zA-Z0-9]*   {adjust(); return tiger::ID;}
[0-9]+                  {adjust(); return tiger::INT;}

/* String. TODO: support escape char. */
\"  {adjust(); begin(StartCondition_::STR);}
<STR> {
    \"  {adjust(); begin(StartCondition_::INITIAL);
         auto const& str = matched();
         setMatched(str.substr(0, str.size() - 1));
         return tiger::STRING;}
    .   {adjust(); more();}
}

/* Comments. */
"/*"    {adjust(); begin(StartCondition_::COMMENT); ++commentLevel_;}
<COMMENT> {
    "/*"    {adjust(); ++commentLevel_;}
    "*/"    {adjust(); --commentLevel_;
             if (commentLevel_ < 0) return tiger::ERROR;
             else if (commentLevel_ == 0) begin(StartCondition_::INITIAL);}
    .       {adjust();}
    "\n"    {adjust(); errmsg_.newLine();}
}

/* Error and EOF */
.   {adjust(); /* TODO: error message. */ return tiger::ERROR;}
<<EOF>> return 0;
