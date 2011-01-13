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
#import "UIntegerLabel.h"
#import "StringLabel.h"
#import "WaitView.h"
#import "FacebookStatusDelegate.h"
#import "FacebookSessionDelegate.h"
#import "RenameViewController.h"
@class PlayingScene;

@interface GameOverScene : CCScene <UIAlertViewDelegate, FacebookStatusDelegate, FacebookSessionDelegate, RenameViewControllerDelegate> {
	UIntegerLabel* m_current_score_label;
	UIntegerLabel* m_high_score_label;
	StringLabel* m_name_label;
	unsigned int m_level;
	PlayingScene* m_playingScene;
	BOOL m_scoreWasSentProperly;
	BOOL m_facebookWallWasWrittenProperly;
	WaitView* m_waitView;
	BOOL m_playedTooMuch;
	RenameViewController* m_renameViewController;
	CCMenu* m_loginMenu;
	CCMenu* m_logoutMenu;
}
@property(nonatomic,assign) PlayingScene* m_playingScene;
@property(nonatomic,assign) unsigned int m_level;
@property(nonatomic,assign) BOOL m_playedTooMuch;

-(id) init;
//-(void) alertView:(AlertPrompt*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void) tryToUploadScore;
-(void) goToMainMenu;
-(void) goToPlayAgain;
-(NSString*) buildFacebookMessageWithPoints:(NSUInteger)points AndLevel:(NSUInteger)level;

// buttons handlers
-(void) submitButtonPressed:(id)sender;
-(void) renameButtonPressed:(id)sender;
-(void) playAgainButtonPressed:(id)sender;
-(void) menuButtonPressed:(id)sender;
#ifdef FREE_VERSION
-(void) buyFullVersionButtonPressed:(id)sender;
#endif
-(void) loginButtonPressed:(id)sender;
-(void) logoutButtonPressed:(id)sender;

// modify labels information
-(void) setHighScore:(unsigned int)highScore;
-(void) setCurrentScore:(unsigned int)currentScore;

@end
