// $ANTLR 3.0.1 /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g 2007-10-15 17:29:22

#import <Cocoa/Cocoa.h>
#import <ANTLR.h>

#pragma mark Cyclic DFA interface start LumaQQLexerDFA11
@interface LumaQQLexerDFA11 : ANTLRDFA {} @end

#pragma mark Cyclic DFA interface end LumaQQLexerDFA11

#pragma mark Rule return scopes start
#pragma mark Rule return scopes end

#pragma mark Tokens
#define LumaQQLexer_COMMA	15
#define LumaQQLexer_STATEMENT	4
#define LumaQQLexer_ARRAY	7
#define LumaQQLexer_H	22
#define LumaQQLexer_LIST	23
#define LumaQQLexer_NUMBER	30
#define LumaQQLexer_STRING	29
#define LumaQQLexer_EQ	9
#define LumaQQLexer_LT	10
#define LumaQQLexer_NE	8
#define LumaQQLexer_GT	12
#define LumaQQLexer_DOT	20
#define LumaQQLexer_GE	13
#define LumaQQLexer_PREDICATE	6
#define LumaQQLexer_CLOSEBRACKET	19
#define LumaQQLexer_SEMICOLON	14
#define LumaQQLexer_OPENBRACE	16
#define LumaQQLexer_OPENBRACKET	18
#define LumaQQLexer_HELP	21
#define LumaQQLexer_LS	24
#define LumaQQLexer_EOF	-1
#define LumaQQLexer_CLOSEBRACE	17
#define LumaQQLexer_LE	11
#define LumaQQLexer_Tokens	31
#define LumaQQLexer_CONNECTION	25
#define LumaQQLexer_CONN	26
#define LumaQQLexer_DIGIT	27
#define LumaQQLexer_COMMAND	5
#define LumaQQLexer_ID	28

@interface LumaQQLexer : ANTLRLexer {
	LumaQQLexerDFA11 *dfa11;
}


- (void) mNE;
- (void) mEQ;
- (void) mLT;
- (void) mLE;
- (void) mGT;
- (void) mGE;
- (void) mSEMICOLON;
- (void) mCOMMA;
- (void) mOPENBRACE;
- (void) mCLOSEBRACE;
- (void) mOPENBRACKET;
- (void) mCLOSEBRACKET;
- (void) mDOT;
- (void) mHELP;
- (void) mH;
- (void) mLIST;
- (void) mLS;
- (void) mCONNECTION;
- (void) mCONN;
- (void) mDIGIT;
- (void) mID;
- (void) mSTRING;
- (void) mNUMBER;
- (void) mTokens;



@end