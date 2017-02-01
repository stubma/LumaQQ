/*
 * LumaQQ - Cross platform QQ client, special edition for Mac
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 0 2111-1307 USA
 */

#import "ClusterIMContainerController.h"
#import "ClusterCommandPacket.h"
#import "MainWindowController.h"
#import "QQCell.h"
#import "ImageTool.h"
#import "ClusterIM.h"
#import "ClusterSendIMExPacket.h"
#import "TimerTaskManager.h"
#import "ByteTool.h"
#import "NSString-Validate.h"
#import "NSString-Filter.h"
#import "AnimationHelper.h"

// member table menu tag
#define _kMenuItemTagUserInfo 1000
#define _kMenuItemTagAddAsFriend 1001
#define _kMenuItemTagTempSession 1002

@implementation ClusterIMContainerController

#pragma mark -
#pragma mark IMContainer protocol

- (id)initWithObject:(id)obj mainWindow:(MainWindowController*)mainWindowController {
	m_cluster = (Cluster*)obj;
	return [super initWithObject:obj mainWindow:mainWindowController];
}

- (void) dealloc {
	// if we don't do this, it runs into a weird crash, don't know why
	[m_memberTable setDataSource:nil];
	[m_memberTable setDelegate:nil];
	
	[m_memberView release];	
	[super dealloc];
}

- (BOOL)handleQQEvent:(QQNotification*)event {
	BOOL ret = NO;
	
	switch([event eventId]) {
		case kQQEventClusterSendIMOK:
			ret = [self handleClusterSendIMOK:event];
			break;
		case kQQEventClusterSendIMFailed:
			ret = [self handleClusterSendIMFailed:event];
			break;
		case kQQEventClusterGetInfoOK:
			ret = [self handleClusterGetInfoOK:event];
			break;
		case kQQEventClusterGetMemberInfoOK:
			ret = [self handleClusterGetMemberInfoOK:event];
			break;
		case kQQEventClusterGetOnlineMemberOK:
			ret = [self handleClusterGetOnlineMemberOK:event];
			break;
		case kQQEventTempClusterGetInfoOK:
			ret = [self handleTempClusterGetInfoOK:event];
			break;
		case kQQEventTempClusterSendIMOK:
			ret = [self handleTempClusterSendIMOK:event];
			break;
		case kQQEventTempClusterSendIMFailed:
			ret = [self handleTempClusterSendIMFailed:event];
			break;
		case kQQEventTimeoutBasic:
			OutPacket* packet = [event outPacket];
			switch([packet command]) {
				case kQQCommandCluster:
					ClusterCommandPacket* ccp = (ClusterCommandPacket*)packet;
					switch([ccp subCommand]) {
						case kQQSubCommandClusterSendIMEx:
							ret = [self handleClusterSendIMTimeout:event];
							break;
						case kQQSubCommandTempClusterSendIM:
							ret = [self handleTempClusterSendIMTimeout:event];
							break;
					}
					break;
			}
			break;
	}
	
	return ret;
}

- (void)walkMessageQueue:(MessageQueue*)queue {
	if(queue == nil)
		return;
	
	while(InPacket* packet = [queue getClusterMessage:[m_cluster internalId] remove:YES]) {
		[self appendPacket:packet];
	}
	
	// refresh dock icon
	[m_mainWindowController refreshDockIcon];
	
	[m_cluster setMessageCount:0];
}

- (NSString*)owner {
	return [NSString stringWithFormat:@"%u", [m_cluster internalId]];
}

- (NSImage*)ownerImage {
	return [NSImage imageNamed:kImageClusters];
}

- (void)refreshHeadControl:(HeadControl*)headControl {
	[headControl setShowStatus:NO];
	[headControl setHead:kHeadUseImage];
	[headControl setImage:[NSImage imageNamed:kImageClusters]];
}

- (id)windowKey {
	return [NSNumber numberWithUnsignedInt:[m_cluster internalId]];
}

- (NSString*)description {
	if([m_cluster permanent])
		return [NSString stringWithFormat:L(@"LQClusterTitle", @"ClusterIMContainer"), [m_cluster name], [m_cluster externalId]];
	else if([m_cluster isSubject])
		return [NSString stringWithFormat:L(@"LQSubjectTitle", @"ClusterIMContainer"), [m_cluster name]];
	else if([m_cluster isDialog])
		return [NSString stringWithFormat:L(@"LQDialogTitle", @"ClusterIMContainer"), [m_cluster name]];
	else
		return kStringEmpty;
}

- (NSString*)shortDescription {
	return [m_cluster name];
}

- (NSArray*)actionIds {
	if(m_actionIds == nil) {
		m_actionIds = [[NSArray arrayWithObjects:kToolbarItemFont, 
			kToolbarItemColor, 
			kToolbarItemSwitchMemberView,
			NSToolbarSeparatorItemIdentifier,
			kToolbarItemSmiley,
			NSToolbarSeparatorItemIdentifier,
			kToolbarItemSendPicture,
			kToolbarItemScreenscrap,
			nil] retain];
	}
	return m_actionIds;
}

- (NSImage*)actionImage:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemSwitchMemberView])
		return [NSImage imageNamed:kImageInformation];
	else
		return [super actionImage:actionId];
}

- (NSString*)actionTooltip:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemSwitchMemberView])
		return L(@"LQTooltipSwitchMemberView", @"BaseIMContainer");
	else
		return [super actionTooltip:actionId];
}

- (void)performAction:(NSString*)actionId {
	if([actionId isEqualToString:kToolbarItemSwitchMemberView])
		[self onSwitchMemberView:self];
	else
		[super performAction:actionId];
}

- (void)handleIMContainerAttachedToWindow:(NSNotification*)notification {
	if(m_imView == [notification object]) {
		[m_split setDelegate:self];
		
		// get input box proportion
		float proportion = [m_cluster inputBoxProportion];
		
		// adjust split view
		[self adjustSplitView:m_split belowProportion:proportion];
	}
}

#pragma mark -
#pragma mark PSMTabModel protocol

- (int)objectCount {
	return [m_cluster messageCount];
}

#pragma mark -
#pragma mark helper

- (void)adjustSplitView:(NSSplitView*)split belowProportion:(float)belowProportion {
	// get split view bound
	NSRect bound = [split bounds];
	
	// set input box size
	NSRect frame;
	frame.origin = NSZeroPoint;
	frame.size = bound.size;
	frame.size.height = bound.size.height * (1.0 - belowProportion);
	frame.size.height = MAX(20.0, frame.size.height);
	frame.size.height = MIN(bound.size.height - 20.0, frame.size.height);
	[(NSView*)[[split subviews] objectAtIndex:0] setFrame:frame];
	
	// set output box size
	frame.origin.y = frame.size.height + [split dividerThickness];
	frame.size.height = bound.size.height - frame.origin.y;
	[(NSView*)[[split subviews] objectAtIndex:1] setFrame:frame];
	
	[split adjustSubviews];
}

- (NSString*)getUserDisplayName:(User*)user QQ:(UInt32)QQ {
	// get display string, first we get cluster name card, then nick, then qq number
	NSString* dname = nil;
	if(user) {
		ClusterSpecificInfo* info = [user getClusterSpecificInfo:[m_cluster internalId]];
		if(info) {
			dname = [[info nameCard] name];
			if([dname isEmpty])
				dname = [user nick];
		} else
			dname = [user nick];
	} else
		dname = [NSString stringWithFormat:@"%u", QQ];
	
	// check empty nick
	if([dname isEmpty])
		dname = [NSString stringWithFormat:@"%u", QQ];
	
	return dname;
}

#pragma mark -
#pragma mark split view delegate

- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	if(sender == m_split)
		return 20;
	else
		return 0;
}

- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)offset {
	if(sender == m_split)
		return [sender bounds].size.height - 20 - [sender dividerThickness];
	else
		return [sender bounds].size.height - [sender dividerThickness];
}

- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification {
	if([aNotification object] == m_split) {
		NSView* view = [[m_split subviews] objectAtIndex:1];
		float newProp = ([view bounds].size.height + [m_split dividerThickness]) / [m_split bounds].size.height;
		[m_cluster setInputBoxProportion:newProp];
	}
}

#pragma mark -
#pragma mark override super

- (void)sendCustomFaces:(CustomFaceList*)faceList {
	[[m_mainWindowController client] sendClusterCustomFaces:faceList];
}

- (void)appendPacket:(QQTextView*)textView packet:(InPacket*)inPacket {
	ReceivedIMPacket* packet = (ReceivedIMPacket*)inPacket;
	ClusterIM* im = [packet clusterIM];
	
	// get custom face, client will automatically get them so don't bother here
	CustomFaceList* faceList = [[m_mainWindowController client] removeFaceList:packet];
	if(faceList)
		[[faceList retain] autorelease];
	
	// get display string, first we get cluster name card, then nick, then qq number
	User* user = [[m_mainWindowController groupManager] user:[im sender]];
	NSString* dname = [self getUserDisplayName:user QQ:[im sender]];
	
	// append message
	[self appendMessage:textView
				   nick:dname 
				   data:[im messageData]
				  style:[im fontStyle]
				   date:[NSDate dateWithTimeIntervalSince1970:[im sendTime]]
			customFaces:faceList];
}

- (UInt16)doSend:(NSData*)data style:(FontStyle*)style fragmentCount:(int)fragmentCount fragmentIndex:(int)fragmentIndex {
	if([m_cluster permanent]) {
		return [[m_mainWindowController client] sendClusterIM:[m_cluster internalId]
												  messageData:data
														style:style
												fragmentCount:fragmentCount
												fragmentIndex:fragmentIndex];
	} else {
		return [[m_mainWindowController client] sendTempClusterIM:[m_cluster internalId]
														   parent:[m_cluster parentId] 
													  clusterType:[m_cluster tempType]
													  messageData:data
															style:style
													fragmentCount:fragmentCount
													fragmentIndex:fragmentIndex];
	}
}

- (void)handleHistoryDidSelected:(NSNotification*)notification {
	History* history = [[notification userInfo] objectForKey:kUserInfoHistory];
	if(history == m_history) {
		id object = [notification object];
		if([object isKindOfClass:[SentIM class]]) {
			[self appendMessageHint:m_txtInput
							   nick:[[m_mainWindowController me] nick]
							   date:[NSDate dateWithTimeIntervalSince1970:[(SentIM*)object sendTime]]
						 attributes:m_myHintAttributes];
			[[m_txtInput textStorage] appendAttributedString:[(SentIM*)object message]];
			if(![m_txtInput allowMultiFont])
				[m_txtInput changeAttributesOfAllText:[m_txtInput typingAttributes]];
		} else if([object isKindOfClass:[InPacket class]]) {
			[self appendPacket:m_txtInput packet:(InPacket*)object];
		}
	}
}

#pragma mark -
#pragma mark initialization

- (void)awakeFromNib {
	[super awakeFromNib];
	
	// retain member view
	[m_memberView retain];
	
	// set view's property
	[m_memberView setAutoresizingMask:(NSViewMinXMargin | NSViewWidthSizable | NSViewHeightSizable)];
	[m_memberView setAutoresizesSubviews:YES];
	[m_split setAutoresizingMask:(NSViewMaxXMargin | NSViewWidthSizable | NSViewHeightSizable)];
	
	// init table
	QQCell* qqCell = [[QQCell alloc] init];
	[qqCell setMemberStyle:YES];
	[qqCell setInternalId:[m_cluster internalId]];
	[[m_memberTable tableColumnWithIdentifier:@"1"] setDataCell:[qqCell autorelease]];
	[m_memberTable setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];
	[m_memberTable registerForDraggedTypes:[NSArray arrayWithObject:NSStringPboardType]];
	
	// refresh cluster info
	[m_txtOnline setStringValue:[NSString stringWithFormat:@"%u/%u", [m_cluster onlineMemberCount], [m_cluster memberCount]]];
	if([m_cluster permanent]) {
		NSString* notice = [[[m_cluster info] notice] normalize];
	    [m_txtNotice setStringValue:notice];
		[m_txtNotice setToolTip:notice];
		[[m_mainWindowController client] getClusterInfo:[m_cluster internalId]];
	} else if([m_cluster isSubject]) {
		Cluster* parentCluster = [[m_mainWindowController groupManager] cluster:[m_cluster parentId]];
		NSString* notice = [NSString stringWithFormat:L(@"LQSubjectNotice", @"ClusterIMContainer"), [parentCluster name]];
		[m_txtNotice setStringValue:notice];
		[m_txtNotice setToolTip:notice];
		if([parentCluster memberCount] == 0)
			[[m_mainWindowController client] getClusterInfo:[m_cluster parentId]];
		[[m_mainWindowController client] getSubjectInfo:[m_cluster internalId] parent:[m_cluster parentId]];
	} else if([m_cluster isDialog]) {
		User* user = [[m_mainWindowController groupManager] user:[[m_cluster info] creator]];
		NSString* notice = [NSString stringWithFormat:L(@"LQDialogNotice", @"ClusterIMContainer"), user ? [user remarkOrNickOrQQ] : [[NSNumber numberWithUnsignedInt:[[m_cluster info] creator]] description]];
		[m_txtNotice setStringValue:notice];
		[m_txtNotice setToolTip:notice];
		[[m_mainWindowController client] getDialogInfo:[m_cluster internalId]];
	}
}

#pragma mark -
#pragma mark actions

- (IBAction)onSwitchMemberView:(id)sender {
	if([m_memberView superview]) {
		//
		// remove member view
		//
		
		NSRect bound = [m_box bounds];
		
		// get im view start frame
		NSRect imViewStartFrame = [m_split frame];
		
		// get im view end frame
		NSRect imViewEndFrame = bound;
		
		// start animation
		[AnimationHelper moveView:m_split
							 from:imViewStartFrame
							   to:imViewEndFrame
						   fadeIn:nil
						  fadeOut:m_memberView
						 delegate:self];
	} else {
		//
		// add member view
		//
		
		// add it
		[m_box addSubview:m_memberView];
		
		// calculate member view end frame
		NSRect bound = [m_box bounds];
		NSRect memberViewEndFrame = bound;
		// I don't know why, if I use float it will be obscured when I scrolling it
		memberViewEndFrame.origin.x = (int)(NSWidth(bound) / 3 * 2);
		memberViewEndFrame.size.width = NSWidth(bound) - memberViewEndFrame.origin.x;
		
		// set member view frame
		[m_memberView setFrame:memberViewEndFrame];
		[m_memberView setHidden:YES];
		
		// get im view start frame
		NSRect imViewStartFrame = [m_split frame];
		
		// calculate im view end frame
		NSRect imViewEndFrame = imViewStartFrame;
		imViewEndFrame.size.width = NSWidth(bound) - NSWidth(memberViewEndFrame);
	
		// start animation
		[AnimationHelper moveView:m_split
							 from:imViewStartFrame
							   to:imViewEndFrame
						   fadeIn:m_memberView
						  fadeOut:nil
						 delegate:nil];
	}
}

- (IBAction)showOwnerInfo:(id)sender {
	if([m_cluster permanent])
		[[m_mainWindowController windowRegistry] showClusterInfoWindow:m_cluster mainWindow:m_mainWindowController];
	else if([m_cluster isSubject]) {
		Cluster* parent = [[m_mainWindowController groupManager] cluster:[m_cluster parentId]];
		if(parent)
			[[m_mainWindowController windowRegistry] showTempClusterInfoWindow:m_cluster 
																		parent:parent
																	mainWindow:m_mainWindowController];
	} else if([m_cluster isDialog])
		[[m_mainWindowController windowRegistry] showTempClusterInfoWindow:m_cluster
																	parent:nil
																mainWindow:m_mainWindowController];
}

- (IBAction)onUserInfo:(id)sender {
	User* user = [m_cluster memberAtIndex:[m_memberTable selectedRow]];
	if(user)
		[[m_mainWindowController windowRegistry] showUserInfoWindow:user
															cluster:m_cluster
														 mainWindow:m_mainWindowController];
}

- (IBAction)onAddAsFriend:(id)sender {
	User* user = [m_cluster memberAtIndex:[m_memberTable selectedRow]];
	if(user)
		[[m_mainWindowController windowRegistry] showAddFriendWindow:[user QQ]
																head:[user head]
																nick:[user nick]
														  mainWindow:m_mainWindowController];
}

- (IBAction)onTempSession:(id)sender {
	User* user = [m_cluster memberAtIndex:[m_memberTable selectedRow]];
	if(user)
		[[m_mainWindowController windowRegistry] showTempSessionIMWindowOrTab:user
																   mainWindow:m_mainWindowController];
}

#pragma mark -
#pragma mark animation delegate

- (void)animationDidEnd:(NSAnimation*)animation {
	[m_memberView removeFromSuperviewWithoutNeedingDisplay];
}

#pragma mark -
#pragma mark table datasource

- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [m_cluster memberCount];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
	User* user = [m_cluster memberAtIndex:rowIndex];
	switch([[aTableColumn identifier] intValue]) {
		case 0:
			if([user isCreator:m_cluster])
				return [NSImage imageNamed:kImageClusterCreator];
			else if([user isAdmin:m_cluster])
				return [NSImage imageNamed:kImageClusterAdmin];
			else if([user isStockholder:m_cluster])
				return [NSImage imageNamed:kImageClusterStockholder];
			else
				return nil;
			return nil;
		case 1:
			return user;
		default:
			return kStringEmpty;
	}
}

#pragma mark -
#pragma mark table delegate

- (BOOL)tableView:(NSTableView *)aTableView writeRows:(NSArray *)rows toPasteboard:(NSPasteboard *)pboard {
	id item = [m_cluster memberAtIndex:[[rows objectAtIndex:0] intValue]];
	if([item isMemberOfClass:[User class]]) {
		// set dragged user qq number
		[pboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
		[pboard setString:[self getUserDisplayName:item QQ:[item QQ]] forType:NSStringPboardType];
		return YES;
	} else
		return NO;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)operation {
	return NSDragOperationMove;
}

#pragma mark -
#pragma mark qq event handler

- (BOOL)handleClusterGetMemberInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId])
		[m_memberTable reloadData];
	return NO;
}

- (BOOL)handleClusterGetOnlineMemberOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId]) {
		[m_txtOnline setStringValue:[NSString stringWithFormat:@"%u/%u", [m_cluster onlineMemberCount], [m_cluster memberCount]]];
		[m_memberTable reloadData];
	}
	return NO;
}

- (BOOL)handleClusterBatchGetCardOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId])
		[m_memberTable reloadData];
	return NO;
}

- (BOOL)handleClusterGetInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId] || ![m_cluster permanent] && [packet internalId] == [m_cluster parentId]) {
		[m_txtOnline setStringValue:[NSString stringWithFormat:@"%u/%u", [m_cluster onlineMemberCount], [m_cluster memberCount]]];
		[m_memberTable reloadData];
		if([m_cluster permanent]) {
			NSString* notice = [[[m_cluster info] notice] normalize];
			[m_txtNotice setStringValue:notice];
			[m_txtNotice setToolTip:notice];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerModelDidChangedNotificationName
															object:m_cluster];
	}
	
	return NO;
}

- (BOOL)handleClusterSendIMOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// remove message from queue
		ClusterSendIMExPacket* request = (ClusterSendIMExPacket*)[event outPacket];
		if([request fragmentCount] == [request fragmentIndex] + 1)
			[m_sendQueue removeObjectAtIndex:0];
		
		// send next
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleClusterSendIMFailed:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet sequence] == m_waitingSequence) {
		// remove message from queue
		[m_sendQueue removeObjectAtIndex:0];
		
		// send next
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleTempClusterSendIMOK:(QQNotification*)event {
	return [self handleClusterSendIMOK:event];
}

- (BOOL)handleTempClusterSendIMFailed:(QQNotification*)event {
	return [self handleClusterSendIMFailed:event];
}

- (BOOL)handleTempClusterSendIMTimeout:(QQNotification*)event {
	return [self handleClusterSendIMTimeout:event];
}

- (BOOL)handleClusterSendIMTimeout:(QQNotification*)event {
	ClusterSendIMExPacket* packet = (ClusterSendIMExPacket*)[event outPacket];
	if([packet sequence] == m_waitingSequence) {
		// get message from queue
		NSAttributedString* message = [[m_sendQueue objectAtIndex:0] retain];
		
		// remove message
		[m_sendQueue removeObjectAtIndex:0];
		
		// change fragment index, so we can skip the timeout message
		m_nextFragmentIndex = m_fragmentCount;
		
		// append timeout hint to output text view
		NSAttributedString* string = [[NSAttributedString alloc] initWithString:L(@"LQHintTimeoutHeader", @"BaseIMContainer")
																	 attributes:m_errorHintAttributes];
		[[m_txtOutput textStorage] appendAttributedString:string];
		[string release];
		[[m_txtOutput textStorage] appendAttributedString:message];
		[message release];
		string = [[NSAttributedString alloc] initWithString:L(@"LQHintTimeoutTail", @"BaseIMContainer")
												 attributes:m_errorHintAttributes];
		[[m_txtOutput textStorage] appendAttributedString:string];
		[string release];
		
		// send next
		[self sendNextMessage];
		return YES;
	}
	return NO;
}

- (BOOL)handleTempClusterGetInfoOK:(QQNotification*)event {
	ClusterCommandReplyPacket* packet = [event object];
	if([packet internalId] == [m_cluster internalId]) {
		[m_txtOnline setStringValue:[NSString stringWithFormat:@"%u/%u", [m_cluster onlineMemberCount], [m_cluster memberCount]]];
		[m_memberTable reloadData];
		[[NSNotificationCenter defaultCenter] postNotificationName:kIMContainerModelDidChangedNotificationName
															object:m_cluster];
	}
	
	return NO;
}

#pragma mark -
#pragma mark menu delegate

- (int)numberOfItemsInMenu:(NSMenu *)menu {
	return [[menu itemArray] count];
}

- (BOOL)menu:(NSMenu *)menu updateItem:(NSMenuItem *)item atIndex:(int)index shouldCancel:(BOOL)shouldCancel {
	if(menu == m_memberMenu) {
		User* user = [m_cluster memberAtIndex:[m_memberTable selectedRow]];
		if(user == nil)
			[item setEnabled:NO];
		else {
			switch([item tag]) {
				case _kMenuItemTagAddAsFriend:
					[item setEnabled:![[m_mainWindowController groupManager] isUserFriendly:user]];
					break;
				default:
					[item setEnabled:YES];
					break;
			}
		}
	}
	
	return YES;
}

@end
