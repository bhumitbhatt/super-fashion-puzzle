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

#import "SoundManager.h"
#import "SimpleAudioEngine.h"

@implementation SoundManager

// singleton stuff
static SoundManager* m_sharedSoundManager = nil;

+ (SoundManager*) sharedSoundManager
{
	if (m_sharedSoundManager==nil) 
		m_sharedSoundManager=[[SoundManager alloc] init];
	return m_sharedSoundManager;
}

+(id)alloc
{
	NSAssert(m_sharedSoundManager==nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

-(void) showVersion {
	NSLog(@"SoundManager. Calling this method to force effects preloading.");
}

-(id) init
{
	self=[super init];
	if(self!=nil) {
		// sound loading
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_chip_was_unselected.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_regeneration.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_selected_chip.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_tap.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_ready.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_new_girl.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_incorrect_matching.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_game_over.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_correct_matching_with_wildcard.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"sound_fx_correct_matching.mp3"];
		
		// music
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sound_music_game.mp3"];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sound_music_menu.mp3"];
	}
	return self;
}
	
-(void) playSoundFxCorrectMatching {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_correct_matching.mp3"];
}

-(void) playSoundFxCorrectMatchingWithWildcard {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_correct_matching_with_wildcard.mp3"];
}

-(void) playSoundFxGameOver {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_game_over.mp3"];
}

-(void) playSoundFxIncorrectMatching {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_incorrect_matching.mp3"];
}

-(void) playSoundFxNewGirl {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_new_girl.mp3"];
}

-(void) playSoundFxChipWasUnselected {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_chip_was_unselected.wav"];
}

-(void) playSoundFxRegeneration {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_regeneration.wav"];
}

-(void) playSoundFxSelectedChip {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_selected_chip.wav"];
}

-(void) playSoundFxTap {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_tap.wav"];
}

-(void) playSoundFxReady {
	[[SimpleAudioEngine sharedEngine] playEffect:@"sound_fx_ready.wav"];
}

-(void) playSoundMusicGame {
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"sound_music_game.mp3"];
}

-(void) playSoundMusicMenu {
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"sound_music_menu.mp3"];
}

-(void) stopBackgroundMusic {
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
