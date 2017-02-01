// $ANTLR 3.0.1 /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQWalker.g 2007-10-15 19:19:13

#import <Cocoa/Cocoa.h>
#import <ANTLR.h>

	#import "CommandExecutor.h"
	#import "HelpCommand.h"
	#import "ListCommand.h"
	#import "SetCommand.h"
	#import "SendCommand.h"
	#import "Predicate.h"
	#import "LumaQQLexer.h"




#pragma mark Tokens
#define LumaQQWalker_COMMA	15
#define LumaQQWalker_STATEMENT	4
#define LumaQQWalker_ARRAY	7
#define LumaQQWalker_H	22
#define LumaQQWalker_LIST	23
#define LumaQQWalker_NUMBER	30
#define LumaQQWalker_STRING	29
#define LumaQQWalker_EQ	9
#define LumaQQWalker_LT	10
#define LumaQQWalker_NE	8
#define LumaQQWalker_GT	12
#define LumaQQWalker_DOT	20
#define LumaQQWalker_GE	13
#define LumaQQWalker_PREDICATE	6
#define LumaQQWalker_CLOSEBRACKET	19
#define LumaQQWalker_SEMICOLON	14
#define LumaQQWalker_OPENBRACE	16
#define LumaQQWalker_OPENBRACKET	18
#define LumaQQWalker_HELP	21
#define LumaQQWalker_LS	24
#define LumaQQWalker_EOF	-1
#define LumaQQWalker_CLOSEBRACE	17
#define LumaQQWalker_LE	11
#define LumaQQWalker_CONNECTION	25
#define LumaQQWalker_CONN	26
#define LumaQQWalker_DIGIT	27
#define LumaQQWalker_COMMAND	5
#define LumaQQWalker_ID	28

#pragma mark Dynamic Global Scopes

#pragma mark Dynamic Rule Scopes
@interface LumaQQWalkercommandsScope : NSObject {
	id<CommandExecutor> executor;
}
// use KVC to access attributes!
@end


#pragma mark Rule Return Scopes


@interface LumaQQWalker : ANTLRTreeParser {

		NSMutableArray *LumaQQWalker_commands_stack;
									

 }


- (void) commands;
- (void) commandNames;
- (void) objectNames;
- (void) predicate;
- (void) rationalExpr;
- (int) operators;
- (void) value;
- (void) arrayElement;



@end