//
//  MPLoginItems.m
//  Bowtie
//
//  Created by Matt Patenaude on 9/2/09.
//  Copyright (C) 2009 - 10 Matt Patenaude.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "MPLoginItems.h"


@implementation MPLoginItems

#pragma mark Methods
+ (NSArray *)loginItems
{
	UInt32 seedValue;
	
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	NSArray *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
	
	NSMutableArray *items = [NSMutableArray array];
	for (id item in loginItemsArray)
	{
		NSURL *thePath;
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef *)&thePath, NULL) == noErr)
			[items addObject:thePath];
			
	}
	CFRelease(loginItems);
	[loginItemsArray release];
	
	return items;
}
+ (BOOL)loginItemExists:(NSURL *)theURL
{
	NSArray *loginItems = [self loginItems];
	
	BOOL found = NO;
	for (NSURL *item in loginItems)
	{
		if ([[item path] hasPrefix:[theURL path]])
		{
			found = YES;
			break;
		}
	}
	
	return found;
}
+ (void)addLoginItemWithURL:(NSURL *)theURL
{
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, (CFURLRef)theURL, NULL, NULL);		
	if (item)
		CFRelease(item);
}
+ (void)removeLoginItemWithURL:(NSURL *)theURL
{
	UInt32 seedValue;
	
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	NSArray *loginItemsArray = (NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
	for (id item in loginItemsArray)
	{
		NSURL *thePath;
		LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
		if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef *)&thePath, NULL) == noErr)
		{
			if ([[(NSURL *)thePath path] hasPrefix:[theURL path]])
				LSSharedFileListItemRemove(loginItems, itemRef);
		}
	}
	
	CFRelease(loginItems);
	[loginItemsArray release];
}

@end
