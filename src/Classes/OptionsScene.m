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

#import "OptionsScene.h"
#import "MenuMainScene.h"
#import "CCRadioMenu.h"
#import "SoundManager.h"
#import "Constants.h"
#import "FacebookManager.h"

@implementation OptionsScene

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite* background=[CCSprite spriteWithFile:@"shared_pink_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
		
		// spot_lights sprite
		CCSprite* spot_lights_sprite=[CCSprite spriteWithFile:@"shared_spot_lights.png"];
		spot_lights_sprite.scale=2;
		spot_lights_sprite.position=ccp(400, 360);
		[spot_lights_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: spot_lights_sprite];
		
		// foreground
		CCSprite* foreground=[CCSprite spriteWithFile:@"menu_options_foreground.png"];
		foreground.position=ccp(240,160);
		[self addChild: foreground];
		
		// ok button
        CCMenuItem *okItem = [CCMenuItemImage 
							  itemFromNormalImage:@"shared_ok_pink_released.png"
							  selectedImage:@"shared_ok_pink_pressed.png" 
							  target:self 
							  selector:@selector(okButtonPressed:)
							  ];
        okItem.position = ccp(240, 43);
        CCMenu* okMenu = [CCMenu menuWithItems:okItem, nil];
        okMenu.position = CGPointZero;
        [self addChild:okMenu];
		
		// Radio buttons
        CCMenuItem* menuItem1 = [CCMenuItemImage itemFromNormalImage:@"menu_options_layout_right_off.png" selectedImage:@"menu_options_layout_right_on.png" target:self selector:@selector(rightBoardRadioButtonSelected:)];
        CCMenuItem* menuItem2 = [CCMenuItemImage itemFromNormalImage:@"menu_options_layout_left_off.png" selectedImage:@"menu_options_layout_left_on.png" target:self selector:@selector(leftBoardRadioButtonSelected:)];
        CCRadioMenu* radioMenu = [CCRadioMenu menuWithItems:menuItem1, menuItem2, nil];
        radioMenu.position = ccp(240, 146);
        [radioMenu alignItemsHorizontally];
		
		// where is board, right or left?
		BOOL boardAtTheLeft=[[NSUserDefaults standardUserDefaults] boolForKey:@"boardAtTheLeft"];
		if (boardAtTheLeft) {
			//radioMenu.selectedItem = menuItem2;
			[radioMenu setSelectedItem:menuItem2];
			[menuItem2 selected];
		} else {
			//radioMenu.selectedItem = menuItem1;
			[radioMenu setSelectedItem:menuItem1];
			[menuItem1 selected];	
		}
		[self addChild:radioMenu];
		
		// set facebookmanager delegate
		[[FacebookManager sharedFacebookManager] setSessionDelegate:self];
		
		// login/logut butttons
		BOOL isConnected=[[FacebookManager sharedFacebookManager] isConnected];
		const int loginX=370, loginY=45;
		
		// login button
		CCMenuItem* loginItem = [CCMenuItemImage 
								 itemFromNormalImage:@"facebook_login_released.png"
								 selectedImage:@"facebook_login_pressed.png" 
								 target:self 
								 selector:@selector(loginButtonPressed:)
								 ];
		loginItem.position = ccp(loginX, loginY);
		m_loginMenu = [CCMenu menuWithItems:loginItem, nil];
		[m_loginMenu retain];
		m_loginMenu.position = CGPointZero;
		m_loginMenu.visible=!isConnected;
		[self addChild:m_loginMenu];
		
		// logout button
		CCMenuItem* logoutItem = [CCMenuItemImage 
								  itemFromNormalImage:@"facebook_logout_released.png"
								  selectedImage:@"facebook_logout_pressed.png" 
								  target:self 
								  selector:@selector(logoutButtonPressed:)
								  ];
		logoutItem.position = ccp(loginX, loginY);
		m_logoutMenu = [CCMenu menuWithItems:logoutItem, nil];
		[m_logoutMenu retain];
		m_logoutMenu.position = CGPointZero;
		m_logoutMenu.visible=isConnected;
		[self addChild:m_logoutMenu];
	
		// wait view
		CGRect rect=CGRectMake(0, 0, 480, 320);
		m_waitView=[[WaitView alloc] initWithFrame:rect];
		
		// init vars
		m_pop_at_exit=false;
	}
	return self;
}

-(void) setPopAtExit {
	m_pop_at_exit=true;
}

-(void) onEnter
{
	NSLog(@"OptionsScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"OptionsScene: transition did finish");	
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"OptionsScene onExit");
	[super onExit];
}

-(void) okButtonPressed:(id)sender {
	NSLog(@"okButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	
	// called from pause menu
	if (m_pop_at_exit) {
		[[CCDirector sharedDirector] popScene];
		
	// called from main main menu
	} else {
		MenuMainScene* menuMainScene=[MenuMainScene node];
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
	}
}

-(void) rightBoardRadioButtonSelected: (id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"boardAtTheLeft"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) leftBoardRadioButtonSelected: (id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"boardAtTheLeft"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) sessionDidLogin {
	NSLog(@"sessionDidLogin");
	m_loginMenu.visible=NO;
	m_logoutMenu.visible=YES;
	[m_waitView removeFromSuperview];
}

-(void) sessionDidNotLogin:(NSString*)errorMessage {
	NSLog(@"sessionDidNotLogin");
	NSString* message=[NSString stringWithFormat:@"Error starting session. %@", errorMessage];
	UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[msg show];
	[msg release];
	[m_waitView removeFromSuperview];
}

-(void) sessionDidLogout {
	NSLog(@"sessionDidLogout");
	m_loginMenu.visible=YES;
	m_logoutMenu.visible=NO;
	[m_waitView removeFromSuperview];
}

-(void) loginButtonPressed:(id)sender {
	[[[CCDirector sharedDirector] openGLView] addSubview:m_waitView];
	[[FacebookManager sharedFacebookManager] login];
}

-(void) logoutButtonPressed:(id)sender {
	[[[CCDirector sharedDirector] openGLView] addSubview:m_waitView];
	[[FacebookManager sharedFacebookManager] logout];	
}

- (void) dealloc
{	
	NSLog(@"deallocating OptionsScene.");
	[[FacebookManager sharedFacebookManager] setSessionDelegate:nil];
	[m_loginMenu release];
	[m_logoutMenu release];
	[m_waitView release];
	[super dealloc];
}

@end
