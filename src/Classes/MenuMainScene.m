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

#import "MenuMainScene.h"
#import "CreditsScene.h"
#import "ScoresScene.h"
#import "HowToPlayScene.h"
#import "OptionsScene.h"
#import "ContinueGameScene.h"
#import "SoundManager.h"
#import "LoadingGameScene.h"
#import "Constants.h"

@implementation MenuMainScene

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_blue_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
	
		// sun_lights texture used by 2 sprites
		m_sun_lights_texture=[[CCTextureCache sharedTextureCache] addImage:@"shared_sun_lights.png"];			

		// 2 sprites that use the same texture
		CCSprite* sun_light_clock_wise_sprite=[CCSprite spriteWithTexture:m_sun_lights_texture];
		sun_light_clock_wise_sprite.scale=2;
		sun_light_clock_wise_sprite.position=ccp(240, 0);
		[sun_light_clock_wise_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_MENU_ROTATION_TIME angle: 360]]];
		[self addChild: sun_light_clock_wise_sprite];
		
		// the other one
		CCSprite* sun_light_counter_clock_wise_sprite=[CCSprite spriteWithTexture:m_sun_lights_texture];
		sun_light_counter_clock_wise_sprite.scale=2;
		sun_light_counter_clock_wise_sprite.position=ccp(240, 0);
		[sun_light_counter_clock_wise_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_MENU_ROTATION_TIME angle: -360]]];
		[self addChild: sun_light_counter_clock_wise_sprite];
	
		// arc sprite
		CCSprite* arc=[CCSprite spriteWithFile:@"menu_main_light_arch.pvr"];
		arc.position=ccp(240,160);
		[self addChild: arc];
	
		// how to play button
        CCMenuItem* howToPlayItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_main_how_to_play_button_released.png" 
			selectedImage:@"menu_main_how_to_play_button_pressed.png" 
			target:self 
			selector:@selector(howToPlayButtonPressed:)
		];
        howToPlayItem.position = ccp(240, 72);
        CCMenu* howToPlayMenu = [CCMenu menuWithItems:howToPlayItem, nil];
        howToPlayMenu.position = CGPointZero;
        [self addChild:howToPlayMenu];
		
		// play button
        CCMenuItem* playItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_main_play_button_released.png" 
			selectedImage:@"menu_main_play_button_pressed.png" 
			target:self 
			selector:@selector(playButtonPressed:)
		];
        playItem.position = ccp(240, 110);
        CCMenu* playMenu = [CCMenu menuWithItems:playItem, nil];
        playMenu.position = CGPointZero;
        [self addChild:playMenu];
		
		// scores button
        CCMenuItem* scoresItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_main_scores_button_released.png" 
			selectedImage:@"menu_main_scores_button_pressed.png" 
			target:self 
			selector:@selector(scoresButtonPressed:)
		];
        scoresItem.position = ccp(240, 30);
        CCMenu* scoresMenu = [CCMenu menuWithItems:scoresItem, nil];
        scoresMenu.position = CGPointZero;
        [self addChild:scoresMenu];
		
		// options button
        CCMenuItem* optionsItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_main_options_button_released.png" 
			selectedImage:@"menu_main_options_button_pressed.png" 
			target:self 
			selector:@selector(optionsButtonPressed:)
		];
        optionsItem.position = ccp(142, 30);
        CCMenu* optionsMenu = [CCMenu menuWithItems:optionsItem, nil];
        optionsMenu.position = CGPointZero;
        [self addChild:optionsMenu];
		
		// credits button
        CCMenuItem* creditsItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_main_credits_button_released.png" 
			selectedImage:@"menu_main_credits_button_pressed.png" 
			target:self 
			selector:@selector(creditsButtonPressed:)
		];
        creditsItem.position = ccp(334, 30);
        CCMenu* creditsMenu = [CCMenu menuWithItems:creditsItem, nil];
        creditsMenu.position = CGPointZero;
        [self addChild:creditsMenu];
		
		// super fashion puzzle
#ifdef FREE_VERSION
		CCSprite* superFashionPuzzle=[CCSprite spriteWithFile:@"menu_main_super_fashion_puzzle_lite.png"];
		superFashionPuzzle.position=ccp(240,205);
#else
		CCSprite* superFashionPuzzle=[CCSprite spriteWithFile:@"menu_main_super_fashion_puzzle.png"];
		superFashionPuzzle.position=ccp(240,205);
#endif
		[self addChild: superFashionPuzzle];
		
		// buy full version button
#ifdef FREE_VERSION
		CCMenuItem* buyFullVersionItem = [CCMenuItemImage 
								   itemFromNormalImage:@"buy_full_version_label.png" 
								   selectedImage:@"buy_full_version_label.png" 
								   target:self 
								   selector:@selector(buyFullVersionButtonPressed:)
								   ];
        buyFullVersionItem.position = ccp(480-56.5, 320-56.5);
        CCMenu* buyFullVersionMenu = [CCMenu menuWithItems:buyFullVersionItem, nil];
        buyFullVersionMenu.position = CGPointZero;
        [self addChild:buyFullVersionMenu];
#endif

	}
	return self;
}

#ifdef FREE_VERSION
-(void) buyFullVersionButtonPressed:(id)sender {
	NSLog(@"buyFullVersion");
	NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=384946158&mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
#endif

-(void) howToPlayButtonPressed:(id)sender {
	NSLog(@"howToPlayButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	HowToPlayScene* howToPlayScene=[HowToPlayScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:howToPlayScene withColor:ccWHITE]];
}

-(void) playButtonPressed: (id)sender {
	NSLog(@"playButtonPressed");
	
	// increment number of played games
	NSInteger gameWasStarted=[[NSUserDefaults standardUserDefaults] integerForKey:@"gameWasStarted"];
	gameWasStarted++;
	[[NSUserDefaults standardUserDefaults] setInteger:gameWasStarted forKey:@"gameWasStarted"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[SoundManager sharedSoundManager] stopBackgroundMusic];
	
	LoadingGameScene* loadingGameScene=[LoadingGameScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:loadingGameScene withColor:ccWHITE]];
}

-(void) optionsButtonPressed: (id)sender {
	NSLog(@"optionsButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	OptionsScene* optionsScene=[OptionsScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:optionsScene withColor:ccWHITE]];
}

-(void) scoresButtonPressed: (id)sender {
	NSLog(@"scoresButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	ScoresScene* scoresScene=[ScoresScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:scoresScene withColor:ccWHITE]];
}

-(void) creditsButtonPressed: (id)sender {
	NSLog(@"creditsButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	CreditsScene* creditsScene=[CreditsScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:creditsScene withColor:ccWHITE]];
}

-(void) onEnter
{
	NSLog(@"MenuMainScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"MenuMainScene: transition did finish");
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{	
	NSLog(@"MenuMainScene onExit");
	[super onExit];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	NSLog(@"deallocating MenuMainScene.");
	[[CCTextureCache sharedTextureCache] removeTexture:m_sun_lights_texture];	
	[super dealloc];
}

@end
