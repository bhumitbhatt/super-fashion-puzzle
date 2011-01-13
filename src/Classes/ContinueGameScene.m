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

// WARNING: NOT USED IN RELEASE VERSION
// There is not "save game" feature in release version and 
// any screen to load it.

/*
#import "ContinueGameScene.h"
#import "MenuMainScene.h"
#import "SoundManager.h"
#import "LoadingGameScene.h"
#import "Constants.h"

@implementation ContinueGameScene

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_blue_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
		
		// sun_lights texture
		m_rectangle_lights_texture=[[CCTextureCache sharedTextureCache] addImage:@"shared_rectangle_lights.png"];			
		
		// 3 background sprites with the same texture
		CCSprite* rectangle_light_1_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_light_1_sprite.scale=0.8;
		rectangle_light_1_sprite.position=ccp(480, 320);
		[rectangle_light_1_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: rectangle_light_1_sprite];
		
		CCSprite* rectangle_light_2_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_light_2_sprite.scale=1.6;
		rectangle_light_2_sprite.position=ccp(480, 320);
		[rectangle_light_2_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: rectangle_light_2_sprite];
		
		CCSprite* rectangle_light_3_sprite=[CCSprite spriteWithTexture:m_rectangle_lights_texture];
		rectangle_light_3_sprite.scale=2.6;
		rectangle_light_3_sprite.position=ccp(480, 320);
		[rectangle_light_3_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: rectangle_light_3_sprite];
		
		// foreground
		CCSprite *foreground=[CCSprite spriteWithFile:@"menu_continue_game_foreground.png"];
		foreground.position=ccp(240,160);
		[self addChild: foreground];
		
		// yes button
        CCMenuItem *yesItem = [CCMenuItemImage 
							  itemFromNormalImage:@"menu_continue_game_yes_blue_button_released.png" 
							  selectedImage:@"menu_continue_game_yes_blue_button_pressed.png" 
							  target:self 
							  selector:@selector(yesButtonPressed:)
							  ];
        yesItem.position = ccp(186, 154);
        CCMenu *yesMenu = [CCMenu menuWithItems:yesItem, nil];
        yesMenu.position = CGPointZero;
        [self addChild:yesMenu];
		
		// no button
        CCMenuItem *noItem = [CCMenuItemImage 
										itemFromNormalImage:@"menu_continue_game_no_blue_button_released.png" 
										selectedImage:@"menu_continue_game_no_blue_button_pressed.png" 
										target:self 
										selector:@selector(noButtonPressed:)
										];
        noItem.position = ccp(296, 154);
        CCMenu *noMenu = [CCMenu menuWithItems:noItem, nil];
        noMenu.position = CGPointZero;
        [self addChild:noMenu];
		
		// cancel button
		CCMenuItem *cancelItem = [CCMenuItemImage 
							  itemFromNormalImage:@"menu_continue_game_blue_cancel_button_released.png" 
							  selectedImage:@"menu_continue_game_blue_cancel_button_pressed.png" 
							  target:self 
							  selector:@selector(cancelButtonPressed:)
							  ];
        cancelItem.position = ccp(240, 90);
        CCMenu *cancelMenu = [CCMenu menuWithItems:cancelItem, nil];
        cancelMenu.position = CGPointZero;
        [self addChild:cancelMenu];
	}
	return self;
}

-(void) cancelButtonPressed: (id)sender {
	NSLog(@"cancelButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
}

-(void) yesButtonPressed: (id)sender {
	//NSLog(@"yesButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	// TODO decir de alguna manera que debemos cargar la partida, por ejemplo si existe el fichero por defecto la carga
	LoadingGameScene* loadingGameScene=[LoadingGameScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:loadingGameScene withColor:ccWHITE]];
	// borrar el import de PlayingScene
	//PlayingScene* playingScene=[PlayingScene node];
	//[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:TRANSITION_DURATION scene:playingScene withColor:ccWHITE]];
}

-(void) noButtonPressed: (id)sender {
	//NSLog(@"noButtonPressed");
	[[SoundManager sharedSoundManager] playSoundFxTap];
	// TODO decir de alguna manera que hemos elegido que no, o simplemente borrar la partida guardad
	LoadingGameScene* loadingGameScene=[LoadingGameScene node];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:loadingGameScene withColor:ccWHITE]];
	//PlayingScene* playingScene=[PlayingScene node];
	//[[CCDirector sharedDirector] replaceScene: [CCFadeTransition transitionWithDuration:TRANSITION_DURATION scene:playingScene withColor:ccWHITE]];
}

-(void) onEnter
{	
	NSLog(@"ContinueGameScene onEnter");
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{	
	NSLog(@"ContinueGameScene: transition did finish");
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"ContinueGameScene onExit");
	[super onExit];
}

- (void) dealloc
{
	NSLog(@"deallocating ContinueGameScene.");	
	[[CCTextureCache sharedTextureCache] removeTexture:m_rectangle_lights_texture];	
	[super dealloc];
}

@end
*/
