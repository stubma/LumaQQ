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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

#import "JobController.h"
#import "JobDelegate.h"

@implementation JobController

- (id)initWithMain:(MainWindowController*)main {
	self = [super init];
	if (self != nil) {
		m_main = [main retain];
		m_jobs = [[NSMutableDictionary dictionary] retain];
	}
	return self;
}

- (void) dealloc {
	[m_main release];
	[m_jobs release];
	[super dealloc];
}

- (void)startJob:(id<Job>)job {
	[job setJobDelegate:self];
	[m_jobs setObject:job forKey:[job jobName]];
	[job startJob:m_main];
}

- (BOOL)hasJob:(NSString*)name {
	return [m_jobs objectForKey:name] != nil;
}

- (void)jobFinished:(id<Job>)job {
	// start link job
	NSArray* linkJobs = [job getLinkJobs];
	NSEnumerator* e = [linkJobs objectEnumerator];
	while(id<Job> job = [e nextObject])
		[self startJob:job];
	
	// release finished job
	[job dispose:m_main];
	[m_jobs removeObjectForKey:[job jobName]];
}

- (void)terminate {
	NSEnumerator* e = [m_jobs objectEnumerator];
	while(id<Job> job = [e nextObject]) {
		[job dispose:m_main];
	}
	[m_jobs removeAllObjects];
}

@end
