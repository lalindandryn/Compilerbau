package de.thm.mni.compilerbau.phases._01_scanner;

import de.thm.mni.compilerbau.utils.SplError;
import de.thm.mni.compilerbau.phases._02_03_parser.Sym;
import de.thm.mni.compilerbau.absyn.Position;
import de.thm.mni.compilerbau.table.Identifier;
import de.thm.mni.compilerbau.CommandLineOptions;
import java_cup.runtime.*;

%%


%class Scanner
%public
%line
%column
%cup
%eofval{
    return new java_cup.runtime.Symbol(Sym.EOF, yyline + 1, yycolumn + 1);   //This needs to be specified when using a custom sym class name
%eofval}

%{
    public CommandLineOptions options = null;
  
    private Symbol symbol(int type) {
      return new Symbol(type, yyline + 1, yycolumn + 1);
    }

    private Symbol symbol(int type, Object value) {
      return new Symbol(type, yyline + 1, yycolumn + 1, value);
    }
%}

//Regular Expr
L = [A-Za-z]
D = [0-9]
H = [0-9A-Fa-f]
DECIMAL = {D}+
HEXADECIMAL = 0x{H}+
Ident = {L}({L} | {D} | "-")*
%%

// TODO (assignment 1): The regular expressions for all tokens need to be defined here.

//Symbols
"(" {return symbol(Sym.LPAREN);}
")" {return symbol(Sym.RPAREN);}
"[" {return symbol(Sym.LBRACK);}
"]" {return symbol(Sym.RBRACK);}
"{" {return symbol(Sym.LCURL);}
"}" {return symbol(Sym.RCURL);}
":" {return symbol(Sym.COLON);}
";" {return symbol(Sym.SEMIC);}
//Symbols: Comparance
"<" {return symbol(Sym.LT);}
">" {return symbol(Sym.GT);}
"<=" {return symbol(Sym.LE);}
">=" {return symbol(Sym.GE);}
"=" {return symbol(Sym.EQ);}
"#" {return symbol(Sym.NE);}
//Symbols: Operator
"+" {return symbol(Sym.PLUS);}
"-" {return symbol(Sym.MINUS);}
"/" {return symbol(Sym.SLASH);}
"*" {return symbol(Sym.STAR);}
"," {return symbol(Sym.COMMA);} //Symbol: Separator

//Keywords
"proc" {return symbol(Sym.PROC);}
"var" {return symbol(Sym.VAR);}
"array" {return symbol(Sym.ARRAY);}
"if" {return symbol(Sym.IF);}
"else" {return symbol(Sym.ELSE);}
"of" {return symbol(Sym.OF);}
"ref" {return symbol(Sym.REF);}
"type" {return symbol(Sym.TYPE);}
"while" {return symbol(Sym.WHILE);}
"eof" {return symbol(Sym.EOF);}

//Indentifiers
{Ident} {return symbol(Sym.IDENT, new Identifier(yytext()));}

//Literals
{DECIMAL} {return symbol(Sym.INTLIT, Integer.parseInt(yytext()));}
{HEXADECIMAL} {return symbol(Sym.INTLIT, Integer.parseInt(yytext().substring(2), 16));}
"." {return symbol(Sym.INTLIT, new Integer(yytext().charAt(1)));}
"\\n" {return symbol(Sym.INTLIT, 10);} //Char for new line

//Whitespaces
"//" .* {}
"'" {}
[ \t\n\r]+ {}
\/\/ .* {}

[^]		{throw SplError.LexicalError(new Position(yyline + 1, yycolumn + 1), yytext().charAt(0));}
