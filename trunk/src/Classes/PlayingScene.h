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
#import "BackgroundGirls.h"
#import "Board.h"
#import "TimeBar.h"

typedef enum {
	STARTING_STATE_GS,
	READY,
	PLAYING, // uses a nested state chart
	PAUSED,
	PAUSE_BY_LOCK,
	GAME_OVER,
	ENDING_STATE_GS
} GameState;

/*!
This class implements a FSM (gaming, paused, game_over states).
*/
@interface PlayingScene : CCScene {
	Board* m_board;
	CCSprite* m_readySprite;
	CCSprite* m_gameOverSprite;
	CCSprite* m_girlTransition; // used when current girl have to be changed
	
	CCSprite* m_score_and_level_sprite;
	UIntegerLabel* m_scoreLabel;
	UIntegerLabel* m_levelLabel;
	TimeBar* m_timeBar;
	BackgroundGirls* m_backgroundGirls;
	CCMenu* m_pauseMenu;
	BOOL m_playedTooMuch;
	
	// vars for "game" FSM
	GameState m_state;
}

@property (nonatomic,readonly) BackgroundGirls* m_backgroundGirls;
@property (nonatomic,readonly) TimeBar* m_timeBar;
@property (nonatomic,readonly) UIntegerLabel* m_levelLabel;
@property (nonatomic,readonly) UIntegerLabel* m_scoreLabel;
@property (nonatomic,readonly) CCSprite* m_girlTransition;

-(void) pauseButtonPressed:(id)sender;
-(void) readySequenceFinished:(id)sender;
-(void) playReadySoundFX:(id)sender;
-(void) timeUp;
-(void) gameOverAnmationFinished:(id)sender;
-(void) reset;
-(void) onResume;
-(bool) isPlaying;
-(unsigned int) getLevel;
-(void) checkGameLayout;
-(void) applicationWillResginActive;
-(void) playedTooMuch;

// Game FSM managment
-(void) changeGameState:(GameState)state;
-(void) onEnterGameState:(GameState)state;
-(void) onExitGameState:(GameState)state;

@end
