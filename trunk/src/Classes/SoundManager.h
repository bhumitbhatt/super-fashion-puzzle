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

#import <Foundation/Foundation.h>

/*
Singleton to load and play effects and music. 
*/
@interface SoundManager : NSObject {

}

+(id)alloc;
+(SoundManager*) sharedSoundManager;
-(void) showVersion;

// effects
-(void) playSoundFxCorrectMatching;
-(void) playSoundFxCorrectMatchingWithWildcard;
-(void) playSoundFxChipWasUnselected;
-(void) playSoundFxGameOver;
-(void) playSoundFxIncorrectMatching;
-(void) playSoundFxNewGirl;
-(void) playSoundFxRegeneration;
-(void) playSoundFxSelectedChip;
-(void) playSoundFxTap;
-(void) playSoundFxReady;

// music
-(void) playSoundMusicGame;
-(void) playSoundMusicMenu;
-(void) stopBackgroundMusic;

@end