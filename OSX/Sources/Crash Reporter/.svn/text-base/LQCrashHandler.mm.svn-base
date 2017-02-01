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

#import "LQCrashHandler.h"

static LQCrashHandler *sharedCrashController = nil;

// when crash, notify delegate
void _crashHandler(int i) {
	[sharedCrashController applicationWillCrash];
	exit(-1);
}

@implementation LQCrashHandler

+ (void)enableCrashCatching:(id)delegate selector:(SEL)selector {
	if (!sharedCrashController) {
		sharedCrashController = [[LQCrashHandler alloc] initWithDelegate:delegate selector:selector];
	}
}

- (void) dealloc {
	[m_delegate release];
	[super dealloc];
}

- (id)initWithDelegate:(id)delegate selector:(SEL)selector {
	if ((self = [super init])) {		
		m_delegate = [delegate retain];
		m_selector = selector;
		
		//Install custom handlers which properly terminate this application if one is received
		signal(SIGILL,  _crashHandler);	/* 4:   illegal instruction (not reset when caught) */
		signal(SIGTRAP, _crashHandler);	/* 5:   trace trap (not reset when caught) */
		signal(SIGEMT,  _crashHandler);	/* 7:   EMT instruction */
		signal(SIGFPE,  _crashHandler);	/* 8:   floating point exception */
		signal(SIGBUS,  _crashHandler);	/* 10:  bus error */
		signal(SIGSEGV, _crashHandler);	/* 11:  segmentation violation */
		signal(SIGSYS,  _crashHandler);	/* 12:  bad argument to system call */
		signal(SIGXCPU, _crashHandler);	/* 24:  exceeded CPU time limit */
		signal(SIGXFSZ, _crashHandler);	/* 25:  exceeded file size limit */
		
		// I think SIGABRT is an exception... we should ignore it.
		signal(SIGABRT, SIG_IGN);
	}
	
	return self;
}

- (void)applicationWillCrash {
	[m_delegate performSelector:m_selector];
}

@end
