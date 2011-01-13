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

#import "CreditsScene.h"
#import "MenuMainScene.h"
#import "SoundManager.h"
#import "Constants.h"

@implementation CreditsScene

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_blue_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
		
		// sun_lights texture
		m_rectangle_lights_texture=[[CCTextureCache sharedTextureCache] addImage:@"shared_rectangle_lights.png"];			
		
		// 3 sprites with the same texture
		CCSprite* rectangle_1_light_clock_wise_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_1_light_clock_wise_sprite.scale=1;
		rectangle_1_light_clock_wise_sprite.position=ccp(0, 100);
		[rectangle_1_light_clock_wise_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: 360]]];
		[self addChild: rectangle_1_light_clock_wise_sprite];
		
		CCSprite* rectangle_2_light_clock_wise_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_2_light_clock_wise_sprite.scale=1;
		rectangle_2_light_clock_wise_sprite.position=ccp(350, -70);
		[rectangle_2_light_clock_wise_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: 360]]];
		[self addChild: rectangle_2_light_clock_wise_sprite];
		
		CCSprite* rectangle_light_counter_clock_wise_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_light_counter_clock_wise_sprite.scale=1.5;
		rectangle_light_counter_clock_wise_sprite.position=ccp(480, 360);
		[rectangle_light_counter_clock_wise_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: rectangle_light_counter_clock_wise_sprite];
		
		// foreground
		CCSprite *foreground=[CCSprite spriteWithFile:@"menu_credits_foreground.png"];
		foreground.position=ccp(240,160);
		[self addChild: foreground];
	
		// ok button
        CCMenuItem *okItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_credits_ok_blue_button_released.png" 
			selectedImage:@"menu_credits_ok_blue_button_pressed.png" 
			target:self 
			selector:@selector(okButtonPressed:)
		];
        okItem.position = ccp(360, 42);
        CCMenu *okMenu = [CCMenu menuWithItems:okItem, nil];
        okMenu.position = CGPointZero;
        [self addChild:okMenu];
	
		// send feedback button
        CCMenuItem *sendFeedbackItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_credits_send_feedback_button_released.png" 
			selectedImage:@"menu_credits_send_feedback_button_pressed.png" 
			target:self 
			selector:@selector(sendFeedbackButtonPressed:)
		];
        sendFeedbackItem.position = ccp(160, 42);
        CCMenu *sendFeedbackMenu = [CCMenu menuWithItems:sendFeedbackItem, nil];
        sendFeedbackMenu.position = CGPointZero;
        [self addChild:sendFeedbackMenu];
	}
	return self;
}

-(void) sendFeedbackButtonPressed:(id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	NSLog(@"Asking for feedback.");
#ifdef FREE_VERSION
	NSString* sstring = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",@"384955775"];
#else
	NSString* sstring = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",@"384946158"];
#endif
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:sstring]];
}

-(void) okButtonPressed: (id)sender {
	NSLog(@"okButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
}

-(void) onEnter
{
	NSLog(@"CreditsScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"CreditsScene: transition did finish");
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"CreditsScene onExit");
	[super onExit];
}

- (void) dealloc
{
	NSLog(@"deallocating CreditsScene.");
	[[CCTextureCache sharedTextureCache] removeTexture:m_rectangle_lights_texture];	
	[super dealloc];
}

@end

