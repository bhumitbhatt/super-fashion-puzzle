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

#import "PauseScene.h"
#import "SoundManager.h"
#import "HowToPlayScene.h"
#import "OptionsScene.h"
#import "MenuMainScene.h"
#import "Constants.h"

@implementation PauseScene

@synthesize m_playingScene;

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_pink_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
		
		// spot_lights sprite
		CCSprite* spot_lights_sprite=[CCSprite spriteWithFile:@"shared_spot_lights.png"];
		spot_lights_sprite.scale=2;
		spot_lights_sprite.position=ccp(400, 360);
		[spot_lights_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: spot_lights_sprite];	
		
		// foreground
		CCSprite* foreground=[CCSprite spriteWithFile:@"menu_pause_foreground.png"];
		foreground.position=ccp(240,160);
		[self addChild: foreground];

		// resume button
		CCMenuItem *resumeItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_pause_resume_button_released.png" 
			selectedImage:@"menu_pause_resume_button_pressed.png" 
			target:self 
			selector:@selector(resumeButtonPressed:)
		];
        resumeItem.position = ccp(240, 211);
        CCMenu *resumeMenu = [CCMenu menuWithItems:resumeItem, nil];
        resumeMenu.position = CGPointZero;
        [self addChild:resumeMenu];
		
		// how to play button
		CCMenuItem *howToPlayItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_pause_how_to_play_button_released.png" 
			selectedImage:@"menu_pause_button_how_to_play_pressed.png" 
			target:self 
			selector:@selector(howToPlayButtonPressed:)
		];
        howToPlayItem.position = ccp(240, 156);
        CCMenu *howToPlayMenu = [CCMenu menuWithItems:howToPlayItem, nil];
        howToPlayMenu.position = CGPointZero;
        [self addChild:howToPlayMenu];
		
		// options button
		CCMenuItem *optionsItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_pause_options_button_released.png" 
			selectedImage:@"menu_pause_options_button_pressed.png" 
			target:self 
			selector:@selector(optionsButtonPressed:)
		];
		optionsItem.position = ccp(240, 101);
        CCMenu *optionsMenu = [CCMenu menuWithItems:optionsItem, nil];
        optionsMenu.position = CGPointZero;
        [self addChild:optionsMenu];
		
		// menu button
		CCMenuItem *menuItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_pause_menu_button_released.png" 
			selectedImage:@"menu_pause_menu_button_pressed.png" 
			target:self 
			selector:@selector(menuButtonPressed:)
		];
		menuItem.position = ccp(240, 43);
        CCMenu *menuMenu = [CCMenu menuWithItems:menuItem, nil];
        menuMenu.position = CGPointZero;
        [self addChild:menuMenu];
		
		m_playingScene=nil;
	}
	return self;
}

-(void) onEnter
{
	NSLog(@"PauseScene onEnter");
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	//if ([[UIApplication sharedApplication] respondsToSelector: @selector(setStatusBarHidden: withAnimation:)])
	//	[[UIApplication sharedApplication] setStatusBarHidden: NO withAnimation: UIStatusBarAnimationFade];
    //else
	//	[[UIApplication sharedApplication] setStatusBarHidden: NO animated: YES]; 
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"PauseScene: transition did finish");
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"PauseScene onExit");
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	//if ([[UIApplication sharedApplication] respondsToSelector: @selector(setStatusBarHidden: withAnimation:)])
	//	[[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade];
    //else
	//	[[UIApplication sharedApplication] setStatusBarHidden: YES animated: YES]; 
	[super onExit];
}

-(void) resumeButtonPressed:(id)sender {
	
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[CCDirector sharedDirector] popScene];
	[m_playingScene onResume];
}

-(void) optionsButtonPressed:(id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	OptionsScene* optionsScene=[OptionsScene node];
	[optionsScene setPopAtExit];
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:optionsScene withColor:ccWHITE]];
}

-(void) menuButtonPressed:(id)sender {
	
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[CCDirector sharedDirector] popScene];  // remove pause scene and replace playing scene
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[SoundManager sharedSoundManager] playSoundMusicMenu];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
}

-(void) howToPlayButtonPressed:(id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	HowToPlayScene* howToPlayScene=[HowToPlayScene node];
	[howToPlayScene setPopAtExit];
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:howToPlayScene withColor:ccWHITE]];	
}

- (void) dealloc
{	
	NSLog(@"deallocating PauseScene");
	[super dealloc];
}

@end
