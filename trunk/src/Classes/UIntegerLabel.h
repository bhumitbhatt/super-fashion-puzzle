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
#import "Label.h"

@interface UIntegerLabel : Label {
	unsigned int m_unsigned_integer;
}
-(id) init;
-(id) initWithFontSize:(float)fontSize Offset:(int)offset FontName:(NSString*)fontName ForegroundColor:(ccColor3B)foregroundColor BackgroundColor:(ccColor3B)backgroundColor;
-(void) setUInteger:(unsigned int)uInteger;
-(unsigned int) getUInteger;
@end
