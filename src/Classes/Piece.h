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

/*!
Represents a piece. Every girl has 5 different pieces and there are 10 girls.
This object will be used by Board.
*/
@interface Piece : NSObject {
	unsigned int m_girl;
	unsigned int m_piece;
	bool m_isWildcard;
	CCSpriteFrame* m_spriteFrame;
}
-(id) initNormalPieceWithSpriteFrame:(CCSpriteFrame*)spriteFrame Piece:(unsigned int)piece Girl:(unsigned int)girl;
-(id) initWildcardWithSpriteFrame:(CCSpriteFrame*)spriteFrame;
-(void) dealloc;

@property(nonatomic,readonly) unsigned int m_girl;
@property(nonatomic,readonly) unsigned int m_piece;
@property(nonatomic,readonly) bool m_isWildcard;
@property(nonatomic,readonly) CCSpriteFrame* m_spriteFrame;
@end
