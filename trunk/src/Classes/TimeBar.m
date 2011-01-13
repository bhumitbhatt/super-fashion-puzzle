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

#import "TimeBar.h"
#import "PlayingScene.h"
#import "Constants.h"

@implementation TimeBar

// init when a game is restored from a saved file
-(id) initWithPlayingScene:(PlayingScene*)playingScene {
	if( (self=[super init] )) {
		
		// background
		CCSprite* background=[CCSprite spriteWithFile:@"time_bar_background.png"];
		[self addChild: background];
		
		// time bar
		m_timeBarSprite=[[CCSprite spriteWithFile:@"time_bar.png"] retain];
		m_timeBarSprite.position=ccp(0,0);
		[self addChild: m_timeBarSprite];
		
		// foreground
		CCSprite* foreground=[CCSprite spriteWithFile:@"time_foreground.png"];
		[self addChild: foreground];
		
		// setup time and time bar sprite
		m_duration=TIMEBAR_DURATION_IN_EASY_MODE;
		m_leftTime=m_duration;
		m_playingScene=playingScene;
	}
	return self;
}

-(void) setDuration:(float)duration {
	m_duration=duration;
	if (m_leftTime>m_duration) 
		m_leftTime=m_duration;
}

-(void) activate {
	m_isActivated=YES;
}

-(void) deactivate {
	m_isActivated=NO;
}

-(void) onEnter
{
	NSLog(@"timer onEnter");
	[self schedule:@selector(update:)];
	[super onEnter];
}

-(void) onExit
{
	NSLog(@"timer onExit");
	[self unschedule:@selector(update:)];
	[super onExit];
}

// m_timeBar position is in relationship with m_timeLeft and MAX_TIME
// When there is no time left, timeUp method s called in PlayingScene object
-(void) update:(ccTime)dt {	
	if (!m_isActivated) return;	
	m_leftTime=m_leftTime-dt;
	if (m_leftTime<0) m_leftTime=0;
	// factor 1 -> posy=0 (you see a full bar)
	// factor 0 -> posy=-320 (time bar is down, not showed)
	float factor=m_leftTime/m_duration;
	m_timeBarSprite.position=ccp(0, factor*320-320);

	if (m_leftTime==0) {
		m_isActivated=NO;
		// notify to PlayingGame
		[m_playingScene timeUp];
	}
}

-(void) addSomeTime:(float)amount {
	m_leftTime=m_leftTime+amount;
	if (m_leftTime>m_duration) m_leftTime=m_duration;
}

-(void) removeSomeTime:(float)amount {
	m_leftTime=m_leftTime-amount;
	if (m_leftTime<0) m_leftTime=0;
}

/*!
 called when user selects "play again"
 */
-(void) reset {
	m_isActivated=NO;
	m_leftTime=TIMEBAR_DURATION_IN_EASY_MODE;
	m_timeBarSprite.position=ccp(0, 0);
}

-(void) dealloc {
	[m_timeBarSprite release];
	[super dealloc];
}
@end
