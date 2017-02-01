grammar LumaQQ;

options {
	output = AST;
	ASTLabelType = CommonTree;
	language = ObjC;
}

// imaginary tokens
tokens {
	STATEMENT;
	COMMAND;
	PREDICATE;
	ARRAY;
	NE = '!=';
	EQ = '==';
	LT = '<';
	LE = '<=';
	GT = '>';
	GE = '>=';
	SEMICOLON = ';';
	COMMA = ',';
	OPENBRACE = '{';
	CLOSEBRACE = '}';
	OPENBRACKET = '[';
	CLOSEBRACKET = ']';
	DOT = '.';
	HELP = 'help';
	H = 'h';
	LIST = 'list';
	LS = 'ls';
	CONNECTION = 'connection';
	CONN = 'conn';
}

// lexer rules
fragment
DIGIT	:	'0'..'9';

ID	:	('a'..'z' | 'A'..'Z' | '_')? ('a'..'z' | 'A'..'Z' | '_' | '0'..'9')*;
STRING	:	'\'' (options { greedy = false; } : ~'\'')* '\''
	|	'"' (options { greedy = false; } : ~'"')* '"'
	;
NUMBER	:	DIGIT+ ('.' DIGIT?)?
	|	'.' DIGIT+
	;

// parser rules
lumaScript
	:	stats EOF!
	|	EOF!
	;
	
stats	:	stat+
		-> ^(STATEMENT stat)+
	;
	
stat	:	commands COMMA
		-> ^(COMMAND commands)
	;
	
commands:	helpCommand
	|	listCommand
	;
	
helpCommand
	:	('help' | 'h') commandNames?
		-> ^(HELP commandNames)
	;
	
listCommand
	:	('list' | 'ls') objectNames predicate*
		-> ^(LIST objectNames predicate*)
	;
	
predicate
	:	'[' rationalExpr ']'	
		-> ^(PREDICATE rationalExpr)
	;
	
rationalExpr
	:	ID ('==' | '!=' | '>' | '>=' | '<' | '<=')^ value
	;
	
commandNames
	:	'help'
	|	'h'
	|	'list'
	|	'ls'
	;
	
objectNames
	:	'connection'
	|	'conn'
	;

value	:	array
	|	NUMBER
	|	STRING
	;
	
array	:	'{'! arrayElements '}'!
	;
	
arrayElements
	:	arrayElement (',' arrayElement)*
		-> ^(ARRAY arrayElement*)
	;
	
arrayElement
	:	NUMBER
	|	STRING
	;
