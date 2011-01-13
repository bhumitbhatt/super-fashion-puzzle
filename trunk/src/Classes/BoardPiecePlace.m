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

#import "BoardPiecePlace.h"
#import "Board.h"
#import "Constants.h"

@implementation BoardPiecePlace

@synthesize m_currentPiece;

-(id) initWithBoard:(Board*)board Column:(unsigned int)column Row:(unsigned int)row PieceSize:(CGSize)size {
	if((self=[super init])) {
		m_column=column;
		m_row=row;
		m_board=board;
		m_currentPiece=nil;
		m_state=EMPTY;
		m_rect=CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

/*!
A BoardPiecePlace may have or may not have a Piece. This Piece maybe is being killed, in this case is not selectable.
Also, if there is no Piece, obviously is not selectable.
*/
-(BOOL) isPieceSelectable {
	return m_state==UNSELECTED_PIECE;
}

//- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
- (BOOL) processTouch:(UITouch *)touch {	
	// is game state in playing mode and board state in waiting for input state?
	if ([self containsTouchLocation:touch] && 
		[m_board canBoardPiecePlaceBeSelected] && 
		(m_state==UNSELECTED_PIECE || m_state==SELECTED_PIECE)) {
		[m_board boardPiecePlaceWasSelected:self];
		return YES;
	}
	return NO;
}

- (BOOL) containsTouchLocation:(UITouch *)touch {
	return CGRectContainsPoint(m_rect, [self convertTouchToNodeSpaceAR:touch]);
}

-(void) select {
	NSAssert(m_state==UNSELECTED_PIECE, @"m_state must be UNSELECTED_PIECE in select.");
	[self changeBoardPiecePlaceState:SELECTED_PIECE];
}

-(void) unselect {
	NSAssert(m_state==SELECTED_PIECE, @"m_state must be SELECTED_PIECE in unselect.");
	[self changeBoardPiecePlaceState:UNSELECTED_PIECE];
}

/*!
 Called by Board to start a correct matching sequence.
 */
-(void) correctMatching {
	NSAssert((m_state==SELECTED_PIECE || m_state==UNSELECTED_PIECE), @"m_state must be SELECTED_PIECE or UNSELECTED_PIECE in correctMatching.");
	[self changeBoardPiecePlaceState:STARTING_CORRECT_MATCHING];
}

/*!
Called in the middle of a correct matching sequence.
Used to play correct matching sound and remove piece sprite.
*/
-(void) correctMatchingWillBeDoneCallback:(id)sender {
	[self changeBoardPiecePlaceState:ENDING_CORRECT_MATCHING];
}

/*!
Called after correct matching sequence was done. Used to change object's state. 
*/
-(void) correctMatchingWasDoneCallback:(id)sender {	
	[self changeBoardPiecePlaceState:EMPTY];
}

/*!
Called by Board. 
*/
-(void) incorrectMatching {
	NSAssert((m_state==SELECTED_PIECE || m_state==UNSELECTED_PIECE), @"m_state must be SELECTED_PIECE or UNSELECTED_PIECE in incorrectMatching.");
	[self changeBoardPiecePlaceState:INCORRECT_MATCHING];
}

/*!
 Called after incorrect matching sequence was done. Used to change object's state. 
 */
-(void) incorrectMatchingWasDoneCallback:(id)sender {
	[self changeBoardPiecePlaceState:UNSELECTED_PIECE];
}

- (void) onEnter		
{	
	[super onEnter];
}

- (void) onExit
{
	[super onExit];
}	

/*!
Sets currentPiece and change state to UNSELECTED. 
Precondition: state must be EMPTY.
Call reset in order to change to EMPTY state.
*/
-(void) setPiece:(Piece*)piece {
	NSAssert(m_state==EMPTY, @"m_state must be EMPTY in setPiece.");
	m_currentPiece=piece;
	[self changeBoardPiecePlaceState:UNSELECTED_PIECE];
}

/*!
Removes Piece if used and selection or matching animation.
Change state to EMPTY.
*/
-(void) reset {
	m_state=EMPTY;
	m_currentPiece=nil;
	[self removeAllChildrenWithCleanup:true];
}
/*!
 Dummy method for CCRGBAProtocol protocol.
 */
- (ccColor3B) color {
	return ccWHITE;
}

/*!
 Dummy method for CCRGBAProtocol protocol.
 */
- (void) setColor:(ccColor3B)color {
	
}

/*!
 Dummy method for CCRGBAProtocol protocol.
 */
- (GLubyte) opacity {
	return 255;
}

- (void) setOpacity:(GLubyte) opacity {
	if (m_state==EMPTY) {
	 
	 } else if (m_state==UNSELECTED_PIECE) {
		 CCSprite* pieceSprite=(CCSprite*)[self getChildByTag:PIECE_SPRITE_TAG];
		 [pieceSprite setOpacity:opacity];
	 
	 } else if (m_state==SELECTED_PIECE) {
		 CCSprite* pieceSprite=(CCSprite*)[self getChildByTag:PIECE_SPRITE_TAG];
		 [pieceSprite setOpacity:opacity];
		 
		 CCSprite* selectedSprite=(CCSprite*)[self getChildByTag:SELECTION_SPRITE_TAG];
		 [selectedSprite setOpacity:opacity];
	 
	 } else if (m_state==ENDING_CORRECT_MATCHING) {
		 CCSprite* matchingSprite=(CCSprite*)[self getChildByTag:MATCHING_SPRITE_TAG];
		 [matchingSprite setOpacity:opacity];
	 
	 } else if (m_state==STARTING_CORRECT_MATCHING) {
		 CCSprite* pieceSprite=(CCSprite*)[self getChildByTag:PIECE_SPRITE_TAG];
		 [pieceSprite setOpacity:opacity];
		 
		 CCSprite* matchingSprite=(CCSprite*)[self getChildByTag:MATCHING_SPRITE_TAG];
		 [matchingSprite setOpacity:opacity];
		 
	 } else if (m_state==INCORRECT_MATCHING) {
		 CCSprite* pieceSprite=(CCSprite*)[self getChildByTag:PIECE_SPRITE_TAG];
		 [pieceSprite setOpacity:opacity];
		 
		 CCSprite* matchingSprite=(CCSprite*)[self getChildByTag:MATCHING_SPRITE_TAG];
		 [matchingSprite setOpacity:opacity];
	 
	 } else {
		 NSLog(@"Unknown BoardPiecePlace state in setOpacity.");
		 exit(1);
	 }
}

-(void) onEnterBoardPiecePlaceState:(BoardPiecePlaceState)state {
	if (state==EMPTY) {
		
	} else if (state==UNSELECTED_PIECE) {
		
	} else if (state==SELECTED_PIECE) {
		// add a sprite for selection and its animation
		CCSprite* selectedSprite=[CCSprite spriteWithTexture:[m_board m_selectedTexture]];
		selectedSprite.tag=SELECTION_SPRITE_TAG;
		[self addChild:selectedSprite];
		CCRepeatForever* selectedAction=[[m_board m_selectedAction] copy];
		[selectedSprite runAction:selectedAction];
		[selectedAction release];
		
	} else if (state==STARTING_CORRECT_MATCHING) {
		// add sprite where matching sequence will be executed	
		CCSprite* startingMatchingSprite=[CCSprite spriteWithTexture:[m_board m_startingMatchingTexture]];
		startingMatchingSprite.tag=MATCHING_SPRITE_TAG;
		[self addChild:startingMatchingSprite];
		
		// create sequence action
		CCAnimate* startingMatchingAction=[[m_board m_startingMatchingAction] copy];
		CCAnimate* correctMatchingEndingAction=[[m_board m_correctMatchingEndingAction] copy];
		
		id action=[CCSequence actions:
				   startingMatchingAction,
				   [CCCallFunc actionWithTarget:self selector:@selector(correctMatchingWillBeDoneCallback:)],
				   correctMatchingEndingAction,
				   [CCCallFunc actionWithTarget:self selector:@selector(correctMatchingWasDoneCallback:)],
				   nil];
		
		[startingMatchingAction release];
		[correctMatchingEndingAction release];
		
		// run action
		[startingMatchingSprite runAction:action];
		
	} else if (state==ENDING_CORRECT_MATCHING) {
		
	} else if (state==INCORRECT_MATCHING) {
		// add sprite where matching sequence will be executed	
		CCSprite* startingMatchingSprite=[CCSprite spriteWithTexture:[m_board m_startingMatchingTexture]];
		startingMatchingSprite.tag=MATCHING_SPRITE_TAG;
		[self addChild:startingMatchingSprite];
		[m_board reorderChild:self z:1];
		
		// create sequence action
		CCAnimate* startingMatchingAction=[[m_board m_startingMatchingAction] copy];
		CCAnimate* incorrectMatchingEndingAction=[[m_board m_incorrectMatchingEndingAction] copy];
		id action=[CCSequence actions:
				   startingMatchingAction,
				   incorrectMatchingEndingAction,
				   [CCCallFunc actionWithTarget:self selector:@selector(incorrectMatchingWasDoneCallback:)],
				   nil];
		[startingMatchingAction release];
		[incorrectMatchingEndingAction release];
		
		// run action
		[startingMatchingSprite runAction:action];
	}	
}

-(void) onExitBoardPiecePlaceState:(BoardPiecePlaceState)state {
	if (state==EMPTY) {
		CCSpriteFrame* pieceSpriteFrame=[m_currentPiece m_spriteFrame];
		CCSprite* sprite=[CCSprite spriteWithSpriteFrame:pieceSpriteFrame];
		sprite.tag=PIECE_SPRITE_TAG;
		[self addChild:sprite];	
		
	} else if (state==UNSELECTED_PIECE) {
		
	} else if (state==SELECTED_PIECE) {
		[self removeChildByTag:SELECTION_SPRITE_TAG cleanup:YES];
		
	} else if (state==STARTING_CORRECT_MATCHING) {
		[self removeChildByTag:PIECE_SPRITE_TAG cleanup:YES];
		
	} else if (state==ENDING_CORRECT_MATCHING) {
		[self removeChildByTag:MATCHING_SPRITE_TAG cleanup:YES];
		
	} else if (state==INCORRECT_MATCHING) {
		[m_board reorderChild:self z:1];
		[self removeChildByTag:MATCHING_SPRITE_TAG cleanup:YES];
	}	
}

-(void) changeBoardPiecePlaceState:(BoardPiecePlaceState)state {
	[self onExitBoardPiecePlaceState:m_state];
	if (m_state==EMPTY && state==UNSELECTED_PIECE) {

	} else if (m_state==UNSELECTED_PIECE && state==SELECTED_PIECE) {
		
	} else if (m_state==SELECTED_PIECE && state==UNSELECTED_PIECE) {
		
	} else if (m_state==SELECTED_PIECE && state==STARTING_CORRECT_MATCHING) {
		
	} else if (m_state==STARTING_CORRECT_MATCHING && state==ENDING_CORRECT_MATCHING) {
		
	} else if (m_state==ENDING_CORRECT_MATCHING && state==EMPTY) {
		
	} else if (m_state==SELECTED_PIECE && state==INCORRECT_MATCHING) {
		
	} else if (m_state==INCORRECT_MATCHING && state==UNSELECTED_PIECE) {
		
	} else if (m_state==UNSELECTED_PIECE && state==STARTING_CORRECT_MATCHING) {
		
	} else if (m_state==UNSELECTED_PIECE && state==INCORRECT_MATCHING) {
		
	} else {
		NSLog(@"Unknown transition.");
		exit(1);
	}
	m_state=state;
	[self onEnterBoardPiecePlaceState:state];
}

-(void) dealloc {
	[self reset];
	[super dealloc];
}

@end
