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

@class Board;

typedef enum {
	EMPTY,
	UNSELECTED_PIECE,
	SELECTED_PIECE,
	STARTING_CORRECT_MATCHING,
	ENDING_CORRECT_MATCHING,
	INCORRECT_MATCHING
} BoardPiecePlaceState;

/*!
A node that represents a place where a piece can be used.
It may have up to 3 different sprites: Piece, Selection, Matching. All of tem use a tag value in Constants.h
*/
@interface BoardPiecePlace : CCNode <CCRGBAProtocol> {
	Piece* m_currentPiece;
	CGRect m_rect;
	Board* m_board;
	unsigned int m_column;
	unsigned int m_row;
	BoardPiecePlaceState m_state;
}

@property (nonatomic,readonly) Piece* m_currentPiece;

-(id) initWithBoard:(Board*)board Column:(unsigned int)column Row:(unsigned int)row PieceSize:(CGSize)size;
-(BOOL) containsTouchLocation:(UITouch *)touch;
-(BOOL) isPieceSelectable;
-(BOOL) processTouch:(UITouch *)touch;

// Used by Board to change object state.
-(void) setPiece:(Piece*)piece;
-(void) reset;
-(void) select;
-(void) unselect;
-(void) correctMatching;
-(void) incorrectMatching;

// Callbacks
-(void) correctMatchingWillBeDoneCallback:(id)sender;
-(void) correctMatchingWasDoneCallback:(id)sender;
-(void) incorrectMatchingWasDoneCallback:(id)sender;

// FSM managment
-(void) onEnterBoardPiecePlaceState:(BoardPiecePlaceState)state;
-(void) onExitBoardPiecePlaceState:(BoardPiecePlaceState)state;
-(void) changeBoardPiecePlaceState:(BoardPiecePlaceState)state;

-(void) dealloc;
@end
