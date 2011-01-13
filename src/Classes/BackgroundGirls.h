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
This sprite shows an animated girl, and there are 10 available, from 0 to 9.
*/
@interface BackgroundGirls : CCNode {
	NSMutableArray* m_spriteSheetTextures;
	NSMutableArray* m_differentGirlsActions;
	unsigned int m_currentGirlNumber;
	CCSprite* m_girlSprite;
}
@property (nonatomic,readonly) unsigned int m_currentGirlNumber;
-(void) setGirlNumber:(unsigned int)girlNumber;
-(void) incrementGirl;
@end


