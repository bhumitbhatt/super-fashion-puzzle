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

#import "LoadingGameScene.h"
#import "SoundManager.h"
#import "PlayingScene.h"
#import "Constants.h"

@implementation LoadingGameScene

-(id) init
{
	if( (self=[super init] )) {
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"loading_screen.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
	}
	return self;
}

-(void) onEnter
{
	NSLog(@"LoadingScene onEnter");
	[super onEnter];	
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"LoadingScene: transition did finish");
	[self schedule:@selector(update:)];
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	//[[SoundManager sharedSoundManager] stopSoundMusicMenu];
	NSLog(@"LoadingScene onExit");
	[super onExit];
}

-(void) update: (ccTime) dt {
	[self unschedule:@selector(update:)];
	PlayingScene* playingScene=[PlayingScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:playingScene withColor:ccWHITE]];		
}

- (void) dealloc
{	
	NSLog(@"deallocating LoadingGameScene.");
	[super dealloc];
}

@end
