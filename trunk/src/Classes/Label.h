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

// A new kind of CCLabel that allows to call getText (CCLabel creates a texture directly from setText)
// This class is used exclusively by GameOverScene in order to rename user's name.
// Contains another 8 labels to create a shadow effect.
// x starts at the left.
// y is centered.
@interface Label : CCLabelTTF {
	
}
-(id) initWithFontSize:(float)fontSize Offset:(int)offset FontName:(NSString*)fontName ForegroundColor:(ccColor3B)foregroundColor BackgroundColor:(ccColor3B)backgroundColor ;
-(void) setString:(NSString*)string;
@end
