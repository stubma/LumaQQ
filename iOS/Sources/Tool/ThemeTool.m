/*
 * LumaQQ - Cross platform QQ client, special edition for iPhone
 *
 * Copyright (C) 2007 luma <stubma@163.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import "ThemeTool.h"
#import "FileTool.h"
#import "Constants.h"

Theme gTheme;

#define _kUserBackgroundRed @"UserBackgroundRed"
#define _kUserBackgroundGreen @"UserBackgroundGreen"
#define _kUserBackgroundBlue @"UserBackgroundBlue"
#define _kUserSelectedBackgroundRed @"UserSelectedBackgroundRed"
#define _kUserSelectedBackgroundGreen @"UserSelectedBackgroundGreen"
#define _kUserSelectedBackgroundBlue @"UserSelectedBackgroundBlue"
#define _kUserCellDefaultRed @"UserCellDefaultRed"
#define _kUserCellDefaultGreen @"UserCellDefaultGreen"
#define _kUserCellDefaultBlue @"UserCellDefaultBlue"
#define _kMemberNameDefaultRed @"MemberNameDefaultRed"
#define _kMemberNameDefaultGreen @"MemberNameDefaultGreen"
#define _kMemberNameDefaultBlue @"MemberNameDefaultBlue"
#define _kUserSignatureRed @"UserSignatureRed"
#define _kUserSignatureGreen @"UserSignatureGreen"
#define _kUserSignatureBlue @"UserSignatureBlue"
#define _kGroupBackgroundRed @"GroupBackgroundRed"
#define _kGroupBackgroundGreen @"GroupBackgroundGreen"
#define _kGroupBackgroundBlue @"GroupBackgroundBlue"
#define _kGroupSelectedBackgroundRed @"GroupSelectedBackgroundRed"
#define _kGroupSelectedBackgroundGreen @"GroupSelectedBackgroundGreen"
#define _kGroupSelectedBackgroundBlue @"GroupSelectedBackgroundBlue"
#define _kClusterBackgroundRed @"ClusterBackgroundRed"
#define _kClusterBackgroundGreen @"ClusterBackgroundGreen"
#define _kClusterBackgroundBlue @"ClusterBackgroundBlue"
#define _kClusterSelectedBackgroundRed @"ClusterSelectedBackgroundRed"
#define _kClusterSelectedBackgroundGreen @"ClusterSelectedBackgroundGreen"
#define _kClusterSelectedBackgroundBlue @"ClusterSelectedBackgroundBlue"
#define _kClusterCellDefaultRed @"ClusterCellDefaultRed"
#define _kClusterCellDefaultGreen @"ClusterCellDefaultGreen"
#define _kClusterCellDefaultBlue @"ClusterCellDefaultBlue"
#define _kAdvancedClusterNameDefaultRed @"AdvancedClusterNameDefaultRed"
#define _kAdvancedClusterNameDefaultGreen @"AdvancedClusterNameDefaultGreen"
#define _kAdvancedClusterNameDefaultBlue @"AdvancedClusterNameDefaultBlue"
#define _kUnreadHintRed @"UnreadHintRed"
#define _kUnreadHintGreen @"UnreadHintGreen"
#define _kUnreadHintBlue @"UnreadHintBlue"
#define _kUnreadMessageRed @"UnreadMessageRed"
#define _kUnreadMessageGreen @"UnreadMessageGreen"
#define _kUnreadMessageBlue @"UnreadMessageBlue"
#define _kUserIMCellDefaultRed @"UserIMCellDefaultRed"
#define _kUserIMCellDefaultGreen @"UserIMCellDefaultGreen"
#define _kUserIMCellDefaultBlue @"UserIMCellDefaultBlue"
#define _kClusterIMCellDefaultRed @"ClusterIMCellDefaultRed"
#define _kClusterIMCellDefaultGreen @"ClusterIMCellDefaultGreen"
#define _kClusterIMCellDefaultBlue @"ClusterIMCellDefaultBlue"
#define _kSystemBackgroundRed @"SystemBackgroundRed"
#define _kSystemBackgroundGreen @"SystemBackgroundGreen"
#define _kSystemBackgroundBlue @"SystemBackgroundBlue"
#define _kSystemSelectedBackgroundRed @"SystemSelectedBackgroundRed"
#define _kSystemSelectedBackgroundGreen @"SystemSelectedBackgroundGreen"
#define _kSystemSelectedBackgroundBlue @"SystemSelectedBackgroundBlue"
#define _kSystemIMCellDefaultRed @"SystemIMCellDefaultRed"
#define _kSystemIMCellDefaultGreen @"SystemIMCellDefaultGreen"
#define _kSystemIMCellDefaultBlue @"SystemIMCellDefaultBlue"
#define _kErrorTextRed @"ErrorTextRed"
#define _kErrorTextGreen @"ErrorTextGreen"
#define _kErrorTextBlue @"ErrorTextBlue"
#define _kBubbleIMCellDefaultRed @"BubbleIMCellDefaultRed"
#define _kBubbleIMCellDefaultGreen @"BubbleIMCellDefaultGreen"
#define _kBubbleIMCellDefaultBlue @"BubbleIMCellDefaultBlue"
#define _kBubbleBackgroundRed @"BubbleBackgroundRed"
#define _kBubbleBackgroundGreen @"BubbleBackgroundGreen"
#define _kBubbleBackgroundBlue @"BubbleBackgroundBlue"
#define _kChatLogBackgroundRed @"ChatLogBackgroundRed"
#define _kChatLogBackgroundGreen @"ChatLogBackgroundGreen"
#define _kChatLogBackgroundBlue @"ChatLogBackgroundBlue"
#define _kChatLogSelectedBackgroundRed @"ChatLogSelectedBackgroundRed"
#define _kChatLogSelectedBackgroundGreen @"ChatLogSelectedBackgroundGreen"
#define _kChatLogSelectedBackgroundBlue @"ChatLogSelectedBackgroundBlue"
#define _kChatLogDefaultRed @"ChatLogDefaultRed"
#define _kChatLogDefaultGreen @"ChatLogDefaultGreen"
#define _kChatLogDefaultBlue @"ChatLogDefaultBlue"
#define _kChatLogOtherMessageRed @"ChatLogOtherMessageRed"
#define _kChatLogOtherMessageGreen @"ChatLogOtherMessageGreen"
#define _kChatLogOtherMessageBlue @"ChatLogOtherMessageBlue"
#define _kChatLogMyMessageRed @"ChatLogMyMessageRed"
#define _kChatLogMyMessageGreen @"ChatLogMyMessageGreen"
#define _kChatLogMyMessageBlue @"ChatLogMyMessageBlue"

#define _kMainButtonBarStyle @"MainButtonBarStyle"

@implementation ThemeTool

+ (void)initialize {
	NSString* path = [FileTool getThemeFilePath];
	NSDictionary* themes = [NSDictionary dictionaryWithContentsOfFile:path];
	
	// user bg
	NSNumber* n = [themes objectForKey:_kUserBackgroundRed];
	gTheme.userBg[0] = [n floatValue];
	n = [themes objectForKey:_kUserBackgroundGreen];
	gTheme.userBg[1] = [n floatValue];
	n = [themes objectForKey:_kUserBackgroundBlue];
	gTheme.userBg[2] = [n floatValue];
	gTheme.userBg[3] = 1.0f;
	
	// user selected bg
	n = [themes objectForKey:_kUserSelectedBackgroundRed];
	gTheme.userSelectedBg[0] = [n floatValue];
	n = [themes objectForKey:_kUserSelectedBackgroundGreen];
	gTheme.userSelectedBg[1] = [n floatValue];
	n = [themes objectForKey:_kUserSelectedBackgroundBlue];
	gTheme.userSelectedBg[2] = [n floatValue];
	gTheme.userSelectedBg[3] = 1.0f;
	
	// user text fg
	n = [themes objectForKey:_kUserCellDefaultRed];
	gTheme.userTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kUserCellDefaultGreen];
	gTheme.userTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kUserCellDefaultBlue];
	gTheme.userTextFg[2] = [n floatValue];
	gTheme.userTextFg[3] = 1.0f;
	
	// member text fg
	n = [themes objectForKey:_kMemberNameDefaultRed];
	gTheme.memberTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kMemberNameDefaultGreen];
	gTheme.memberTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kMemberNameDefaultBlue];
	gTheme.memberTextFg[2] = [n floatValue];
	gTheme.memberTextFg[3] = 1.0f;
	
	// user signature text fg
	n = [themes objectForKey:_kUserSignatureRed];
	gTheme.userSigTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kUserSignatureGreen];
	gTheme.userSigTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kUserSignatureBlue];
	gTheme.userSigTextFg[2] = [n floatValue];
	gTheme.userSigTextFg[3] = 1.0f;
	
	// cluster bg
	n = [themes objectForKey:_kClusterBackgroundRed];
	gTheme.clusterBg[0] = [n floatValue];
	n = [themes objectForKey:_kClusterBackgroundGreen];
	gTheme.clusterBg[1] = [n floatValue];
	n = [themes objectForKey:_kClusterBackgroundBlue];
	gTheme.clusterBg[2] = [n floatValue];
	gTheme.clusterBg[3] = 1.0f;
	
	// cluster selected bg
	n = [themes objectForKey:_kClusterSelectedBackgroundRed];
	gTheme.clusterSelectedBg[0] = [n floatValue];
	n = [themes objectForKey:_kClusterSelectedBackgroundGreen];
	gTheme.clusterSelectedBg[1] = [n floatValue];
	n = [themes objectForKey:_kClusterSelectedBackgroundBlue];
	gTheme.clusterSelectedBg[2] = [n floatValue];
	gTheme.clusterSelectedBg[3] = 1.0f;
	
	// cluster text fg
	n = [themes objectForKey:_kClusterCellDefaultRed];
	gTheme.clusterTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kClusterCellDefaultGreen];
	gTheme.clusterTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kClusterCellDefaultBlue];
	gTheme.clusterTextFg[2] = [n floatValue];
	gTheme.clusterTextFg[3] = 1.0f;
	
	// advanced cluster text fg
	n = [themes objectForKey:_kAdvancedClusterNameDefaultRed];
	gTheme.advancedClusterTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kAdvancedClusterNameDefaultGreen];
	gTheme.advancedClusterTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kAdvancedClusterNameDefaultBlue];
	gTheme.advancedClusterTextFg[2] = [n floatValue];
	gTheme.advancedClusterTextFg[3] = 1.0f;
	
	// unread hint text fg
	n = [themes objectForKey:_kUnreadHintRed];
	gTheme.unreadHintFg[0] = [n floatValue];
	n = [themes objectForKey:_kUnreadHintGreen];
	gTheme.unreadHintFg[1] = [n floatValue];
	n = [themes objectForKey:_kUnreadHintBlue];
	gTheme.unreadHintFg[2] = [n floatValue];
	gTheme.unreadHintFg[3] = 1.0f;
	
	// unread message text fg
	n = [themes objectForKey:_kUnreadMessageRed];
	gTheme.messageTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kUnreadMessageGreen];
	gTheme.messageTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kUnreadMessageBlue];
	gTheme.messageTextFg[2] = [n floatValue];
	gTheme.messageTextFg[3] = 1.0f;
	
	// user im cell default text fg
	n = [themes objectForKey:_kUserIMCellDefaultRed];
	gTheme.userIMTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kUserIMCellDefaultGreen];
	gTheme.userIMTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kUserIMCellDefaultBlue];
	gTheme.userIMTextFg[2] = [n floatValue];
	gTheme.userIMTextFg[3] = 1.0f;
	
	// cluster im cell default text fg
	n = [themes objectForKey:_kClusterIMCellDefaultRed];
	gTheme.clusterIMTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kClusterIMCellDefaultGreen];
	gTheme.clusterIMTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kClusterIMCellDefaultBlue];
	gTheme.clusterIMTextFg[2] = [n floatValue];
	gTheme.clusterIMTextFg[3] = 1.0f;
	
	// system im bg
	n = [themes objectForKey:_kSystemBackgroundRed];
	gTheme.systemBg[0] = [n floatValue];
	n = [themes objectForKey:_kSystemBackgroundGreen];
	gTheme.systemBg[1] = [n floatValue];
	n = [themes objectForKey:_kSystemBackgroundBlue];
	gTheme.systemBg[2] = [n floatValue];
	gTheme.systemBg[3] = 1.0f;
	
	// system im selected bg
	n = [themes objectForKey:_kSystemSelectedBackgroundRed];
	gTheme.systemSelectedBg[0] = [n floatValue];
	n = [themes objectForKey:_kSystemSelectedBackgroundGreen];
	gTheme.systemSelectedBg[1] = [n floatValue];
	n = [themes objectForKey:_kSystemSelectedBackgroundBlue];
	gTheme.systemSelectedBg[2] = [n floatValue];
	gTheme.systemSelectedBg[3] = 1.0f;
	
	// system im default text fg
	n = [themes objectForKey:_kSystemIMCellDefaultRed];
	gTheme.systemIMTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kSystemIMCellDefaultGreen];
	gTheme.systemIMTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kSystemIMCellDefaultBlue];
	gTheme.systemIMTextFg[2] = [n floatValue];
	gTheme.systemIMTextFg[3] = 1.0f;
	
	// system im default text fg
	n = [themes objectForKey:_kErrorTextRed];
	gTheme.errorTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kErrorTextGreen];
	gTheme.errorTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kErrorTextBlue];
	gTheme.errorTextFg[2] = [n floatValue];
	gTheme.errorTextFg[3] = 1.0f;
	
	// system im default text fg
	n = [themes objectForKey:_kBubbleIMCellDefaultRed];
	gTheme.bubbleIMTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kBubbleIMCellDefaultGreen];
	gTheme.bubbleIMTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kBubbleIMCellDefaultBlue];
	gTheme.bubbleIMTextFg[2] = [n floatValue];
	gTheme.bubbleIMTextFg[3] = 1.0f;
	
	// system im default text fg
	n = [themes objectForKey:_kBubbleBackgroundRed];
	gTheme.bubbleBg[0] = [n floatValue];
	n = [themes objectForKey:_kBubbleBackgroundGreen];
	gTheme.bubbleBg[1] = [n floatValue];
	n = [themes objectForKey:_kBubbleBackgroundBlue];
	gTheme.bubbleBg[2] = [n floatValue];
	gTheme.bubbleBg[3] = 1.0f;
	
	// chat log bg
	n = [themes objectForKey:_kChatLogBackgroundRed];
	gTheme.chatLogBg[0] = [n floatValue];
	n = [themes objectForKey:_kChatLogBackgroundGreen];
	gTheme.chatLogBg[1] = [n floatValue];
	n = [themes objectForKey:_kChatLogBackgroundBlue];
	gTheme.chatLogBg[2] = [n floatValue];
	gTheme.chatLogBg[3] = 1.0f;
	
	// chat log selected bg
	n = [themes objectForKey:_kChatLogSelectedBackgroundRed];
	gTheme.chatLogSelectedBg[0] = [n floatValue];
	n = [themes objectForKey:_kChatLogSelectedBackgroundGreen];
	gTheme.chatLogSelectedBg[1] = [n floatValue];
	n = [themes objectForKey:_kChatLogSelectedBackgroundBlue];
	gTheme.chatLogSelectedBg[2] = [n floatValue];
	gTheme.chatLogSelectedBg[3] = 1.0f;
	
	// chat log default text color
	n = [themes objectForKey:_kChatLogDefaultRed];
	gTheme.chatLogTextFg[0] = [n floatValue];
	n = [themes objectForKey:_kChatLogDefaultGreen];
	gTheme.chatLogTextFg[1] = [n floatValue];
	n = [themes objectForKey:_kChatLogDefaultBlue];
	gTheme.chatLogTextFg[2] = [n floatValue];
	gTheme.chatLogTextFg[3] = 1.0f;
	
	// chat log message text color, message from other users
	n = [themes objectForKey:_kChatLogOtherMessageRed];
	gTheme.chatLogOtherMsgFg[0] = [n floatValue];
	n = [themes objectForKey:_kChatLogOtherMessageGreen];
	gTheme.chatLogOtherMsgFg[1] = [n floatValue];
	n = [themes objectForKey:_kChatLogOtherMessageBlue];
	gTheme.chatLogOtherMsgFg[2] = [n floatValue];
	gTheme.chatLogOtherMsgFg[3] = 1.0f;
	
	// chat log message text color, message from me
	n = [themes objectForKey:_kChatLogMyMessageRed];
	gTheme.chatLogMyMsgFg[0] = [n floatValue];
	n = [themes objectForKey:_kChatLogMyMessageGreen];
	gTheme.chatLogMyMsgFg[1] = [n floatValue];
	n = [themes objectForKey:_kChatLogMyMessageBlue];
	gTheme.chatLogMyMsgFg[2] = [n floatValue];
	gTheme.chatLogMyMsgFg[3] = 1.0f;
	
	// main button bar style
	gTheme.mainButtonBarStyle = [[themes objectForKey:_kMainButtonBarStyle] intValue];
}
				
@end
