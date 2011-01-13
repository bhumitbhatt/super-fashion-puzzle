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

#import "HowToPlayScene.h"
#import "MenuMainScene.h"
#import "SoundManager.h"
#import "Constants.h"

@implementation HowToPlayScene

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
		
		// load 4 pages, CCSprites, foreground
		m_pages=[[NSMutableArray alloc] init];
		for (int i=0; i<4; i++) {
			NSString* filename=[NSString stringWithFormat:@"menu_how_to_play_page_%d.png", i];
			CCSprite* pageSprite=[CCSprite spriteWithFile:filename];
			pageSprite.position=ccp(240,160);
			pageSprite.visible=(i==0);
			[self addChild:pageSprite];
			[m_pages addObject:pageSprite];
		}
		
		// ok button
        CCMenuItem* okItem = [CCMenuItemImage 
			itemFromNormalImage:@"shared_ok_pink_released.png"
			selectedImage:@"shared_ok_pink_pressed.png" 
			target:self 
			selector:@selector(okButtonPressed:)
		];
        okItem.position = ccp(240, 43);
        CCMenu* okMenu = [CCMenu menuWithItems:okItem, nil];
        okMenu.position = CGPointZero;
        [self addChild:okMenu];
		
		// left arrow button
        CCMenuItem* leftArrowItem = [CCMenuItemImage 
							  itemFromNormalImage:@"menu_how_to_play_left_arrow_released.png"
							  selectedImage:@"menu_how_to_play_left_arrow_pressed.png" 
							  target:self 
							  selector:@selector(leftArrowButtonPressed:)
							  ];
        leftArrowItem.position = ccp(150, 43);
        CCMenu* leftArrowMenu = [CCMenu menuWithItems:leftArrowItem, nil];
		leftArrowMenu.position = CGPointZero;
        [self addChild:leftArrowMenu];
		
		// right arrow button
		CCMenuItem* rightArrowItem = [CCMenuItemImage 
							  itemFromNormalImage:@"menu_how_to_play_right_arrow_released.png"
							  selectedImage:@"menu_how_to_play_right_arrow_pressed.png" 
							  target:self 
							  selector:@selector(rightArrowButtonPressed:)
							  ];
        rightArrowItem.position = ccp(480-150, 43);
        CCMenu* rightArrowMenu = [CCMenu menuWithItems:rightArrowItem, nil];
        rightArrowMenu.position = CGPointZero;
        [self addChild:rightArrowMenu];
		
		m_pop_at_exit=false;
		m_index=0;
	}
	return self;
}

-(void) setPopAtExit {
	m_pop_at_exit=true;
}

-(void) onEnter
{
	NSLog(@"HowToPlayScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"HowToPlayScene: transition did finish");
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"HowToPlayScene onExit");
	[super onExit];
}

-(void) okButtonPressed: (id)sender {
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

-(void) leftArrowButtonPressed: (id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	m_index=(m_index-1) % m_pages.count;
	for (int i=0; i<m_pages.count; i++) {
		CCSprite* sprite=[m_pages objectAtIndex:i];
		sprite.visible=(i==m_index);
	}
	//NSLog(@"index=%d", m_index);
}

-(void) rightArrowButtonPressed: (id)sender {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	m_index=(m_index+1)% m_pages.count;
	for (int i=0; i<m_pages.count; i++) {
		CCSprite* sprite=[m_pages objectAtIndex:i];
		sprite.visible=(i==m_index);
	}
	//NSLog(@"index=%d", m_index);
}

- (void) dealloc
{
	NSLog(@"deallocating HowToPlayScene.");
	[m_pages release];
	[super dealloc];
}

@end
