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

#import "JobController.h"
#import "JobDelegate.h"
#import "Constants.h"
#import "Job.h"

@implementation JobController

- (id)initWithContext:(NSMutableDictionary*)context {
	self = [super init];
	if (self != nil) {
		_context = [context retain];
		_jobs = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[_context release];
	[_jobs release];
	[_target release];
	[super dealloc];
}

- (void)startJob:(id<Job>)job {
	[[self client] addQQListener:job];
	[job setJobDelegate:self];
	[_jobs setObject:job forKey:[job jobName]];
	[job startJob];
}

- (BOOL)hasJob:(NSString*)name {
	return [_jobs objectForKey:name] != nil;
}

- (void)jobFinished:(id<Job>)job {
	// remove qq listener
	[[self client] removeQQListener:job];
	
	// start link job
	id<Job> j;
	NSArray* linkJobs = [job getLinkJobs];
	NSEnumerator* e = [linkJobs objectEnumerator];
	while(j = [e nextObject])
		[self startJob:j];
	
	// release finished job
	[job dispose];
	[_jobs removeObjectForKey:[job jobName]];
	
	if([_jobs count] == 0) {
		if(_target != nil)
			[_target performSelector:_action withObject:self];
	}
}

- (void)terminate {
	id<Job> job;
	NSEnumerator* e = [_jobs objectEnumerator];
	while(job = [e nextObject]) {
		[[self client] removeQQListener:job];
		[job dispose];
	}
	[_jobs removeAllObjects];
	
	if(_target != nil)
		[_target performSelector:_action withObject:self];
}

- (void)setTarget:(id)target {
	[target retain];
	[_target retain];
	_target = target;
}

- (void)setAction:(SEL)action {
	_action = action;
}

- (QQClient*)client {
	return [_context objectForKey:kDataKeyClient];
}

- (GroupManager*)groupManager {
	return [_context objectForKey:kDataKeyGroupManager];
}

@end
