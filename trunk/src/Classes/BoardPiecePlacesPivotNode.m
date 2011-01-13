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

#import "BoardPiecePlacesPivotNode.h"
#import "BoardPiecePlace.h"

@implementation BoardPiecePlacesPivotNode

-(id) init {
	if( (self=[super init] )) {
		m_boardPiecePlaces=[[NSMutableArray alloc] init];
	}
	return self;
}

-(void) addChild: (CCNode*) node
{
	NSAssert( node!=nil, @"Argument must be non-nil");
	[m_boardPiecePlaces addObject:node];
	[self addChild:node z:node.zOrder tag:node.tag];
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
	for (BoardPiecePlace* o in m_boardPiecePlaces)
		[o setOpacity:opacity];
}

-(void) dealloc {
	[m_boardPiecePlaces release];	
	[super dealloc];
}

@end
