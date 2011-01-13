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

#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"
#import "FacebookStatusDelegate.h"
#import "FacebookSessionDelegate.h"

/*!
Singleton that internally manages session, login/logout and permission dialog.
Use:
Call setStatus from FacebookManager.
Then wait (use a waiting screen) until statusChangedProperly or statusChangedDidFail callbacks are called.
 
Warning: Do not forget to edit kTimeoutInterval from FBRequest.m. 
Initial value is 180 (3 minutes). Use a better value, 12 seconds for instance.
*/
@interface FacebookManager : NSObject <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate> {
	FBSession* m_session;
	NSString* m_statusString;
	BOOL m_logging; // true while loging is been done
	BOOL m_settingStatus; // true while status is been written 
	BOOL m_setStatusAfterLogin; // maybe after loging we want to change status
	id <FacebookStatusDelegate> statusDelegate;
	id <FacebookSessionDelegate> sessionDelegate;
}
@property (nonatomic, retain) NSString* m_statusString;
@property (nonatomic,assign) id<FacebookStatusDelegate> statusDelegate;
@property (nonatomic,assign) id<FacebookSessionDelegate> sessionDelegate;

+(FacebookManager*) sharedFacebookManager;
+(id) alloc;
-(void) showVersion;
-(BOOL) isConnected;

-(void) login;
-(void) logout;

-(void) setStatus:(NSString*)statusString;
- (void) checkForPermission;
- (void) updateUserStatus;

@end






