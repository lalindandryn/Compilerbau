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

//reguläre Ausdrücke
L       = [A-Za-z]
D       = [0-9]
H       = [0-9A-Fa-f]
DECNUM  = {D}+
HEXNUM  = 0x{H}+
IdentifierCharacter = {L} | {D} | "_"
Identifier = {L}{IdentifierCharacter}*
DecIntegerLiteral =  [1-9][0-9]*



%%

// TODO (assignment 1): The regular expressions for all tokens need to be defined here.
\(              {return symbol (Sym.LPAREN);}
\)              {return symbol (Sym.RPAREN);}
\[              {return symbol (Sym.LBRACK);}
\]              {return symbol (Sym.RBRACK);}
\{              {return symbol (Sym.LCURL);}
\}              {return symbol (Sym.RCURL);}
\#              {return symbol (Sym.NE);}
\=              {return symbol (Sym.EQ);}
\:              {return symbol (Sym.COLON);}
\;              {return symbol (Sym.SEMIC);}
\<              {return symbol (Sym.LT);}
\>              {return symbol (Sym.GT);}
\+              {return symbol (Sym.PLUS);}
\-              {return symbol (Sym.MINUS);}
\/              {return symbol (Sym.SLASH);}
\*              {return symbol (Sym.STAR);}
\<=             {return symbol (Sym.LE);}
\>=             {return symbol (Sym.GE);}
\:=             {return symbol (Sym.ASGN);}
\,              {return symbol (Sym.COMMA);}

proc            {return symbol (Sym.PROC);}
if              {return symbol (Sym.IF);}
else            {return symbol (Sym.ELSE);}
ref             {return symbol (Sym.REF);}
of              {return symbol (Sym.OF);}
type            {return symbol (Sym.TYPE);}
array           {return symbol (Sym.ARRAY);}
var             {return symbol (Sym.VAR);}
while           {return symbol (Sym.WHILE);}
array           {return symbol (Sym.ARRAY);}
eof             {return symbol (Sym.EOF);}
     /*identifier*/
{Identifier}    {return symbol (Sym.IDENT,new Identifier(yytext()));}

      /* literals */
{DECNUM}      { return symbol(Sym.INTLIT, Integer.parseInt(yytext())); }
{HEXNUM}                { return symbol(Sym.INTLIT, Integer.parseInt(yytext().substring(2), 16)); }
'\\n'           {return symbol(Sym.INTLIT, 10);}
'.'             {return symbol(Sym.INTLIT, (int)yytext().charAt(1));}


[ \t\n\r]              { /* f ̈ur SPACE, TAB und NEWLINE ist nichts zu tun */ }
\/\/.*               { }


[^]		{throw SplError.LexicalError(new Position(yyline + 1, yycolumn + 1), yytext().charAt(0));}
