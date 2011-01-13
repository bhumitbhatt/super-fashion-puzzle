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

#import "Piece.h"
#import "Constants.h"

@implementation Piece

@synthesize m_girl;
@synthesize m_piece;
@synthesize m_isWildcard;
@synthesize m_spriteFrame;

-(id) initNormalPieceWithSpriteFrame:(CCSpriteFrame*)spriteFrame Piece:(unsigned int)piece Girl:(unsigned int)girl {
	if((self=[super init])) {
		NSAssert(piece<NUMBER_OF_PIECES_PER_GIRL, @"piece must be less than NUMBER_OF_PIECES_PER_GIRL.");
		NSAssert(girl<NUMBER_OF_GIRLS, @"girl must be less than NUMBER_OF_GIRLS.");
		NSAssert(spriteFrame!=NULL, @"spriteFrame cannot be null.");
		m_girl=girl;
		m_piece=piece;
		m_isWildcard=NO;
		m_spriteFrame=[spriteFrame retain];
	}
	return self;
}

-(id) initWildcardWithSpriteFrame:(CCSpriteFrame*)spriteFrame {
	if((self=[super init])) {
		NSAssert(spriteFrame!=NULL, @"spriteFrame cannot be null.");
		m_girl=0;
		m_piece=0;
		m_isWildcard=YES;
		m_spriteFrame=[spriteFrame retain];
	}
	return self;
}

-(void) dealloc {
	[m_spriteFrame release];
	[super dealloc];
}

@end
