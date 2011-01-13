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

@interface HowToPlayScene : CCScene {
	bool m_pop_at_exit;
	int m_index;
	NSMutableArray* m_pages;
}
-(void) okButtonPressed: (id)sender;
-(void) leftArrowButtonPressed: (id)sender;
-(void) rightArrowButtonPressed: (id)sender;
-(void) setPopAtExit;
@end
