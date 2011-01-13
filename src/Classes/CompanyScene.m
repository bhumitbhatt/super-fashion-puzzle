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

#import "CompanyScene.h"
#import "SoundManager.h"
#import "MenuMainScene.h"
#import "Constants.h"

@implementation CompanyScene

-(id) init
{
	if( (self=[super init] )) {
		// background sprite
		CCSprite *company=[CCSprite spriteWithFile:@"shinobigames_logo.pvr"];
		company.position=ccp(240,160);
		[self addChild: company];
	}
	return self;
}

-(void) update: (ccTime) dt {
	[self unschedule:@selector(update:)];
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene]];
}

-(void) onEnter
{
	NSLog(@"CompanyScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"CompanyScene: transition did finish");
	// run sound manager (that forces sound loading, it takes a while)
	[[SoundManager sharedSoundManager] showVersion];
	[self schedule:@selector(update:)];
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"CompanyScene onExit");
	[[SoundManager sharedSoundManager] playSoundMusicMenu];
	[super onExit];
}

- (void) dealloc
{
	NSLog(@"deallocating CompanyScene.");
	[super dealloc];
}
@end
