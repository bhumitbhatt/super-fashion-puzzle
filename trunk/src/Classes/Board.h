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
#import "cocos2d.h"
#import "Piece.h"
#import "BoardPiecePlace.h"
#import "BoardPiecePlacesPivotNode.h"
#import "Constants.h"

@class PlayingScene;

typedef enum {
	REGENERATING_BOARD,
	CHANGING_GIRL,
	WAITING_USER_INPUT_WO_CHIP_SELECTED,
	WAITING_USER_INPUT_WITH_CHIP_SELECTED,
} BoardState;

@interface Board : CCNode <CCTargetedTouchDelegate> {

	PlayingScene* m_playingScene;
	NSMutableArray* m_boardPiecePlaces;
	NSMutableArray* m_piecesDataBase;
	CCTexture2D* m_piecesSpriteSheetTexture;
	Piece* m_wildcardPiece;
	BoardPiecePlacesPivotNode* m_boardPiecePlacesPivotNode;
	CGRect m_boardRect;
	
	// Used by BoardPiecePlace to create selection and matching animations
	CCTexture2D* m_selectedTexture;
	CCRepeatForever* m_selectedAction;
	CCTexture2D* m_startingMatchingTexture;
	CCAnimate* m_startingMatchingAction;
	CCAnimate* m_correctMatchingEndingAction;
	CCAnimate* m_incorrectMatchingEndingAction;
	
	// FSM
	BoardPiecePlace* m_selectedBoardPiecePlace;
	unsigned int m_numberOfRegenerations;
	unsigned int m_numberOfMatches;
	BoardState m_state;
}

@property (nonatomic,readonly) CCRepeatForever* m_selectedAction;
@property (nonatomic,readonly) CCTexture2D* m_selectedTexture;
@property (nonatomic,readonly) CCAnimate* m_startingMatchingAction;
@property (nonatomic,readonly) CCAnimate* m_correctMatchingEndingAction;
@property (nonatomic,readonly) CCAnimate* m_incorrectMatchingEndingAction;
@property (nonatomic,readonly) CCTexture2D* m_startingMatchingTexture;
@property (nonatomic,readonly) PlayingScene* m_playingScene;

-(id) initWithPlayingScene:(PlayingScene*)playingScene;
-(BoardPiecePlace*) getBoardPiecePlaceAtColumn:(unsigned int)column Row:(unsigned int)row;
-(Piece*) getPiece:(unsigned int)piece FromGirl:(unsigned int)girl;
-(void) reset;
-(void) regenerate:(unsigned int)level;
-(void) inTheMiddleOfRegenerationSequenceCallback:(id)sender;
-(void) regenerationSquenceWasDone:(id)sender;
-(void) inTheMiddleOfChangeGirlSequenceCallback:(id)sender;
-(void) changeGirlSequenceWasDoneCallback:(id)sender;
-(void) correctMatchWasDone:(bool)withWildcard BoardPiecePlace:(BoardPiecePlace*)boardPiecePlace;
-(void) incorrectMatchWasDone:(BoardPiecePlace*)boardPiecePlace;
-(NSUInteger) getNumberOfWildcardsForLevel:(NSUInteger)level;

// Used by BoardPiecePlace
-(BOOL) canBoardPiecePlaceBeSelected;
-(void) boardPiecePlaceWasSelected:(BoardPiecePlace*)boardPiecePlace;

// FSM managment
-(void) changeBoardState:(BoardState)state;
-(void) onEnterBoardState:(BoardState)state;
-(void) onExitBoardState:(BoardState)state;

@end

