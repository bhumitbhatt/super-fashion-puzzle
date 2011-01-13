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

#import "Board.h"
#import "PlayingScene.h"
#import "Constants.h"
#import "SoundManager.h"

@implementation Board

@synthesize m_selectedAction;
@synthesize m_selectedTexture;
@synthesize m_startingMatchingAction;
@synthesize m_correctMatchingEndingAction;
@synthesize m_incorrectMatchingEndingAction;
@synthesize m_startingMatchingTexture;
@synthesize m_playingScene;

#define LIMIT_GIRLS_IN_FREE_VERSION 3

-(id) initWithPlayingScene:(PlayingScene*)playingScene {
	if( (self=[super init] )) {
		
		// board background texture
		CCSprite* board_sprite=[CCSprite spriteWithFile:@"board.png"];
		[self addChild: board_sprite];
		
		// board rect
		m_boardRect=[board_sprite textureRect];
		
		// calculate board size
		CGSize s = [board_sprite contentSize];
		m_boardRect=CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
		
		// pieces texture		
		m_piecesSpriteSheetTexture=[[CCTextureCache sharedTextureCache] addImage:@"pieces.pvr"];	
		CCSpriteFrameCache* spriteFrameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
		[spriteFrameCache addSpriteFramesWithFile:@"pieces.plist" texture:m_piecesSpriteSheetTexture];	
		
		// create 10*5 instances of Piece class
		m_piecesDataBase=[[NSMutableArray alloc] init];
		for (unsigned int girl=0; girl<NUMBER_OF_GIRLS; girl++) {
			NSMutableArray* pieces=[[NSMutableArray alloc] init];
			for (unsigned int piece=0; piece<NUMBER_OF_PIECES_PER_GIRL; piece++) {
				NSString* originalTextureFilename=[NSString stringWithFormat:@"g%d_f%d.png", girl+1, piece+1];
				CCSpriteFrame* spriteFrame=[spriteFrameCache spriteFrameByName:originalTextureFilename];
				Piece* pieceInstance=[[Piece alloc] initNormalPieceWithSpriteFrame:spriteFrame Piece:piece Girl:girl];
				[pieces addObject:pieceInstance];
				[pieceInstance release];
			}
			[m_piecesDataBase addObject:pieces];
			[pieces release];
		}
		
		// wildcard piece
		CCSpriteFrame* wildcardSpriteFrame=[spriteFrameCache spriteFrameByName:@"wildcard.png"];
		NSAssert(wildcardSpriteFrame!=NULL, @"wildcardSpriteFrame cannot be null.");
		m_wildcardPiece=[[Piece alloc] initWildcardWithSpriteFrame:wildcardSpriteFrame];

		// used by BoardPiecePlace when any of them is selected with m_selectedAction
		m_selectedTexture=[[CCTextureCache sharedTextureCache] addImage:@"selection_animated_0001.png"];
		
		// used by BoardPiecePlace when any of them is selected with m_selectedSprite
		CCAnimation* selectedAnimation=[CCAnimation animationWithName:@"selectedAnimation" delay:1/12.0f];
		for (unsigned int i=1; i<=11; i++) {
			NSString* originalTextureFilename=[NSString stringWithFormat:@"selection_animated_%04d.png", i];
			[selectedAnimation addFrameWithFilename:originalTextureFilename];
		}
		m_selectedAction=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:selectedAnimation]];
		[m_selectedAction retain];
		
		// matching starting sequence, used by BoardPiecePlace		
		CCAnimation* startingMatchingAnimation=[CCAnimation animationWithName:@"startingMatchingAnimation" delay:1/12.0f];
		for (unsigned int i=1; i<=5; i++) {
			NSString* originalTextureFilename=[NSString stringWithFormat:@"starting_matching_sequence_%04d.png", i];
			[startingMatchingAnimation addFrameWithFilename:originalTextureFilename];
		}
		m_startingMatchingAction=[CCAnimate actionWithAnimation:startingMatchingAnimation];
		[m_startingMatchingAction retain];

		// correct matching ending sequence, used by BoardPiecePlace
		CCAnimation* correctMatchingEndingAnimation=[CCAnimation animationWithName:@"correctMatchingEndingAnimation" delay:1/12.0f];
		for (unsigned int i=6; i<=11; i++) {
			NSString* originalTextureFilename=[NSString stringWithFormat:@"correct_matching_ending_sequence_%04d.png", i];
			[correctMatchingEndingAnimation addFrameWithFilename:originalTextureFilename];
		}
		m_correctMatchingEndingAction=[CCAnimate actionWithAnimation:correctMatchingEndingAnimation];
		[m_correctMatchingEndingAction retain];
		
		// incorrect matching ending sequence, used by BoardPiecePlace
		CCAnimation* incorrectMatchingEndingAnimation=[CCAnimation animationWithName:@"incorrectMatchingEndingAnimation" delay:1/12.0f];
		for (unsigned int i=6; i<=11; i++) {
			NSString* originalTextureFilename=[NSString stringWithFormat:@"incorrect_matching_ending_sequence_%04d.png", i];
			[incorrectMatchingEndingAnimation addFrameWithFilename:originalTextureFilename];
		}
		m_incorrectMatchingEndingAction=[CCAnimate actionWithAnimation:incorrectMatchingEndingAnimation];
		[m_incorrectMatchingEndingAction retain];
	
		// starting matching texture, used by BoardPiecePlace
		m_startingMatchingTexture=[[CCTextureCache sharedTextureCache] addImage:@"starting_matching_sequence_0001.png"];	
		
		// pivot node for BoardPiecePlace
		m_boardPiecePlacesPivotNode=[BoardPiecePlacesPivotNode node];
		[m_boardPiecePlacesPivotNode retain];
		[self addChild:m_boardPiecePlacesPivotNode];
		
		// add 7*7 BoardPiecePlace, each one has a node, and this node is also taken by Board
		// each one with a nodes with their position offsets to create 49 nodes
		// also store it in m_boardPiecePlaces matrix
		float correctedBoardWidth=m_boardRect.size.width-BORDER_MARGIN_IN_PIXELS*2;
		float correctedBoardHeight=m_boardRect.size.height-BORDER_MARGIN_IN_PIXELS*2;
		float pieceWidth=correctedBoardWidth/(float)NUMBER_OF_COLUMNS_IN_BOARD;
		float pieceHeight=correctedBoardHeight/(float)NUMBER_OF_ROWS_IN_BOARD;
		m_boardPiecePlaces=[[NSMutableArray alloc] init];
		for (unsigned int column=0; column<NUMBER_OF_COLUMNS_IN_BOARD; column++) {
			NSMutableArray* rows=[[NSMutableArray alloc] init];
			for (unsigned int row=0; row<NUMBER_OF_ROWS_IN_BOARD; row++) {
				float x=pieceWidth*0.5+pieceWidth*column-correctedBoardWidth*0.5;
				float y=pieceHeight*0.5+pieceHeight*row-correctedBoardHeight*0.5;
				CGSize size;
				size.width=pieceWidth;
				size.height=pieceHeight;
				BoardPiecePlace* boardPiecePlace=[[BoardPiecePlace alloc] initWithBoard:self Column:column Row:row PieceSize:size];
				boardPiecePlace.position=ccp(x,y);
				[m_boardPiecePlacesPivotNode addChild:boardPiecePlace];
				[rows addObject:boardPiecePlace];
				[boardPiecePlace release];
			}
			[m_boardPiecePlaces addObject:rows];
			[rows release];
		}
	
		// init vars
		m_playingScene=playingScene;
		[self reset];
		//[self regenerate:0];
	}
	return self;
}

- (BOOL) containsTouchLocation:(UITouch *)touch {
	return CGRectContainsPoint(m_boardRect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	for (unsigned int column=0; column<NUMBER_OF_COLUMNS_IN_BOARD; column++) {
		for (unsigned int row=0; row<NUMBER_OF_ROWS_IN_BOARD; row++) {
			BoardPiecePlace* bpp=[self getBoardPiecePlaceAtColumn:column Row:row];
			if ([bpp processTouch:touch]) return YES;
		}
	}
	return NO;
}

-(void) onEnter {
	NSLog(@"onEnter del Board");
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

-(void) onExit {
	NSLog(@"onExit del Board");
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

/*!
Resets all Board vars.
*/
-(void) reset {
	m_selectedBoardPiecePlace=nil;
	m_numberOfRegenerations=0;
	m_numberOfMatches=0;
	m_state=WAITING_USER_INPUT_WO_CHIP_SELECTED;
	for (unsigned int column=0; column<NUMBER_OF_COLUMNS_IN_BOARD; column++) {
		for (unsigned int row=0; row<NUMBER_OF_ROWS_IN_BOARD; row++) {
			[[self getBoardPiecePlaceAtColumn:column Row:row] reset];
		}
	}
}

/*!
Gets a random wildcard number for this level.
*/
-(NSUInteger) getNumberOfWildcardsForLevel:(NSUInteger)level {
	float p3wc=0;
	float p2wc=0;
	float p1wc=0;

	// EASY
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		p3wc=0.1;
		p2wc=0.25;
		p1wc=0.5;
		
	// MEDIUM
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		p3wc=0.1;
		p2wc=0.1;
		p1wc=0.2;
		
	// HARD
	} else { // level>=HARD_MODE_STARTS_IN_LEVEL
		p3wc=0;
		p2wc=0;
		p1wc=0;
	}
	
	// between 0 and 10000
	unsigned int aux=arc4random() % (10000+1);
	float r=aux/10000.0;
	
	// 3 wildcards
	if (r>=0 && r<p3wc) {
		return 3;
		
	// 2 wildcards
	} else if (r>=p3wc && r<p3wc+p2wc) {
		return 2;
		
	// 1 wildcard
	} else if (r>=p3wc+p2wc && r<p3wc+p2wc+p1wc) {
		return 1;	
	} 

	// no wildcards (r>=p3wc+p2wc+p1wc && <=1)
	return 0;
}

/*!
Resets all BoardPiecePlaces and gives them new Pieces.
*/
-(void) regenerate:(unsigned int)level {
	
	NSLog(@"Regenerating board for level %d", level);

	// reset all BoardPiecePlace
	for (unsigned int column=0; column<NUMBER_OF_COLUMNS_IN_BOARD; column++) {
		for (unsigned int row=0; row<NUMBER_OF_ROWS_IN_BOARD; row++) {
			BoardPiecePlace* boardPiecePlace=[self getBoardPiecePlaceAtColumn:column Row:row];
			[boardPiecePlace reset];			
		}
	}

	unsigned int currrentGirl=level%NUMBER_OF_GIRLS;
	NSMutableArray* auxPieces=[[[NSMutableArray alloc] init] autorelease];

	// how many correct pairs?
	unsigned int pairs=MATCHES_PER_REGENERATION;
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		pairs=MATCHES_PER_REGENERATION+EXTRA_PAIRS_IN_EASY_MODE;
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		pairs=MATCHES_PER_REGENERATION+EXTRA_PAIRS_IN_MEDIUM_MODE;
	} else { // level>=HARD_MODE_STARTS_IN_LEVEL
		pairs=MATCHES_PER_REGENERATION+EXTRA_PAIRS_IN_HARD_MODE;
	}
	
	// create 4 matches using current girl and place them in random positions
	for (unsigned int i=0; i<pairs; i++) {
		Piece* randomCurrentGirlPiece=[self getPiece:arc4random()%NUMBER_OF_PIECES_PER_GIRL FromGirl:currrentGirl];
		[auxPieces addObject:randomCurrentGirlPiece];
		[auxPieces addObject:randomCurrentGirlPiece];
	}

	// add some wildcards
	NSUInteger numberOfWildcards=[self getNumberOfWildcardsForLevel:level];
	for (NSUInteger i=0; i<numberOfWildcards; i++) {
		[auxPieces addObject:m_wildcardPiece];
	}
	
	// add random pairs (not with current girl)
	while ([auxPieces count]<NUMBER_OF_COLUMNS_IN_BOARD*NUMBER_OF_ROWS_IN_BOARD) {
		NSUInteger girl=arc4random()%NUMBER_OF_GIRLS;
		if (currrentGirl==girl) continue;
		Piece* pieceInstance=[self getPiece:arc4random()%NUMBER_OF_PIECES_PER_GIRL FromGirl:girl];
		[auxPieces addObject:pieceInstance];
		[auxPieces addObject:pieceInstance];
	}
	
	// there must be exactly NUMBER_OF_COLUMNS_IN_BOARD*NUMBER_OF_ROWS_IN_BOARD pieces (maybe there are more)
	while ([auxPieces count]!=NUMBER_OF_COLUMNS_IN_BOARD*NUMBER_OF_ROWS_IN_BOARD) {
		[auxPieces removeLastObject];
	}
	
	// shuffle or randomize this array
	for (int i = [auxPieces count]; i > 1; i--) {
		[auxPieces exchangeObjectAtIndex:i-1 withObjectAtIndex:arc4random()%i];  // introduces modulo bias (see below)
	}
	
	// fill with random pieces
	NSUInteger i=0;
	for (unsigned int column=0; column<NUMBER_OF_COLUMNS_IN_BOARD; column++) {
		for (unsigned int row=0; row<NUMBER_OF_ROWS_IN_BOARD; row++) {
			BoardPiecePlace* boardPiecePlace=[self getBoardPiecePlaceAtColumn:column Row:row];
			[boardPiecePlace setPiece:[auxPieces objectAtIndex:i]];
			i++;
		}
	}
}

-(BoardPiecePlace*) getBoardPiecePlaceAtColumn:(unsigned int)column Row:(unsigned int)row {
	NSAssert( column<NUMBER_OF_COLUMNS_IN_BOARD, @"column must be less than NUMBER_OF_COLUMNS_IN_BOARD");
	NSAssert( row<NUMBER_OF_ROWS_IN_BOARD, @"row must be less than NUMBER_OF_ROWS_IN_BOARD");
	NSMutableArray* rows=[m_boardPiecePlaces objectAtIndex:column];
	BoardPiecePlace* boardPiecePlace=[rows objectAtIndex:row];
	return boardPiecePlace;
}

-(Piece*) getPiece:(unsigned int)piece FromGirl:(unsigned int)girl {
	NSAssert( piece<NUMBER_OF_PIECES_PER_GIRL, @"piece must be less than NUMBER_OF_PIECES_PER_GIRL");
	NSAssert( girl<NUMBER_OF_GIRLS, @"girl must be less than NUMBER_OF_GIRLS");
	NSMutableArray* pieces=[m_piecesDataBase objectAtIndex:girl];
	Piece* pieceInstance=[pieces objectAtIndex:piece];
	return pieceInstance;
}

/*!
Called by BoardPiecePlace in ccTouchBegin. 
*/
-(BOOL) canBoardPiecePlaceBeSelected {
	return [m_playingScene isPlaying] && (m_state==WAITING_USER_INPUT_WO_CHIP_SELECTED || m_state==WAITING_USER_INPUT_WITH_CHIP_SELECTED);
}	

/*!
Called by BoardPiecePlace when it user taps it.
*/
-(void) boardPiecePlaceWasSelected:(BoardPiecePlace*)boardPiecePlace {
	
	// there was no BoardPiecePlace selected
	if (m_state==WAITING_USER_INPUT_WO_CHIP_SELECTED && m_selectedBoardPiecePlace==nil) {
		NSLog(@"There was nothing selected.");
		[boardPiecePlace select];
		m_selectedBoardPiecePlace=boardPiecePlace;
		[self changeBoardState:WAITING_USER_INPUT_WITH_CHIP_SELECTED];
		
	// there was a BoardPiecePlace selected
	} else if (m_state==WAITING_USER_INPUT_WITH_CHIP_SELECTED && m_selectedBoardPiecePlace!=nil) {
		NSLog(@"Something was selected.");
		
		Piece* pieceA=[m_selectedBoardPiecePlace m_currentPiece];
		Piece* pieceB=[boardPiecePlace m_currentPiece];
		unsigned int currentGirl=[[m_playingScene m_backgroundGirls] m_currentGirlNumber];
		
		// is it the same BoardPiecePlace that was already selected?
		if (boardPiecePlace==m_selectedBoardPiecePlace) {
			NSLog(@"Unselecting a BoardPiecePlace that was already selected.");
			[[SoundManager sharedSoundManager] playSoundFxChipWasUnselected];
			[boardPiecePlace unselect];
			[self changeBoardState:WAITING_USER_INPUT_WO_CHIP_SELECTED];
		
		// a normal correct match (no wildcards involved), both pieces belong to the current girl and both contain the same piece
		} else if (pieceA!=m_wildcardPiece &&
				   pieceB!=m_wildcardPiece &&
				   [pieceA m_girl]==currentGirl &&
				   [pieceB m_girl]==currentGirl &&
				   [pieceA m_piece]==[pieceB m_piece]) {
			[self correctMatchWasDone:false BoardPiecePlace:boardPiecePlace];
			
		// a corrrect match using a wildcard (or two)
		} else if ((pieceA==m_wildcardPiece && [pieceB m_girl]==currentGirl) ||
				   (pieceB==m_wildcardPiece && [pieceA m_girl]==currentGirl) ||
				   (pieceB==m_wildcardPiece && pieceA==m_wildcardPiece)) {
			//[self correctMatchWasDoneWithWildcard:true];
			[self correctMatchWasDone:true BoardPiecePlace:boardPiecePlace];
			
		// there is an incorrect match
		} else {
			[self incorrectMatchWasDone:boardPiecePlace];

		}
		
	// something strange
	} else {
		NSLog(@"Unknown state in boardPiecePlaceWasSelected.");
		exit(1);
	}
}

/*!
Called by boardPiecePlaceWasSelected when an incorrect match is done. 
*/
-(void) incorrectMatchWasDone:(BoardPiecePlace*)boardPiecePlace {
	NSLog(@"Incorrect match.");
	
	// less time
	unsigned int level=[[m_playingScene m_levelLabel] getUInteger];
	// easy
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		[m_playingScene.m_timeBar removeSomeTime:TIME_REMOVED_IN_EASY_MODE];
		// medium
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		[m_playingScene.m_timeBar removeSomeTime:TIME_REMOVED_IN_EASY_MODE];
		// hard level>=HARD_MODE_STARTS_IN_LEVEL
	} else {
		[m_playingScene.m_timeBar removeSomeTime:TIME_REMOVED_IN_EASY_MODE];
	}

	[m_selectedBoardPiecePlace incorrectMatching];
	[boardPiecePlace incorrectMatching];
	[[SoundManager sharedSoundManager] playSoundFxIncorrectMatching];
	[self changeBoardState:WAITING_USER_INPUT_WO_CHIP_SELECTED];
}

/*!
Called by boardPiecePlaceWasSelected after a correct match was done. 
*/
-(void) correctMatchWasDone:(bool)withWildcard BoardPiecePlace:(BoardPiecePlace*)boardPiecePlace {

	//clock_t t_ini=clock();
	
	// more points 
	if (withWildcard) {
		[m_playingScene.m_scoreLabel setUInteger:POINTS_ADDED_WHEN_WILDCARD_MATCH+[m_playingScene.m_scoreLabel getUInteger]];
	} else {
		[m_playingScene.m_scoreLabel setUInteger:POINTS_ADDED_WHEN_NORMAL_MATCH+[m_playingScene.m_scoreLabel getUInteger]];
	}
	
	//clock_t t_fin=clock();
	//double secs=(double)(t_fin-t_ini)/CLOCKS_PER_SEC;
	//printf("++++ %.16g ms\n", secs*1000.0);
	
	// more time
	unsigned int level=[[m_playingScene m_levelLabel] getUInteger];
	// easy
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		[m_playingScene.m_timeBar addSomeTime:TIME_GIVEN_IN_EASY_MODE];
	// medium
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		[m_playingScene.m_timeBar addSomeTime:TIME_GIVEN_IN_MEDIUM_MODE];
	// hard level>=HARD_MODE_STARTS_IN_LEVEL
	} else {
		[m_playingScene.m_timeBar addSomeTime:TIME_GIVEN_IN_HARD_MODE];
	}
	m_numberOfMatches++;
	
	// start corrrect matching animation in both places
	[m_selectedBoardPiecePlace correctMatching];
	[boardPiecePlace correctMatching];

	// regeneration
	if (m_numberOfMatches==MATCHES_PER_REGENERATION  && m_numberOfRegenerations<REGENERATIONS_PER_GIRL) {
		id actionFirstStage=[CCSpawn actions:
							 //[CCRotateBy actionWithDuration:REGENERATION_BOARD_DURATION*0.5 angle: 360],
							 //[CCScaleBy actionWithDuration:REGENERATION_BOARD_DURATION*0.5 scale:0],
							 [CCFadeOut actionWithDuration:REGENERATION_BOARD_DURATION*0.5],
							 nil];
		
		id action=[CCSequence actions:
				actionFirstStage,
				[CCCallFunc actionWithTarget:self selector:@selector(inTheMiddleOfRegenerationSequenceCallback:)],
				nil];
		
		// note: second stage will be done in inTheMiddleOfRegenerationSequenceCallback in order to avoid a time problem 
		
		[m_boardPiecePlacesPivotNode runAction:action];
		[self changeBoardState:REGENERATING_BOARD];
	 
	 // change girl (or game over in free version if 3 girls were played)
	 } else if (m_numberOfMatches==MATCHES_PER_REGENERATION && m_numberOfRegenerations==REGENERATIONS_PER_GIRL) {
		 
		 // is free version?
		 BOOL freeVersion=NO;
#ifdef FREE_VERSION
		 freeVersion=YES;
#endif
		 
		 // force game over if free version after 3 girls or levels
		 if ([m_playingScene getLevel]+1==LIMIT_GIRLS_IN_FREE_VERSION && freeVersion) {
			 [m_playingScene playedTooMuch];
			 
		// normal change girl
		 } else {
			 id action=[CCSequence actions:
						[CCShow action],
						[CCFadeIn actionWithDuration:CHANGE_GIRL_DURATION*0.5],
						[CCCallFunc actionWithTarget:self selector:@selector(inTheMiddleOfChangeGirlSequenceCallback:)],
						[CCFadeOut actionWithDuration:CHANGE_GIRL_DURATION*0.5],
						[CCCallFunc actionWithTarget:self selector:@selector(changeGirlSequenceWasDoneCallback:)],
						[CCHide action],
						nil];
			 
			 [[m_playingScene m_girlTransition] runAction:action];
			 [self changeBoardState:CHANGING_GIRL]; 
		 }
	 
	 // normal match (with or wo wildcard), m_numberOfMatches<MATCHES_PER_REGENERATION
	 } else {
		 if (withWildcard) {
			 [[SoundManager sharedSoundManager] playSoundFxCorrectMatchingWithWildcard];
		 } else {
			 [[SoundManager sharedSoundManager] playSoundFxCorrectMatching];
		 }
		 [self changeBoardState:WAITING_USER_INPUT_WO_CHIP_SELECTED];			
	 }
}

/*!
A new board is generated.
*/
-(void) inTheMiddleOfRegenerationSequenceCallback:(id)sender {
	unsigned int level=[m_playingScene getLevel];
	[self  regenerate:level];
	
	// second part of sequence
	id actionSecondStage=[CCSpawn actions:[CCFadeIn actionWithDuration:REGENERATION_BOARD_DURATION*0.5], nil];
	
	id action=[CCSequence actions:
			   actionSecondStage,
			   [CCCallFunc actionWithTarget:self selector:@selector(regenerationSquenceWasDone:)],
			   nil];
	
	[m_boardPiecePlacesPivotNode runAction:action];
}

-(void) regenerationSquenceWasDone:(id)sender {
	[self changeBoardState:WAITING_USER_INPUT_WO_CHIP_SELECTED];
}

/*!
Next girls is used, level is incremented and a new board is generated.
*/
-(void) inTheMiddleOfChangeGirlSequenceCallback:(id)sender {

	// next level
	unsigned int level=[m_playingScene getLevel];
	[[m_playingScene m_levelLabel] setUInteger:level+1];

	// change timebar time
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		[[m_playingScene m_timeBar] setDuration:TIMEBAR_DURATION_IN_EASY_MODE];
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		[[m_playingScene m_timeBar] setDuration:TIMEBAR_DURATION_IN_MEDIUM_MODE];
	} else { // level>=HARD_MODE_STARTS_IN_LEVEL
		[[m_playingScene m_timeBar] setDuration:TIMEBAR_DURATION_IN_HARD_MODE];
	}
	
	// next girl
	[[m_playingScene m_backgroundGirls] incrementGirl];
	[self regenerate:level+1];
}

-(void) changeGirlSequenceWasDoneCallback:(id)sender {
	[self changeBoardState:WAITING_USER_INPUT_WO_CHIP_SELECTED];
}

-(void) onEnterBoardState:(BoardState)state {
	if (state==REGENERATING_BOARD) {
		[[SoundManager sharedSoundManager] playSoundFxRegeneration];
		m_numberOfMatches=0;
		m_numberOfRegenerations++;
		[[m_playingScene m_timeBar] deactivate];
		
	} else if (state==CHANGING_GIRL) {
		[[SoundManager sharedSoundManager] playSoundFxNewGirl];
		m_numberOfMatches=0;
		m_numberOfRegenerations=0;
		[[m_playingScene m_timeBar] deactivate];
		
	} else if (state==WAITING_USER_INPUT_WO_CHIP_SELECTED) {
		m_selectedBoardPiecePlace=nil;
		
	} else if (state==WAITING_USER_INPUT_WITH_CHIP_SELECTED) {
		[[SoundManager sharedSoundManager] playSoundFxSelectedChip];
		
	} else {
		NSLog(@"Unknown state in onEnterBoardState.");
		exit(1);
	}
}

-(void) onExitBoardState:(BoardState)state {
	if (state==REGENERATING_BOARD) {
		[[m_playingScene m_timeBar] activate];
		
	} else if (state==CHANGING_GIRL) {
		[[m_playingScene m_timeBar] activate];
		
	} else if (state==WAITING_USER_INPUT_WO_CHIP_SELECTED) {
	
	} else if (state==WAITING_USER_INPUT_WITH_CHIP_SELECTED) {
		[[SoundManager sharedSoundManager] playSoundFxSelectedChip];
		
	} else {
		NSLog(@"Unknown state in onExitBoardState.");
		exit(1);
	}
}

-(void) changeBoardState:(BoardState)state {
	
	[self onExitBoardState:m_state];
	
	if (m_state==WAITING_USER_INPUT_WO_CHIP_SELECTED && state==WAITING_USER_INPUT_WITH_CHIP_SELECTED) {
		
	} else if (m_state==WAITING_USER_INPUT_WITH_CHIP_SELECTED && state==WAITING_USER_INPUT_WO_CHIP_SELECTED) {
		
	} else if (m_state==WAITING_USER_INPUT_WITH_CHIP_SELECTED && state==CHANGING_GIRL) {
			
	} else if (m_state==WAITING_USER_INPUT_WITH_CHIP_SELECTED && state==REGENERATING_BOARD) {
		
	} else if (m_state==REGENERATING_BOARD && state==WAITING_USER_INPUT_WO_CHIP_SELECTED) {
		
	} else if (m_state==CHANGING_GIRL && state==WAITING_USER_INPUT_WO_CHIP_SELECTED) {
	
	} else {
		NSLog(@"Unknown transition.");
		exit(1);
	}
	m_state=state;
	[self onEnterBoardState:state];
}

-(void) dealloc {
	[[CCTextureCache sharedTextureCache] removeTexture:m_selectedTexture];
	[m_selectedAction release];
	[[CCTextureCache sharedTextureCache] removeTexture:m_startingMatchingTexture];	
	[m_startingMatchingAction release];
	[m_correctMatchingEndingAction release];
	[m_incorrectMatchingEndingAction release];
	[m_boardPiecePlacesPivotNode release];
	[m_wildcardPiece release];
	[m_boardPiecePlaces release];
	[m_piecesDataBase release];
	[[CCTextureCache sharedTextureCache] removeTexture:m_piecesSpriteSheetTexture];
	[super dealloc];	
}

@end