tree grammar LumaQQWalker;

options {
	tokenVocab = LumaQQ;
	ASTLabelType = CommonTree;
	language = ObjC;
}

@header {
	#import "CommandExecutor.h"
	#import "HelpCommand.h"
	#import "ListCommand.h"
	#import "SetCommand.h"
	#import "SendCommand.h"
	#import "Predicate.h"
	#import "LumaQQLexer.h"
}

// need add manually
@members {
	NSMutableArray* m_commands;
}

// tree parser rules
commands
scope {
	id<CommandExecutor> executor;
}
@after { 
	// need add manually
	[m_commands addObject:[executor autorelease]];
}
	:	^(HELP commandNames)
		{
			$commands::executor = [[HelpCommand alloc] init];
		}
	|	^(LIST objectNames predicate*)
		{
			$commands::executor = [[ListCommand alloc] init];
		}
	;
	
commandNames
	:	'help'
		{
			NSNumber* c = [NSNumber numberWithInt:LumaQQLexer_HELP];
			[$commands::executor setObject:c forKey:kScriptParamCommand];
		}
	|	'h'
		{
			NSNumber* c = [NSNumber numberWithInt:LumaQQLexer_HELP];
			[$commands::executor setObject:c forKey:kScriptParamCommand];
		}
	|	'list'
		{
			NSNumber* c = [NSNumber numberWithInt:LumaQQLexer_LIST];
			[$commands::executor setObject:c forKey:kScriptParamCommand];
		}
	|	'ls'
		{
			NSNumber* c = [NSNumber numberWithInt:LumaQQLexer_LIST];
			[$commands::executor setObject:c forKey:kScriptParamCommand];
		}
	;
	
objectNames
	:	'connection'
		{
			NSNumber* o = [NSNumber numberWithInt:LumaQQLexer_CONNECTION];
			[$commands::executor setObject:o forKey:kScriptParamObject];
		}
	|	'conn'
		{
			NSNumber* o = [NSNumber numberWithInt:LumaQQLexer_CONNECTION];
			[$commands::executor setObject:o forKey:kScriptParamObject];
		}
	;
	
predicate
	:	^(PREDICATE rationalExpr)
	;
	
rationalExpr
	:	^(op=operators ID value)
		{
			Predicate* p = [[[Predicate alloc] init] autorelease];
			[p setOp:$op.value];
			[p setProperty:$ID.text];
			[$commands::executor addObject:p forKey:kScriptParamPredicates];
		}
	;
	
operators returns [int value]
	:	'=='
		{ $value = LumaQQLexer_EQ; }
		| '!=' 
		{ $value = LumaQQLexer_NE; }
		| '>' 
		{ $value = LumaQQLexer_GT; }
		| '>=' 
		{ $value = LumaQQLexer_GE; }
		| '<' 
		{ $value = LumaQQLexer_LT; }
		| '<='
		{ $value = LumaQQLexer_LE; }
	;
	
value	:	^(ARRAY arrayElement*)
	|	NUMBER
	|	STRING
	;
	
arrayElement
	:	NUMBER
	|	STRING
	;
