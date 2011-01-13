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

#import "cocos2d.h"
#import "PlayingScene.h"

@interface PauseScene : CCScene {
	PlayingScene* m_playingScene; // used to inform it that pause is going to be resumed just before finishing this object
}
@property(nonatomic,assign) PlayingScene* m_playingScene;
-(void) resumeButtonPressed:(id)sender;
-(void) optionsButtonPressed:(id)sender;
-(void) menuButtonPressed:(id)sender;
-(void) howToPlayButtonPressed:(id)sender;
@end
