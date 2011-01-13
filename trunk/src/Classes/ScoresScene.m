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

#import "ScoresScene.h"
#import "MenuMainScene.h"
#import "SoundManager.h"
#import "CCRadioMenu.h"
#import "Constants.h"

@implementation ScoresScene

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_pink_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
				
		// foreground
		CCSprite *foreground=[CCSprite spriteWithFile:@"menu_scores_foreground.png"];
		foreground.position=ccp(240,160);
		[self addChild: foreground];
				
		// ok button
        CCMenuItem *okItem = [CCMenuItemImage 
								itemFromNormalImage:@"menu_scores_ok_pink_wide_button_released.png" 
								selectedImage:@"menu_scores_ok_pink_wide_button_pressed.png" 
								target:self 
								selector:@selector(okButtonPressed:)
								];
        okItem.position = ccp(337, 33);
        CCMenu *okMenu = [CCMenu menuWithItems:okItem, nil];
        okMenu.position = CGPointZero;
        [self addChild:okMenu];
		
		// reset local scores button
        CCMenuItem *resetLocalItem = [CCMenuItemImage 
								  itemFromNormalImage:@"menu_scores_reset_local_button_released.png" 
								  selectedImage:@"menu_scores_reset_local_button_pressed.png" 
								  target:self 
								  selector:@selector(resetLocalButtonPressed:)
								  ];
        resetLocalItem.position = ccp(147, 33);
        CCMenu *resetLocalMenu = [CCMenu menuWithItems:resetLocalItem, nil];
        resetLocalMenu.position = CGPointZero;
        [self addChild:resetLocalMenu];
		
		// radio buttons
        CCMenuItem* menuItem1 = [CCMenuItemImage itemFromNormalImage:@"menu_scores_local_button_released.png" selectedImage:@"menu_scores_local_button_pressed.png" target:self selector:@selector(localButtonPressed:)];
        CCMenuItem* menuItem2 = [CCMenuItemImage itemFromNormalImage:@"menu_scores_global_button_released.png" selectedImage:@"menu_scores_global_button_pressed.png" target:self selector:@selector(globalButtonPressed:)];
        CCRadioMenu* radioMenu = [CCRadioMenu menuWithItems:menuItem1, menuItem2, nil];
        radioMenu.position = ccp(240, 230);
        [radioMenu alignItemsHorizontally];
		//radioMenu.selectedItem = menuItem1;
		[radioMenu setSelectedItem:menuItem1];
		[menuItem1 selected];	
		[self addChild:radioMenu];
		
		// init scores controllers
		m_localHighscoresViewController=[[LocalHighscoresViewController alloc] init];
		m_globalHighscoresViewController=[[GlobalHighscoresViewController alloc] init];
		m_state=LOCAL;
	}
	return self;
}

-(void) changeScoresState:(ScoresState)state {
	if (m_state==LOCAL && state==GLOBAL) {
		[m_localHighscoresViewController.view removeFromSuperview];
		[[[CCDirector sharedDirector] openGLView] addSubview:m_globalHighscoresViewController.view];
		
	} else if (m_state==GLOBAL && state==LOCAL) {
		[m_globalHighscoresViewController.view removeFromSuperview];
		[[[CCDirector sharedDirector] openGLView] addSubview:m_localHighscoresViewController.view];

	} else {
		NSLog(@"Unknown transition in ScoresScene object.");
		return; // ignore it, maybe local button was pressed when local state is activated
	}
	m_state=state;
}

-(void) onEnter
{
	NSLog(@"ScoresScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"ScoresScene: transition did finish");
	[[[CCDirector sharedDirector] openGLView] addSubview:m_localHighscoresViewController.view];
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"ScoresScene onExit");
	[super onExit];
}

/*!
Also removes scores view. 
*/
-(void) okButtonPressed: (id)sender {
	NSLog(@"okButtonPressed");
	if (m_state==LOCAL) {
		[m_localHighscoresViewController.view removeFromSuperview];
	} else if (m_state==GLOBAL) {
		[m_globalHighscoresViewController.view removeFromSuperview];
	} else {
		NSLog(@"Unknow scores state.");
		exit(1);
	}
	[[SoundManager sharedSoundManager] playSoundFxTap];
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
}

-(void) resetLocalButtonPressed: (id)sender {
	NSLog(@"resetLocalButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	
	// confirmation dialog, reply in alertView
	UIAlertView* dialog=[[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Warning"];
	[dialog setMessage:@"Would you like to delete all local high scores?"];
	[dialog addButtonWithTitle:@"Cancel"];
	[dialog addButtonWithTitle:@"OK"];
	[dialog show];
	[dialog release];
}

-(void) localButtonPressed: (id)sender {
	NSLog(@"localButtonPressed");
	[self changeScoresState:LOCAL];
	[[SoundManager sharedSoundManager] playSoundFxTap];
}

// reset local scores dialog handler. Called by resetLocalButtonPressed dialog.
-(void) alertView:(UIAlertView*)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==1) {
		[m_localHighscoresViewController reset];
	}
}

-(void) globalButtonPressed: (id)sender {
	NSLog(@"globalkButtonPressed");
	[self changeScoresState:GLOBAL];
	[[SoundManager sharedSoundManager] playSoundFxTap];
}

- (void) dealloc
{	
	NSLog(@"deallocating ScoresScene.");
	[m_localHighscoresViewController release];
	[m_globalHighscoresViewController release];
	[super dealloc];
}

@end
