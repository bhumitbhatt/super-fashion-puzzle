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

#import "PlayingScene.h"
#import "PauseScene.h"
#import "GameOverScene.h"
#import "TimeBar.h"
#import "SoundManager.h"
#import "Constants.h"

@implementation PlayingScene

// used by m_board
@synthesize m_backgroundGirls;
@synthesize m_timeBar;
@synthesize m_levelLabel;
@synthesize m_scoreLabel;
@synthesize m_girlTransition;

-(id) init
{
	if( (self=[super init] )) {
	
		// board
		m_board=[[Board alloc] initWithPlayingScene:self];
		m_board.position=ccp(480-320*0.5,160);
		[self addChild: m_board];
		
		// background girls
		m_backgroundGirls=[[BackgroundGirls alloc] init];
		m_backgroundGirls.position = ccp(125*0.5, 160);
		[self addChild:m_backgroundGirls];
		
		// add time bar
		m_timeBar=[[TimeBar alloc] initWithPlayingScene:self];
		m_timeBar.position = ccp(125+35*0.5, 160);
		[self addChild:m_timeBar];

		// score and level label
		m_score_and_level_sprite=[[CCSprite spriteWithFile:@"level_and_score_texture.png"] retain];
		m_score_and_level_sprite.position=ccp(120*0.5,45*0.5);
		[self addChild: m_score_and_level_sprite];
	
		// pause button
        CCMenuItem* pauseItem = [CCMenuItemImage 
			itemFromNormalImage:@"pause_button_released.png" 
			selectedImage:@"pause_button_pressed.png" 
			target:self 
			selector:@selector(pauseButtonPressed:)
		];
		pauseItem.position = CGPointZero;
        m_pauseMenu = [[CCMenu menuWithItems:pauseItem, nil] retain];
		m_pauseMenu.position = ccp(20, 300);
        [self addChild:m_pauseMenu];
		
		// level label
		m_levelLabel=[[UIntegerLabel alloc] initWithFontSize:15 Offset:1 FontName:@"Helvetica" ForegroundColor:ccWHITE BackgroundColor:ccBLACK];
		[m_levelLabel setUInteger:1];
        m_levelLabel.position=ccp(36, 32);
        [self addChild:m_levelLabel];
		
		// score label
		m_scoreLabel=[[UIntegerLabel alloc] initWithFontSize:15 Offset:1 FontName:@"Helvetica" ForegroundColor:ccWHITE BackgroundColor:ccBLACK];
		[m_scoreLabel setUInteger:0];
        m_scoreLabel.position =  ccp(36, 14);
        [self addChild:m_scoreLabel];
	
		// ready sprite
		m_readySprite=[[CCSprite spriteWithFile:@"ready_texture.png"] retain];
		m_readySprite.visible=NO;
		[self addChild: m_readySprite];

		// gameover sprite
		m_gameOverSprite=[[CCSprite spriteWithFile:@"game_over_label.png"] retain];
		m_gameOverSprite.visible=NO;
		m_gameOverSprite.position=ccp(240,250);
		[self addChild: m_gameOverSprite];
		
		// used for girl transition
		m_girlTransition=[[CCSprite spriteWithFile:@"change_girl_transition.pvr"] retain];
		m_girlTransition.visible=NO;
		m_girlTransition.position=ccp(240,160);
		[m_girlTransition setOpacity:0];
		[self addChild:m_girlTransition];
		
		// game layout
		[self checkGameLayout];
		
		// start the game and start both FSMs
		[self reset];
	}
	return self;
}

-(void) pauseButtonPressed: (id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	if (m_state==PLAYING) [self changeGameState:PAUSED];
}

/*!
Reset all game components in order to start a new game.
*/
-(void) reset {
	[m_backgroundGirls setGirlNumber:0];
	[m_board reset];
	[m_board regenerate:0];
	[m_timeBar reset];
	[m_levelLabel setUInteger:0];
	[m_scoreLabel setUInteger:0];
	m_gameOverSprite.visible=NO;
	m_readySprite.position=ccp(-m_readySprite.textureRect.size.width*0.5, 150);
	m_playedTooMuch=NO;
	
	// vars for "game" FSM
	m_state=STARTING_STATE_GS;
	
	[self changeGameState:READY];
}

/*!
Used by Board. 
*/
-(unsigned int) getLevel {
	return [m_levelLabel getUInteger];
}

-(void) readySequenceFinished:(id)sender {
	[self changeGameState:PLAYING];
}

/*!
Called by TimeBar when time is up. Callback method.
*/
-(void) timeUp {
	[self changeGameState:GAME_OVER];
}

/*!
Played too much. Called only in free version 
*/
-(void) playedTooMuch {
	m_playedTooMuch=YES;
	[self changeGameState:GAME_OVER];
}

/*!
Called in the middle of ready sequence.
*/
-(void) playReadySoundFX:(id)sender {
	[[SoundManager sharedSoundManager] playSoundFxReady];
}

/*!
Called after game over animation
*/
-(void) gameOverAnmationFinished:(id)sender {
	[self changeGameState:ENDING_STATE_GS];
}

-(void) onEnter
{
	NSLog(@"PlayingScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{	
	NSLog(@"PlayingScene: transition did finish");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResginActive) name:UIApplicationWillResignActiveNotification object:nil];
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"PlayingScene onExit");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super onExit];
}

-(void) applicationWillResginActive {
	NSLog(@"applicationWillResginActive");
	if ([self isPlaying]) 
		[self changeGameState:PAUSE_BY_LOCK];
}

-(void) onEnterGameState:(GameState)state {
	if (state==STARTING_STATE_GS) {

	} else if (state==READY) {
		// an animation with 3 parts, and eventually a method call (in order to transitate to next state) 
#define READY_FIRST_STAGE_DURATION 1.5
#define READY_SECOND_STAGE_DURATION 0.5
#define READY_THIRD_STAGE_DURATION 0.5
		
		// part 1
		id auxFirstAction = [CCSpawn actions:
							 //[CCRotateBy actionWithDuration:READY_FIRST_AND_THIRD_STAGE_DURATION angle: 360],
							 [CCEaseElasticOut actionWithAction:[CCMoveTo actionWithDuration:READY_FIRST_STAGE_DURATION position:ccp(240,200)]],
							 //CCEaseElasticOut CCEaseBounceOut CCEaseBackOut
							 //[CCMoveTo actionWithDuration:READY_FIRST_STAGE_DURATION position:ccp(240,200)],
							 [CCFadeIn actionWithDuration:READY_FIRST_STAGE_DURATION],
							 nil];
		
		id firstAction = [CCSequence actions:
						  auxFirstAction,
						  [CCCallFunc actionWithTarget:self selector:@selector(playReadySoundFX:)], 
						  nil];
		
		// part 2, formed by 2 parts
		id auxAction = [CCScaleBy actionWithDuration: READY_SECOND_STAGE_DURATION*0.5 scale:1.4];
		id auxAction2 = [CCSequence actions:auxAction,[auxAction reverse], nil];
		id secondAction=[CCEaseSineInOut actionWithAction:auxAction2];
		
		// part 3
		id thirdAction = [CCSpawn actions:
						  [CCEaseBackIn actionWithAction:[CCMoveTo actionWithDuration:READY_THIRD_STAGE_DURATION position:ccp(480+m_readySprite.textureRect.size.width*0.5, 250)]],
						  [CCFadeOut actionWithDuration:READY_THIRD_STAGE_DURATION],
						  nil];
		
		// final animation or action
		id finalAction = [CCSequence actions:
						  [CCShow action],
						  firstAction, 
						  secondAction, 
						  thirdAction, 
						  [CCHide action],
						  //[CCPlace actionWithPosition:ccp(-m_readySprite.textureRect.size.width*0.5, 150)],
						  [CCCallFunc actionWithTarget:self selector:@selector(readySequenceFinished:)],
						  nil];
		
		[m_readySprite runAction:finalAction];
		
	} else if (state==PLAYING) {
		[[SoundManager sharedSoundManager] playSoundMusicGame];
		
	} else if (state==PAUSED) {
		//[[SoundManager sharedSoundManager] stopBackgroundMusic];
		
	} else if (state==PAUSE_BY_LOCK) {
		
		
	} else if (state==GAME_OVER) {
		m_gameOverSprite.position=ccp(240, 320+m_gameOverSprite.textureRect.size.height*0.5);
		[[SoundManager sharedSoundManager] playSoundFxGameOver];
		
	} else if (state==ENDING_STATE_GS) {
		
	} else {
		NSLog(@"Unknown Game state onEnterGameState.");
	}
}

-(void) onExitGameState:(GameState)state {
	if (state==STARTING_STATE_GS) {
		
	} else if (state==READY) {
		
	} else if (state==PLAYING) {
		[[SoundManager sharedSoundManager] stopBackgroundMusic];
		
	} else if (state==PAUSED) {
		
	} else if (state==PAUSE_BY_LOCK) {
		
	} else if (state==GAME_OVER) {
		[m_timeBar deactivate];
		
	} else if (state==ENDING_STATE_GS) {
		m_gameOverSprite.visible=NO;
		
	} else {
		NSLog(@"Unknown Game state onExitGameState.");
	}
} 

-(void) changeGameState:(GameState)state {
	[self onExitGameState:m_state];
	if (m_state==STARTING_STATE_GS && state==READY) {
		
	} else if (m_state==READY && state==PLAYING) {
		//m_readySprite.visible=NO;
		[m_timeBar activate];
	
	} else if (m_state==PLAYING && state==PAUSED) {
		[m_timeBar deactivate];
		PauseScene* pauseScene=[PauseScene node];
		pauseScene.m_playingScene=self;
		[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:pauseScene withColor:ccWHITE]];
		
	} else if (m_state==PAUSED && state==PLAYING) {
		[m_timeBar activate];
	
	} else if (m_state==PLAYING && state==PAUSE_BY_LOCK) {
		[m_timeBar deactivate];
		PauseScene* pauseScene=[PauseScene node];
		pauseScene.m_playingScene=self;
		[[CCDirector sharedDirector] pushScene:pauseScene];
		
	} else if (m_state==PAUSE_BY_LOCK && state==PLAYING) {
		[m_timeBar activate];
	
	} else if (m_state==PLAYING && state==GAME_OVER) {
		
#define GAME_OVER_ANIMATION_DURATION 1.5
		
		id actionWithBounce=[CCEaseBounceOut actionWithAction:
			[CCMoveTo actionWithDuration:GAME_OVER_ANIMATION_DURATION position:ccp(240,250)]
		];
		
		id actions=[CCSpawn actions:
			actionWithBounce,
			[CCFadeIn actionWithDuration:GAME_OVER_ANIMATION_DURATION],
			nil];
		
		id finalAction = [CCSequence actions:
					[CCShow action],
					actions,
					[CCCallFunc actionWithTarget:self selector:@selector(gameOverAnmationFinished:)], 
					nil];
		[m_gameOverSprite runAction:finalAction];
		
	} else if (m_state==GAME_OVER && state==ENDING_STATE_GS) {
		GameOverScene* gameOverScene=[GameOverScene node];
		gameOverScene.m_playedTooMuch=m_playedTooMuch;
		[gameOverScene setCurrentScore:[m_scoreLabel getUInteger]];
		gameOverScene.m_level=[m_levelLabel getUInteger];
		gameOverScene.m_playingScene=self;
		//[self end];
		[[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:gameOverScene withColor:ccWHITE]];
		
	} else {
		NSLog(@"Unknown transition in Game object.");
		exit(1);
	}
	m_state=state;
	[self onEnterGameState:state];
}

/*!
Used by board.
*/
-(bool) isPlaying {
	return m_state==PLAYING;
}

// called when resume button in pause menu is pressed
-(void) onResume {
	NSLog(@"resume");	
	[self checkGameLayout];
	[self changeGameState:PLAYING];	
}

/*!
Re-layout game components.
Called at start up and after options menu was used.
*/
-(void) checkGameLayout {
	BOOL boardAtTheLeft=[[NSUserDefaults standardUserDefaults] boolForKey:@"boardAtTheLeft"];
	if (boardAtTheLeft) {
		 m_board.position=ccp(320*0.5,160);
		 m_backgroundGirls.position=ccp(480-125*0.5, 160);
		 m_timeBar.position=ccp(480-125-35*0.5, 160);
		 m_score_and_level_sprite.position=ccp(480-120*0.5-5,45*0.5);
		 m_pauseMenu.position=ccp(480-20, 300);
		 m_levelLabel.position=ccp(480-89, 32);
		 m_scoreLabel.position=ccp(480-89, 14);
	} else { // board at the right
		m_board.position=ccp(480-320*0.5,160);
		m_backgroundGirls.position=ccp(125*0.5, 160);
		m_timeBar.position=ccp(125+35*0.5, 160);
		m_score_and_level_sprite.position=ccp(120*0.5,45*0.5);
		m_pauseMenu.position=ccp(20, 300);
		m_levelLabel.position=ccp(36, 32);
		m_scoreLabel.position=ccp(36, 14);
	}
}

- (void) dealloc
{		
	NSLog(@"deallocating PlayingScene.");
	[m_pauseMenu release];
	[m_gameOverSprite release];
	[m_timeBar release];
	[m_readySprite release];
	[m_backgroundGirls release];
	[m_scoreLabel release];
	[m_levelLabel release];
	[m_score_and_level_sprite release];
	[m_board release];
	[m_girlTransition release];
	[super dealloc];
}
@end
