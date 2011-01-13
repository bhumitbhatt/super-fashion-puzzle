//
//  Copyright (C) Ricardo Ruiz López, 2010. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "FacebookManager.h"

@implementation FacebookManager

@synthesize m_statusString;
@synthesize statusDelegate;
@synthesize sessionDelegate;

// singleton stuff
static FacebookManager* m_sharedFacebookManager = nil;

+ (FacebookManager*) sharedFacebookManager
{
	if (m_sharedFacebookManager==nil) 
		m_sharedFacebookManager=[[FacebookManager alloc] init];
	return m_sharedFacebookManager;
}

+(id)alloc
{
	NSAssert(m_sharedFacebookManager==nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(void) showVersion {
	NSLog(@"FacebookManager. FBConnect version: %@.", kFB_SDK_VersionNumber);
}

-(id) init {
	self=[super init];
	if (self!=nil) {
		m_session=[[FBSession sessionForApplication:@"3b76b895020215856b021f45f3c8e3b5" secret:@"4c2718e144e3c009a41eb67599277174" delegate:self] retain];
		[m_session resume];
		self.m_statusString=@"No status message.";
		statusDelegate=nil;
		sessionDelegate=nil;
		m_logging=NO;
		m_settingStatus=NO;
		m_setStatusAfterLogin=NO;
	}
	return self;
}

-(BOOL) isConnected {
	return m_session.isConnected;
}

-(void) login {
	if (!m_session.isConnected && !m_logging && !m_settingStatus) {
		m_logging=YES;
		FBLoginDialog* dialog=[[[FBLoginDialog alloc] initWithSession:m_session] autorelease];
		dialog.delegate=self;
		[dialog show];
	} else {
		NSLog(@"login not possible now.");
	}
}

-(void) logout {
	if (m_session.isConnected && !m_logging && !m_settingStatus) {
			[m_session logout];
	} else {
		NSLog(@"logout not possible now.");
	}
}

/*!
Called by "GameOverScene" in order to write something on user's wall.

Eventually this method will execute one of these callbacks:
statusChanged
statusChangedDidFail
 
Maybe a login dialog or a permission dialog may appear between calling this method and its callbacks.
*/
-(void) setStatus:(NSString*)statusString {
	if (m_logging || m_settingStatus) {
		NSLog(@"It's been logged or setting status.");
		return;
	}
	
	self.m_statusString=statusString;
	if ([self isConnected]) {
		[self checkForPermission];
	} else {
		m_setStatusAfterLogin=YES;
		m_logging=YES;
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:m_session] autorelease];
		dialog.delegate=self;
		[dialog show];
	}
}

- (void) dealloc
{
	[m_statusString release];
	[m_session release];
	[super dealloc];
}

/*!
Before writing on wall, we have to know if we have permission, otherwise, just ask for it. 
Starts writing on wall sequence.
*/
- (void) checkForPermission {
	//NSLog(@"[facebookCheckForPermission] make a call");
	if (!m_settingStatus) {
		m_settingStatus=YES;
		NSDictionary *d=[NSDictionary dictionaryWithObjectsAndKeys: @"status_update", @"ext_perm", nil];
		[[FBRequest requestWithSession:m_session delegate: self] call: @"facebook.users.hasAppPermission" params: d];
		
	} else {
		NSLog(@"Cannont start setStatus sequence, already started.");
	}
}

- (void) updateUserStatus {
	//NSLog(@"[facebookUpdateUserStatus] updating status");
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: m_statusString,@"status", @"true", @"status_includes_verb", nil]; 
	FBRequest* updateRequest = [FBRequest requestWithSession:m_session delegate:self];
	[updateRequest call: @"facebook.Users.setStatus" params: params];
}

////////////////////////////
// FBDialogDelegate
////////////////////////////
#pragma mark FBDialogDelegate delegate methods
- (void)dialogDidSucceed:(FBDialog *)dialog {
	if ([dialog isMemberOfClass:[FBPermissionDialog class]]) {
		//NSLog(@"[FBPermissionDialog::dialogDidSucceed] update user status");
		[self updateUserStatus];
	}
}

- (void)dialogDidCancel:(FBDialog *)dialog {
	if ([dialog isMemberOfClass:[FBPermissionDialog class]]) {
		//NSLog(@"dialogDidCancel:dialog FBPermissionDialog");
		if (m_settingStatus) {
			m_settingStatus=NO;
			if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:@"FBPermissionDialog was cancelled."];
		}
	}
}

- (void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error {
	//NSLog(@"dialog:%@ didFailWithError:%@", dialog, error); 
	if ([dialog isMemberOfClass:[FBPermissionDialog class]]) {
		//NSLog(@"dialog:didFailWithError FBPermissionDialog");
		if (m_settingStatus) {
			m_settingStatus=NO;
			if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:@"FBPermissionDialog failed."];
		}
	}
}

////////////////////////////
// FBSessionDelegate
////////////////////////////
#pragma mark FBSessionDelegate delegate methods
- (void)session:(FBSession *)session didLogin:(FBUID)uid {
	//NSLog(@"User with id %lld logged in.", uid);
	if (m_logging) {
		m_logging=NO;
		if (sessionDelegate!=nil) [sessionDelegate sessionDidLogin];
	}
	if (m_setStatusAfterLogin) {
		m_setStatusAfterLogin=NO;
		[self checkForPermission];
	}
}

- (void)sessionDidNotLogin:(FBSession*)session {
	//NSLog(@"sessionDidNotLogin");
	if (m_logging) {
		m_logging=NO;
		if (sessionDelegate!=nil) [sessionDelegate sessionDidNotLogin:@"Login failed."];
	}
	if (m_setStatusAfterLogin) {
		m_setStatusAfterLogin=NO;
		if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:@"Session did not login"];
	}
}

- (void)sessionDidLogout:(FBSession*)session {
	//NSLog(@"sessionDidLogout");
	if (sessionDelegate!=nil) [sessionDelegate sessionDidLogout];
}

////////////////////////////
// FBRequestDelegate
////////////////////////////
#pragma mark FBRequestDelegate delegate methods
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
	//NSLog(@"request:didReceiveResponse");
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method caseInsensitiveCompare:@"facebook.Users.hasAppPermission"]==NSOrderedSame) {
		//m_permissionForSetStatus=NO;
		if ([@"1" isEqualToString: result]) {
			// post comment
			//NSLog(@"[Users.hasAppPermission::dialogDidSucceed] succeed, try to update status");
			[self updateUserStatus];
		} else {
			// show dialog
			//NSLog(@"[Users.hasAppPermission::dialogDidSucceed] fail, show dialog");
			FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease]; 
			dialog.delegate = self; 
			dialog.permission = @"status_update"; 
			[dialog show];
		}
	} else if ([request.method caseInsensitiveCompare:@"facebook.Users.setStatus"]==NSOrderedSame) {
		if ([@"1" isEqualToString: result]) {
			//NSLog(@"facebook update did succeed");
			if (m_settingStatus) {
				m_settingStatus=NO;
				//[m_timer invalidate];
				//m_timer=nil;
				if (statusDelegate!=nil) [statusDelegate statusChanged];
			}
		} else {
			//NSLog(@"facebook update did fail");
			if (m_settingStatus) {
				m_settingStatus=NO;
				//[m_timer invalidate];
				//m_timer=nil;
				if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:@"Update request failed."];
			}
		}
	}
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	//NSLog(@"request:didFailWithError: %@. Request: %@", [error localizedDescription], request.method);
	if ([request.method caseInsensitiveCompare:@"facebook.Users.setStatus"]==NSOrderedSame) {
		if (m_settingStatus) {
			m_settingStatus=NO;
			if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:[error localizedDescription]];
		}
	}
}

- (void)requestWasCancelled:(FBRequest*)request {
	//NSLog(@"requestWasCancelled: %@. Request: %@", [error localizedDescription], request.method);
	if ([request.method caseInsensitiveCompare:@"facebook.Users.setStatus"]==NSOrderedSame) {
		if (m_settingStatus) {
			m_settingStatus=NO;
			if (statusDelegate!=nil) [statusDelegate statusChangedDidFail:@"setStatus request was cancelled"];
		}
	}
}

@end
