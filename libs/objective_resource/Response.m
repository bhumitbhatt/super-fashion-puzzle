//
//  Response.m
//  
//
//  Created by Ryan Daigle on 7/30/08.
//  Copyright 2008 yFactorial, LLC. All rights reserved.
//

#import "Response.h"
#import "NSHTTPURLResponse+Error.h"

@implementation Response

@synthesize body, headers, statusCode, error;

+ (id)responseFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
	return [[[self alloc] initFrom:response withBody:data andError:aError] autorelease];
}

- (void)normalizeError:(NSError *)aError withBody:(NSData *)data{
	switch ([aError code]) {
		case NSURLErrorUserCancelledAuthentication:
			self.statusCode = 401;
			self.error = [NSHTTPURLResponse buildResponseError:401 withBody:data];
			break;
		default:
			self.error = aError;
			break;
	}
}

- (id)initFrom:(NSHTTPURLResponse *)response withBody:(NSData *)data andError:(NSError *)aError {
	[self init];
	self.body = data;
	if(response) {
		self.statusCode = [response statusCode];
		self.headers = [response allHeaderFields];
		self.error = [response errorWithBody:data];
	}
	else {
		[self normalizeError:aError withBody:data];
	}
	return self;
}

- (BOOL)isSuccess {
	return statusCode >= 200 && statusCode < 400;
}

- (BOOL)isError {
	return ![self isSuccess];
}

- (void)log {
	if ([self isSuccess]) {
		debugLog(@"<= %@", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
	}
	else {
		NSLog(@"<= %@", [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
	}
}

#pragma mark cleanup

- (void) dealloc
{
	[body release];
	[headers release];
  [error release];
	[super dealloc];
}


@end
