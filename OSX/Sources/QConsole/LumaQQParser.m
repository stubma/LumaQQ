// $ANTLR 3.0.1 /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g 2007-10-15 17:29:22

#import "LumaQQParser.h"

#import <ANTLR.h>



#pragma mark Bitsets
const static unsigned long long FOLLOW_stats_in_lumaScript356_data[] = {0x0000000000000000LL};
static ANTLRBitSet *FOLLOW_stats_in_lumaScript356;
const static unsigned long long FOLLOW_LumaQQParser_EOF_in_lumaScript358_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_EOF_in_lumaScript358;
const static unsigned long long FOLLOW_LumaQQParser_EOF_in_lumaScript364_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_EOF_in_lumaScript364;
const static unsigned long long FOLLOW_stat_in_stats376_data[] = {0x0000000001E00002LL};
static ANTLRBitSet *FOLLOW_stat_in_stats376;
const static unsigned long long FOLLOW_commands_in_stat399_data[] = {0x0000000000008000LL};
static ANTLRBitSet *FOLLOW_commands_in_stat399;
const static unsigned long long FOLLOW_LumaQQParser_COMMA_in_stat401_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_COMMA_in_stat401;
const static unsigned long long FOLLOW_helpCommand_in_commands421_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_helpCommand_in_commands421;
const static unsigned long long FOLLOW_listCommand_in_commands426_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_listCommand_in_commands426;
const static unsigned long long FOLLOW_LumaQQParser_HELP_in_helpCommand439_data[] = {0x0000000001E00002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_HELP_in_helpCommand439;
const static unsigned long long FOLLOW_LumaQQParser_H_in_helpCommand443_data[] = {0x0000000001E00002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_H_in_helpCommand443;
const static unsigned long long FOLLOW_commandNames_in_helpCommand446_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_commandNames_in_helpCommand446;
const static unsigned long long FOLLOW_LumaQQParser_LIST_in_listCommand470_data[] = {0x0000000006000000LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_LIST_in_listCommand470;
const static unsigned long long FOLLOW_LumaQQParser_LS_in_listCommand474_data[] = {0x0000000006000000LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_LS_in_listCommand474;
const static unsigned long long FOLLOW_objectNames_in_listCommand477_data[] = {0x0000000000040002LL};
static ANTLRBitSet *FOLLOW_objectNames_in_listCommand477;
const static unsigned long long FOLLOW_predicate_in_listCommand479_data[] = {0x0000000000040002LL};
static ANTLRBitSet *FOLLOW_predicate_in_listCommand479;
const static unsigned long long FOLLOW_LumaQQParser_OPENBRACKET_in_predicate505_data[] = {0x0000000010000000LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_OPENBRACKET_in_predicate505;
const static unsigned long long FOLLOW_rationalExpr_in_predicate507_data[] = {0x0000000000080000LL};
static ANTLRBitSet *FOLLOW_rationalExpr_in_predicate507;
const static unsigned long long FOLLOW_LumaQQParser_CLOSEBRACKET_in_predicate509_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_CLOSEBRACKET_in_predicate509;
const static unsigned long long FOLLOW_LumaQQParser_ID_in_rationalExpr532_data[] = {0x0000000000003F00LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_ID_in_rationalExpr532;
const static unsigned long long FOLLOW_set_in_rationalExpr534_data[] = {0x0000000060010000LL};
static ANTLRBitSet *FOLLOW_set_in_rationalExpr534;
const static unsigned long long FOLLOW_value_in_rationalExpr559_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_value_in_rationalExpr559;
const static unsigned long long FOLLOW_set_in_commandNames0_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_set_in_commandNames0;
const static unsigned long long FOLLOW_set_in_objectNames0_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_set_in_objectNames0;
const static unsigned long long FOLLOW_array_in_value613_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_array_in_value613;
const static unsigned long long FOLLOW_LumaQQParser_NUMBER_in_value618_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_NUMBER_in_value618;
const static unsigned long long FOLLOW_LumaQQParser_STRING_in_value623_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_STRING_in_value623;
const static unsigned long long FOLLOW_LumaQQParser_OPENBRACE_in_array634_data[] = {0x0000000060000000LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_OPENBRACE_in_array634;
const static unsigned long long FOLLOW_arrayElements_in_array637_data[] = {0x0000000000020000LL};
static ANTLRBitSet *FOLLOW_arrayElements_in_array637;
const static unsigned long long FOLLOW_LumaQQParser_CLOSEBRACE_in_array639_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_CLOSEBRACE_in_array639;
const static unsigned long long FOLLOW_arrayElement_in_arrayElements652_data[] = {0x0000000000008002LL};
static ANTLRBitSet *FOLLOW_arrayElement_in_arrayElements652;
const static unsigned long long FOLLOW_LumaQQParser_COMMA_in_arrayElements655_data[] = {0x0000000060000000LL};
static ANTLRBitSet *FOLLOW_LumaQQParser_COMMA_in_arrayElements655;
const static unsigned long long FOLLOW_arrayElement_in_arrayElements657_data[] = {0x0000000000008002LL};
static ANTLRBitSet *FOLLOW_arrayElement_in_arrayElements657;
const static unsigned long long FOLLOW_set_in_arrayElement0_data[] = {0x0000000000000002LL};
static ANTLRBitSet *FOLLOW_set_in_arrayElement0;


#pragma mark Dynamic Global Scopes

#pragma mark Dynamic Rule Scopes

#pragma mark Rule return scopes start
@implementation LumaQQParser_lumaScript_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_stats_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_stat_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_commands_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_helpCommand_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_listCommand_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_predicate_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_rationalExpr_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_commandNames_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_objectNames_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_value_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_array_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_arrayElements_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end
@implementation LumaQQParser_arrayElement_return
- (CommonTree) tree
{
	return tree;
}
- (void) setTree:(CommonTree)aTree
{
	if (tree != aTree) {
		[aTree retain];
		[tree release];
		tree = aTree;
	}
}

- (void) dealloc
{
    [self setTree:nil];
    [super dealloc];
}
@end


@implementation LumaQQParser

static NSArray *tokenNames;

+ (void) initialize
{
	FOLLOW_stats_in_lumaScript356 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_stats_in_lumaScript356_data count:1];
	FOLLOW_LumaQQParser_EOF_in_lumaScript358 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_EOF_in_lumaScript358_data count:1];
	FOLLOW_LumaQQParser_EOF_in_lumaScript364 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_EOF_in_lumaScript364_data count:1];
	FOLLOW_stat_in_stats376 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_stat_in_stats376_data count:1];
	FOLLOW_commands_in_stat399 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_commands_in_stat399_data count:1];
	FOLLOW_LumaQQParser_COMMA_in_stat401 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_COMMA_in_stat401_data count:1];
	FOLLOW_helpCommand_in_commands421 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_helpCommand_in_commands421_data count:1];
	FOLLOW_listCommand_in_commands426 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_listCommand_in_commands426_data count:1];
	FOLLOW_LumaQQParser_HELP_in_helpCommand439 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_HELP_in_helpCommand439_data count:1];
	FOLLOW_LumaQQParser_H_in_helpCommand443 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_H_in_helpCommand443_data count:1];
	FOLLOW_commandNames_in_helpCommand446 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_commandNames_in_helpCommand446_data count:1];
	FOLLOW_LumaQQParser_LIST_in_listCommand470 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_LIST_in_listCommand470_data count:1];
	FOLLOW_LumaQQParser_LS_in_listCommand474 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_LS_in_listCommand474_data count:1];
	FOLLOW_objectNames_in_listCommand477 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_objectNames_in_listCommand477_data count:1];
	FOLLOW_predicate_in_listCommand479 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_predicate_in_listCommand479_data count:1];
	FOLLOW_LumaQQParser_OPENBRACKET_in_predicate505 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_OPENBRACKET_in_predicate505_data count:1];
	FOLLOW_rationalExpr_in_predicate507 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_rationalExpr_in_predicate507_data count:1];
	FOLLOW_LumaQQParser_CLOSEBRACKET_in_predicate509 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_CLOSEBRACKET_in_predicate509_data count:1];
	FOLLOW_LumaQQParser_ID_in_rationalExpr532 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_ID_in_rationalExpr532_data count:1];
	FOLLOW_set_in_rationalExpr534 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_set_in_rationalExpr534_data count:1];
	FOLLOW_value_in_rationalExpr559 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_value_in_rationalExpr559_data count:1];
	FOLLOW_set_in_commandNames0 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_set_in_commandNames0_data count:1];
	FOLLOW_set_in_objectNames0 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_set_in_objectNames0_data count:1];
	FOLLOW_array_in_value613 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_array_in_value613_data count:1];
	FOLLOW_LumaQQParser_NUMBER_in_value618 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_NUMBER_in_value618_data count:1];
	FOLLOW_LumaQQParser_STRING_in_value623 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_STRING_in_value623_data count:1];
	FOLLOW_LumaQQParser_OPENBRACE_in_array634 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_OPENBRACE_in_array634_data count:1];
	FOLLOW_arrayElements_in_array637 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_arrayElements_in_array637_data count:1];
	FOLLOW_LumaQQParser_CLOSEBRACE_in_array639 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_CLOSEBRACE_in_array639_data count:1];
	FOLLOW_arrayElement_in_arrayElements652 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_arrayElement_in_arrayElements652_data count:1];
	FOLLOW_LumaQQParser_COMMA_in_arrayElements655 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_LumaQQParser_COMMA_in_arrayElements655_data count:1];
	FOLLOW_arrayElement_in_arrayElements657 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_arrayElement_in_arrayElements657_data count:1];
	FOLLOW_set_in_arrayElement0 = [[ANTLRBitSet alloc] initWithBits:FOLLOW_set_in_arrayElement0_data count:1];

	tokenNames = [[NSArray alloc] initWithObjects:@"<invalid>", @"<EOR>", @"<DOWN>", @"<UP>", 
	@"STATEMENT", @"COMMAND", @"PREDICATE", @"ARRAY", @"NE", @"EQ", @"LT", 
	@"LE", @"GT", @"GE", @"SEMICOLON", @"COMMA", @"OPENBRACE", @"CLOSEBRACE", 
	@"OPENBRACKET", @"CLOSEBRACKET", @"DOT", @"HELP", @"H", @"LIST", @"LS", 
	@"CONNECTION", @"CONN", @"DIGIT", @"ID", @"STRING", @"NUMBER", nil];
}

- (id) initWithTokenStream:(id<ANTLRTokenStream>)aStream
{
	if ((self = [super initWithTokenStream:aStream])) {


																														
		[self setTreeAdaptor:[[[ANTLRCommonTreeAdaptor alloc] init] autorelease]];
	}
	return self;
}

- (void) dealloc
{

	[self setTreeAdaptor:nil];

	[super dealloc];
}

- (NSString *) grammarFileName
{
	return @"/Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g";
}


// $ANTLR start lumaScript
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:49:1: lumaScript : ( stats EOF | EOF );
- (LumaQQParser_lumaScript_return *) lumaScript
{
    LumaQQParser_lumaScript_return * _retval = [[[LumaQQParser_lumaScript_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _EOF2 = nil;
    id<ANTLRToken>  _EOF3 = nil;
    LumaQQParser_stats_return * _stats1 = nil;


    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:50:2: ( stats EOF | EOF ) //ruleblock
        int alt1=2;
        {
        	int LA1_0 = [input LA:1];
        	if ( (LA1_0>=LumaQQParser_HELP && LA1_0<=LumaQQParser_LS) ) {
        		alt1 = 1;
        	}
        	else if ( LA1_0==LumaQQParser_EOF ) {
        		alt1 = 2;
        	}
        else {
            ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException exceptionWithDecision:1 state:0 stream:input];
        	@throw nvae;
        	}
        }
        switch (alt1) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:50:4: stats EOF // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    [following addObject:FOLLOW_stats_in_lumaScript356];
        	    _stats1 = [self stats];
        	    [following removeLastObject];


        	    [treeAdaptor addChild:[_stats1 tree] toTree:root_0];
        	    _EOF2=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_EOF follow:FOLLOW_LumaQQParser_EOF_in_lumaScript358]; 

        	    }
        	    break;
        	case 2 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:51:4: EOF // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    _EOF3=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_EOF follow:FOLLOW_LumaQQParser_EOF_in_lumaScript364]; 

        	    }
        	    break;

        }
    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end lumaScript

// $ANTLR start stats
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:54:1: stats : ( stat )+ -> ( ^( STATEMENT stat ) )+ ;
- (LumaQQParser_stats_return *) stats
{
    LumaQQParser_stats_return * _retval = [[[LumaQQParser_stats_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    LumaQQParser_stat_return * _stat4 = nil;


    ANTLRRewriteRuleSubtreeStream *_stream_stat=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule stat"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:54:7: ( ( stat )+ -> ( ^( STATEMENT stat ) )+ ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:54:9: ( stat )+ // alt
        {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:54:9: ( stat )+	// positiveClosureBlock
        int cnt2=0;

        do {
            int alt2=2;
            {
            	int LA2_0 = [input LA:1];
            	if ( (LA2_0>=LumaQQParser_HELP && LA2_0<=LumaQQParser_LS) ) {
            		alt2 = 1;
            	}

            }
            switch (alt2) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:54:9: stat // alt
        	    {
        	    [following addObject:FOLLOW_stat_in_stats376];
        	    _stat4 = [self stat];
        	    [following removeLastObject];


        	    [_stream_stat addElement:[_stat4 tree]];

        	    }
        	    break;

        	default :
        	    if ( cnt2 >= 1 )  goto loop2;
        			ANTLREarlyExitException *eee = [ANTLREarlyExitException exceptionWithStream:input decisionNumber:2];
        			@throw eee;
            }
            cnt2++;
        } while (YES); loop2: ;


        // AST REWRITE
        // elements: stat
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 55:3: -> ( ^( STATEMENT stat ) )+
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:55:6: ( ^( STATEMENT stat ) )+
            {
            if ( !([_stream_stat hasNext]) ) {
                @throw [NSException exceptionWithName:@"RewriteEarlyExitException" reason:nil userInfo:nil];
            }
            while ( [_stream_stat hasNext] ) {
                // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:55:6: ^( STATEMENT stat )
                {
                CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

                id<ANTLRTree> _LumaQQParser_STATEMENT_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_STATEMENT text:[tokenNames objectAtIndex:LumaQQParser_STATEMENT]];
                root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_STATEMENT_tree parentOf:root_1];
                [_LumaQQParser_STATEMENT_tree release];

                [treeAdaptor addChild:[_stream_stat next] toTree:root_1];

                [treeAdaptor addChild:root_1 toTree:root_0];
                [root_1 release];
                }

            }
            [_stream_stat reset];

            }
        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_stat release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end stats

// $ANTLR start stat
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:58:1: stat : commands COMMA -> ^( COMMAND commands ) ;
- (LumaQQParser_stat_return *) stat
{
    LumaQQParser_stat_return * _retval = [[[LumaQQParser_stat_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _COMMA6 = nil;
    LumaQQParser_commands_return * _commands5 = nil;


    CommonTree _COMMA6_tree = nil;
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_COMMA=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_COMMA"];
    ANTLRRewriteRuleSubtreeStream *_stream_commands=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule commands"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:58:6: ( commands COMMA -> ^( COMMAND commands ) ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:58:8: commands COMMA // alt
        {
        [following addObject:FOLLOW_commands_in_stat399];
        _commands5 = [self commands];
        [following removeLastObject];


        [_stream_commands addElement:[_commands5 tree]];
        _COMMA6=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_COMMA follow:FOLLOW_LumaQQParser_COMMA_in_stat401]; 
        [_stream_LumaQQParser_COMMA addElement:_COMMA6];


        // AST REWRITE
        // elements: commands
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 59:3: -> ^( COMMAND commands )
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:59:6: ^( COMMAND commands )
            {
            CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

            id<ANTLRTree> _LumaQQParser_COMMAND_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_COMMAND text:[tokenNames objectAtIndex:LumaQQParser_COMMAND]];
            root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_COMMAND_tree parentOf:root_1];
            [_LumaQQParser_COMMAND_tree release];

            [treeAdaptor addChild:[_stream_commands next] toTree:root_1];

            [treeAdaptor addChild:root_1 toTree:root_0];
            [root_1 release];
            }

        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_LumaQQParser_COMMA release];
		[_stream_commands release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end stat

// $ANTLR start commands
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:62:1: commands : ( helpCommand | listCommand );
- (LumaQQParser_commands_return *) commands
{
    LumaQQParser_commands_return * _retval = [[[LumaQQParser_commands_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    LumaQQParser_helpCommand_return * _helpCommand7 = nil;

    LumaQQParser_listCommand_return * _listCommand8 = nil;



    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:62:9: ( helpCommand | listCommand ) //ruleblock
        int alt3=2;
        {
        	int LA3_0 = [input LA:1];
        	if ( (LA3_0>=LumaQQParser_HELP && LA3_0<=LumaQQParser_H) ) {
        		alt3 = 1;
        	}
        	else if ( (LA3_0>=LumaQQParser_LIST && LA3_0<=LumaQQParser_LS) ) {
        		alt3 = 2;
        	}
        else {
            ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException exceptionWithDecision:3 state:0 stream:input];
        	@throw nvae;
        	}
        }
        switch (alt3) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:62:11: helpCommand // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    [following addObject:FOLLOW_helpCommand_in_commands421];
        	    _helpCommand7 = [self helpCommand];
        	    [following removeLastObject];


        	    [treeAdaptor addChild:[_helpCommand7 tree] toTree:root_0];

        	    }
        	    break;
        	case 2 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:63:4: listCommand // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    [following addObject:FOLLOW_listCommand_in_commands426];
        	    _listCommand8 = [self listCommand];
        	    [following removeLastObject];


        	    [treeAdaptor addChild:[_listCommand8 tree] toTree:root_0];

        	    }
        	    break;

        }
    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end commands

// $ANTLR start helpCommand
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:66:1: helpCommand : ( 'help' | 'h' ) ( commandNames )? -> ^( HELP commandNames ) ;
- (LumaQQParser_helpCommand_return *) helpCommand
{
    LumaQQParser_helpCommand_return * _retval = [[[LumaQQParser_helpCommand_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _string_literal9 = nil;
    id<ANTLRToken>  _char_literal10 = nil;
    LumaQQParser_commandNames_return * _commandNames11 = nil;

    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_H=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_H"];
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_HELP=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_HELP"];
    ANTLRRewriteRuleSubtreeStream *_stream_commandNames=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule commandNames"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:2: ( ( 'help' | 'h' ) ( commandNames )? -> ^( HELP commandNames ) ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:4: ( 'help' | 'h' ) ( commandNames )? // alt
        {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:4: ( 'help' | 'h' ) // block
        int alt4=2;
        {
        	int LA4_0 = [input LA:1];
        	if ( LA4_0==LumaQQParser_HELP ) {
        		alt4 = 1;
        	}
        	else if ( LA4_0==LumaQQParser_H ) {
        		alt4 = 2;
        	}
        else {
            ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException exceptionWithDecision:4 state:0 stream:input];
        	@throw nvae;
        	}
        }
        switch (alt4) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:5: 'help' // alt
        	    {
        	    _string_literal9=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_HELP follow:FOLLOW_LumaQQParser_HELP_in_helpCommand439]; 
        	    [_stream_LumaQQParser_HELP addElement:_string_literal9];


        	    }
        	    break;
        	case 2 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:14: 'h' // alt
        	    {
        	    _char_literal10=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_H follow:FOLLOW_LumaQQParser_H_in_helpCommand443]; 
        	    [_stream_LumaQQParser_H addElement:_char_literal10];


        	    }
        	    break;

        }

        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:19: ( commandNames )? // block
        int alt5=2;
        {
        	int LA5_0 = [input LA:1];
        	if ( (LA5_0>=LumaQQParser_HELP && LA5_0<=LumaQQParser_LS) ) {
        		alt5 = 1;
        	}
        }
        switch (alt5) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:67:19: commandNames // alt
        	    {
        	    [following addObject:FOLLOW_commandNames_in_helpCommand446];
        	    _commandNames11 = [self commandNames];
        	    [following removeLastObject];


        	    [_stream_commandNames addElement:[_commandNames11 tree]];

        	    }
        	    break;

        }


        // AST REWRITE
        // elements: commandNames
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 68:3: -> ^( HELP commandNames )
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:68:6: ^( HELP commandNames )
            {
            CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

            id<ANTLRTree> _LumaQQParser_HELP_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_HELP text:[tokenNames objectAtIndex:LumaQQParser_HELP]];
            root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_HELP_tree parentOf:root_1];
            [_LumaQQParser_HELP_tree release];

            [treeAdaptor addChild:[_stream_commandNames next] toTree:root_1];

            [treeAdaptor addChild:root_1 toTree:root_0];
            [root_1 release];
            }

        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_LumaQQParser_H release];
		[_stream_LumaQQParser_HELP release];
		[_stream_commandNames release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end helpCommand

// $ANTLR start listCommand
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:71:1: listCommand : ( 'list' | 'ls' ) objectNames ( predicate )* -> ^( LIST objectNames ( predicate )* ) ;
- (LumaQQParser_listCommand_return *) listCommand
{
    LumaQQParser_listCommand_return * _retval = [[[LumaQQParser_listCommand_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _string_literal12 = nil;
    id<ANTLRToken>  _string_literal13 = nil;
    LumaQQParser_objectNames_return * _objectNames14 = nil;

    LumaQQParser_predicate_return * _predicate15 = nil;


    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_LIST=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_LIST"];
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_LS=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_LS"];
    ANTLRRewriteRuleSubtreeStream *_stream_objectNames=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule objectNames"];
    ANTLRRewriteRuleSubtreeStream *_stream_predicate=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule predicate"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:2: ( ( 'list' | 'ls' ) objectNames ( predicate )* -> ^( LIST objectNames ( predicate )* ) ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:4: ( 'list' | 'ls' ) objectNames ( predicate )* // alt
        {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:4: ( 'list' | 'ls' ) // block
        int alt6=2;
        {
        	int LA6_0 = [input LA:1];
        	if ( LA6_0==LumaQQParser_LIST ) {
        		alt6 = 1;
        	}
        	else if ( LA6_0==LumaQQParser_LS ) {
        		alt6 = 2;
        	}
        else {
            ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException exceptionWithDecision:6 state:0 stream:input];
        	@throw nvae;
        	}
        }
        switch (alt6) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:5: 'list' // alt
        	    {
        	    _string_literal12=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_LIST follow:FOLLOW_LumaQQParser_LIST_in_listCommand470]; 
        	    [_stream_LumaQQParser_LIST addElement:_string_literal12];


        	    }
        	    break;
        	case 2 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:14: 'ls' // alt
        	    {
        	    _string_literal13=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_LS follow:FOLLOW_LumaQQParser_LS_in_listCommand474]; 
        	    [_stream_LumaQQParser_LS addElement:_string_literal13];


        	    }
        	    break;

        }

        [following addObject:FOLLOW_objectNames_in_listCommand477];
        _objectNames14 = [self objectNames];
        [following removeLastObject];


        [_stream_objectNames addElement:[_objectNames14 tree]];
        do {
            int alt7=2;
            {
            	int LA7_0 = [input LA:1];
            	if ( LA7_0==LumaQQParser_OPENBRACKET ) {
            		alt7 = 1;
            	}

            }
            switch (alt7) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:72:32: predicate // alt
        	    {
        	    [following addObject:FOLLOW_predicate_in_listCommand479];
        	    _predicate15 = [self predicate];
        	    [following removeLastObject];


        	    [_stream_predicate addElement:[_predicate15 tree]];

        	    }
        	    break;

        	default :
        	    goto loop7;
            }
        } while (YES); loop7: ;


        // AST REWRITE
        // elements: objectNames, predicate
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        int i_0 = 0;
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 73:3: -> ^( LIST objectNames ( predicate )* )
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:73:6: ^( LIST objectNames ( predicate )* )
            {
            CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

            id<ANTLRTree> _LumaQQParser_LIST_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_LIST text:[tokenNames objectAtIndex:LumaQQParser_LIST]];
            root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_LIST_tree parentOf:root_1];
            [_LumaQQParser_LIST_tree release];

            [treeAdaptor addChild:[_stream_objectNames next] toTree:root_1];
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:73:25: ( predicate )*
            while ( [_stream_predicate hasNext] ) {
                [treeAdaptor addChild:[_stream_predicate next] toTree:root_1];

            }
            [_stream_predicate reset];

            [treeAdaptor addChild:root_1 toTree:root_0];
            [root_1 release];
            }

        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_LumaQQParser_LIST release];
		[_stream_LumaQQParser_LS release];
		[_stream_objectNames release];
		[_stream_predicate release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end listCommand

// $ANTLR start predicate
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:76:1: predicate : '[' rationalExpr ']' -> ^( PREDICATE rationalExpr ) ;
- (LumaQQParser_predicate_return *) predicate
{
    LumaQQParser_predicate_return * _retval = [[[LumaQQParser_predicate_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _char_literal16 = nil;
    id<ANTLRToken>  _char_literal18 = nil;
    LumaQQParser_rationalExpr_return * _rationalExpr17 = nil;


    CommonTree _char_literal16_tree = nil;
    CommonTree _char_literal18_tree = nil;
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_OPENBRACKET=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_OPENBRACKET"];
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_CLOSEBRACKET=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_CLOSEBRACKET"];
    ANTLRRewriteRuleSubtreeStream *_stream_rationalExpr=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule rationalExpr"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:77:2: ( '[' rationalExpr ']' -> ^( PREDICATE rationalExpr ) ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:77:4: '[' rationalExpr ']' // alt
        {
        _char_literal16=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_OPENBRACKET follow:FOLLOW_LumaQQParser_OPENBRACKET_in_predicate505]; 
        [_stream_LumaQQParser_OPENBRACKET addElement:_char_literal16];

        [following addObject:FOLLOW_rationalExpr_in_predicate507];
        _rationalExpr17 = [self rationalExpr];
        [following removeLastObject];


        [_stream_rationalExpr addElement:[_rationalExpr17 tree]];
        _char_literal18=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_CLOSEBRACKET follow:FOLLOW_LumaQQParser_CLOSEBRACKET_in_predicate509]; 
        [_stream_LumaQQParser_CLOSEBRACKET addElement:_char_literal18];


        // AST REWRITE
        // elements: rationalExpr
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 78:3: -> ^( PREDICATE rationalExpr )
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:78:6: ^( PREDICATE rationalExpr )
            {
            CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

            id<ANTLRTree> _LumaQQParser_PREDICATE_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_PREDICATE text:[tokenNames objectAtIndex:LumaQQParser_PREDICATE]];
            root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_PREDICATE_tree parentOf:root_1];
            [_LumaQQParser_PREDICATE_tree release];

            [treeAdaptor addChild:[_stream_rationalExpr next] toTree:root_1];

            [treeAdaptor addChild:root_1 toTree:root_0];
            [root_1 release];
            }

        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_LumaQQParser_OPENBRACKET release];
		[_stream_LumaQQParser_CLOSEBRACKET release];
		[_stream_rationalExpr release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end predicate

// $ANTLR start rationalExpr
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:81:1: rationalExpr : ID ( '==' | '!=' | '>' | '>=' | '<' | '<=' ) value ;
- (LumaQQParser_rationalExpr_return *) rationalExpr
{
    LumaQQParser_rationalExpr_return * _retval = [[[LumaQQParser_rationalExpr_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _ID19 = nil;
    id<ANTLRToken>  _set20 = nil;
    LumaQQParser_value_return * _value21 = nil;


    CommonTree _ID19_tree = nil;
    CommonTree _set20_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:82:2: ( ID ( '==' | '!=' | '>' | '>=' | '<' | '<=' ) value ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:82:4: ID ( '==' | '!=' | '>' | '>=' | '<' | '<=' ) value // alt
        {
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        _ID19=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_ID follow:FOLLOW_LumaQQParser_ID_in_rationalExpr532]; 
        _ID19_tree = (CommonTree)[treeAdaptor newTreeWithToken:_ID19];
        [treeAdaptor addChild:_ID19_tree toTree:root_0];
        [_ID19_tree release];

        _set20 = (id<ANTLRToken> )[input LT:1];
        if (([input LA:1]>=LumaQQParser_NE && [input LA:1]<=LumaQQParser_GE)) {

        	_set20_tree = (CommonTree)[treeAdaptor newTreeWithToken:_set20];
        	root_0 = (CommonTree)[treeAdaptor makeNode:_set20_tree parentOf:root_0];
        	[_set20_tree release];

        	[input consume];
        	errorRecovery = NO;
        } else {
        	ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException exceptionWithSet:nil stream:input];
        	[self recoverFromMismatchedSet:input exception:mse follow:FOLLOW_set_in_rationalExpr534];	@throw mse;
        }

        [following addObject:FOLLOW_value_in_rationalExpr559];
        _value21 = [self value];
        [following removeLastObject];


        [treeAdaptor addChild:[_value21 tree] toTree:root_0];

        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end rationalExpr

// $ANTLR start commandNames
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:85:1: commandNames : ( 'help' | 'h' | 'list' | 'ls' );
- (LumaQQParser_commandNames_return *) commandNames
{
    LumaQQParser_commandNames_return * _retval = [[[LumaQQParser_commandNames_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _set22 = nil;

    CommonTree _set22_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:86:2: ( 'help' | 'h' | 'list' | 'ls' ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g: // alt
        {
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        _set22 = (id<ANTLRToken> )[input LT:1];
        if (([input LA:1]>=LumaQQParser_HELP && [input LA:1]<=LumaQQParser_LS)) {

        	_set22_tree = (CommonTree)[treeAdaptor newTreeWithToken:_set22];
        	[treeAdaptor addChild:_set22_tree toTree:root_0];
        	[_set22_tree release];

        	[input consume];
        	errorRecovery = NO;
        } else {
        	ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException exceptionWithSet:nil stream:input];
        	[self recoverFromMismatchedSet:input exception:mse follow:FOLLOW_set_in_commandNames0];	@throw mse;
        }


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end commandNames

// $ANTLR start objectNames
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:92:1: objectNames : ( 'connection' | 'conn' );
- (LumaQQParser_objectNames_return *) objectNames
{
    LumaQQParser_objectNames_return * _retval = [[[LumaQQParser_objectNames_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _set23 = nil;

    CommonTree _set23_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:93:2: ( 'connection' | 'conn' ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g: // alt
        {
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        _set23 = (id<ANTLRToken> )[input LT:1];
        if (([input LA:1]>=LumaQQParser_CONNECTION && [input LA:1]<=LumaQQParser_CONN)) {

        	_set23_tree = (CommonTree)[treeAdaptor newTreeWithToken:_set23];
        	[treeAdaptor addChild:_set23_tree toTree:root_0];
        	[_set23_tree release];

        	[input consume];
        	errorRecovery = NO;
        } else {
        	ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException exceptionWithSet:nil stream:input];
        	[self recoverFromMismatchedSet:input exception:mse follow:FOLLOW_set_in_objectNames0];	@throw mse;
        }


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end objectNames

// $ANTLR start value
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:97:1: value : ( array | NUMBER | STRING );
- (LumaQQParser_value_return *) value
{
    LumaQQParser_value_return * _retval = [[[LumaQQParser_value_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _NUMBER25 = nil;
    id<ANTLRToken>  _STRING26 = nil;
    LumaQQParser_array_return * _array24 = nil;


    CommonTree _NUMBER25_tree = nil;
    CommonTree _STRING26_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:97:7: ( array | NUMBER | STRING ) //ruleblock
        int alt8=3;
        switch ([input LA:1]) {
        	case LumaQQParser_OPENBRACE:
        		alt8 = 1;
        		break;
        	case LumaQQParser_NUMBER:
        		alt8 = 2;
        		break;
        	case LumaQQParser_STRING:
        		alt8 = 3;
        		break;
        default:
         {
            ANTLRNoViableAltException *nvae = [ANTLRNoViableAltException exceptionWithDecision:8 state:0 stream:input];
        	@throw nvae;

        	}}
        switch (alt8) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:97:9: array // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    [following addObject:FOLLOW_array_in_value613];
        	    _array24 = [self array];
        	    [following removeLastObject];


        	    [treeAdaptor addChild:[_array24 tree] toTree:root_0];

        	    }
        	    break;
        	case 2 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:98:4: NUMBER // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    _NUMBER25=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_NUMBER follow:FOLLOW_LumaQQParser_NUMBER_in_value618]; 
        	    _NUMBER25_tree = (CommonTree)[treeAdaptor newTreeWithToken:_NUMBER25];
        	    [treeAdaptor addChild:_NUMBER25_tree toTree:root_0];
        	    [_NUMBER25_tree release];


        	    }
        	    break;
        	case 3 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:99:4: STRING // alt
        	    {
        	    root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        	    _STRING26=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_STRING follow:FOLLOW_LumaQQParser_STRING_in_value623]; 
        	    _STRING26_tree = (CommonTree)[treeAdaptor newTreeWithToken:_STRING26];
        	    [treeAdaptor addChild:_STRING26_tree toTree:root_0];
        	    [_STRING26_tree release];


        	    }
        	    break;

        }
    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end value

// $ANTLR start array
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:102:1: array : '{' arrayElements '}' ;
- (LumaQQParser_array_return *) array
{
    LumaQQParser_array_return * _retval = [[[LumaQQParser_array_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _char_literal27 = nil;
    id<ANTLRToken>  _char_literal29 = nil;
    LumaQQParser_arrayElements_return * _arrayElements28 = nil;


    CommonTree _char_literal27_tree = nil;
    CommonTree _char_literal29_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:102:7: ( '{' arrayElements '}' ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:102:9: '{' arrayElements '}' // alt
        {
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        _char_literal27=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_OPENBRACE follow:FOLLOW_LumaQQParser_OPENBRACE_in_array634]; 
        [following addObject:FOLLOW_arrayElements_in_array637];
        _arrayElements28 = [self arrayElements];
        [following removeLastObject];


        [treeAdaptor addChild:[_arrayElements28 tree] toTree:root_0];
        _char_literal29=(id<ANTLRToken> )[input LT:1];
        [self match:input tokenType:LumaQQParser_CLOSEBRACE follow:FOLLOW_LumaQQParser_CLOSEBRACE_in_array639]; 

        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end array

// $ANTLR start arrayElements
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:105:1: arrayElements : arrayElement ( ',' arrayElement )* -> ^( ARRAY ( arrayElement )* ) ;
- (LumaQQParser_arrayElements_return *) arrayElements
{
    LumaQQParser_arrayElements_return * _retval = [[[LumaQQParser_arrayElements_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _char_literal31 = nil;
    LumaQQParser_arrayElement_return * _arrayElement30 = nil;

    LumaQQParser_arrayElement_return * _arrayElement32 = nil;


    CommonTree _char_literal31_tree = nil;
    ANTLRRewriteRuleTokenStream *_stream_LumaQQParser_COMMA=[[ANTLRRewriteRuleTokenStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token LumaQQParser_COMMA"];
    ANTLRRewriteRuleSubtreeStream *_stream_arrayElement=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"rule arrayElement"];

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:106:2: ( arrayElement ( ',' arrayElement )* -> ^( ARRAY ( arrayElement )* ) ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:106:4: arrayElement ( ',' arrayElement )* // alt
        {
        [following addObject:FOLLOW_arrayElement_in_arrayElements652];
        _arrayElement30 = [self arrayElement];
        [following removeLastObject];


        [_stream_arrayElement addElement:[_arrayElement30 tree]];
        do {
            int alt9=2;
            {
            	int LA9_0 = [input LA:1];
            	if ( LA9_0==LumaQQParser_COMMA ) {
            		alt9 = 1;
            	}

            }
            switch (alt9) {
        	case 1 :
        	    // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:106:18: ',' arrayElement // alt
        	    {
        	    _char_literal31=(id<ANTLRToken> )[input LT:1];
        	    [self match:input tokenType:LumaQQParser_COMMA follow:FOLLOW_LumaQQParser_COMMA_in_arrayElements655]; 
        	    [_stream_LumaQQParser_COMMA addElement:_char_literal31];

        	    [following addObject:FOLLOW_arrayElement_in_arrayElements657];
        	    _arrayElement32 = [self arrayElement];
        	    [following removeLastObject];


        	    [_stream_arrayElement addElement:[_arrayElement32 tree]];

        	    }
        	    break;

        	default :
        	    goto loop9;
            }
        } while (YES); loop9: ;


        // AST REWRITE
        // elements: arrayElement
        // token labels: 
        // rule labels: retval
        // token list labels: 
        // rule list labels: 
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];
        [_retval setTree:root_0];
        ANTLRRewriteRuleSubtreeStream *_stream_retval=[[ANTLRRewriteRuleSubtreeStream alloc] initWithTreeAdaptor:treeAdaptor description:@"token retval" element:_retval!=nil?[_retval tree]:nil];

        // 107:3: -> ^( ARRAY ( arrayElement )* )
        {
            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:107:6: ^( ARRAY ( arrayElement )* )
            {
            CommonTree root_1 = (CommonTree)[treeAdaptor newEmptyTree];

            id<ANTLRTree> _LumaQQParser_ARRAY_tree = [treeAdaptor newTreeWithTokenType:LumaQQParser_ARRAY text:[tokenNames objectAtIndex:LumaQQParser_ARRAY]];
            root_1 = (CommonTree)[treeAdaptor makeNode:_LumaQQParser_ARRAY_tree parentOf:root_1];
            [_LumaQQParser_ARRAY_tree release];

            // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:107:14: ( arrayElement )*
            while ( [_stream_arrayElement hasNext] ) {
                [treeAdaptor addChild:[_stream_arrayElement next] toTree:root_1];

            }
            [_stream_arrayElement reset];

            [treeAdaptor addChild:root_1 toTree:root_0];
            [root_1 release];
            }

        }

        [_stream_retval release];


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		[_stream_LumaQQParser_COMMA release];
		[_stream_arrayElement release];
		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end arrayElements

// $ANTLR start arrayElement
// /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:110:1: arrayElement : ( NUMBER | STRING );
- (LumaQQParser_arrayElement_return *) arrayElement
{
    LumaQQParser_arrayElement_return * _retval = [[[LumaQQParser_arrayElement_return alloc] init] autorelease];
    [_retval setStart:[input LT:1]];

    CommonTree root_0 = nil;

    id<ANTLRToken>  _set33 = nil;

    CommonTree _set33_tree = nil;

    @try {
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g:111:2: ( NUMBER | STRING ) // ruleBlockSingleAlt
        // /Users/maruojie/Projects/LumaQQ/Sources/Script/LumaQQ.g: // alt
        {
        root_0 = (CommonTree)[treeAdaptor newEmptyTree];

        _set33 = (id<ANTLRToken> )[input LT:1];
        if (([input LA:1]>=LumaQQParser_STRING && [input LA:1]<=LumaQQParser_NUMBER)) {

        	_set33_tree = (CommonTree)[treeAdaptor newTreeWithToken:_set33];
        	[treeAdaptor addChild:_set33_tree toTree:root_0];
        	[_set33_tree release];

        	[input consume];
        	errorRecovery = NO;
        } else {
        	ANTLRMismatchedSetException *mse = [ANTLRMismatchedSetException exceptionWithSet:nil stream:input];
        	[self recoverFromMismatchedSet:input exception:mse follow:FOLLOW_set_in_arrayElement0];	@throw mse;
        }


        }

    }
	@catch (ANTLRRecognitionException *re) {
		[self reportError:re];
		[self recover:input exception:re];
	}
	@finally {
		// token+rule list labels
		[_retval setStop:[input LT:-1]];

		    [_retval setTree:(CommonTree)[treeAdaptor postProcessTree:root_0]];
		    [treeAdaptor setBoundariesForTree:[_retval tree] fromToken:[_retval start] toToken:[_retval stop]];
		[root_0 release];
	}
	return _retval;
}
// $ANTLR end arrayElement


- (id<ANTLRTreeAdaptor>) treeAdaptor
{
	return treeAdaptor;
}

- (void) setTreeAdaptor:(id<ANTLRTreeAdaptor>)aTreeAdaptor
{
	if (aTreeAdaptor != treeAdaptor) {
		[aTreeAdaptor retain];
		[treeAdaptor release];
		treeAdaptor = aTreeAdaptor;
	}
}

@end