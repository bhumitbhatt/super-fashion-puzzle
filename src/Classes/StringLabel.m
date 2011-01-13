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

#import "StringLabel.h"

@implementation StringLabel

-(id) init {
	return [self initWithFontSize:30 Offset:2 FontName:@"Helvetica" ForegroundColor:ccBLACK BackgroundColor:ccWHITE];
}

-(id) initWithFontSize:(float)fontSize Offset:(int)offset FontName:(NSString*)fontName ForegroundColor:(ccColor3B)foregroundColor BackgroundColor:(ccColor3B)backgroundColor {
	if( (self=[super initWithFontSize:fontSize Offset:offset FontName:fontName ForegroundColor:foregroundColor BackgroundColor:backgroundColor]) ) {		
		m_string=@"";
	}
	return self;
}

/*!
Save this new string in this instance and update base class with this new string. 
*/
-(void) setString:(NSString*)text {
	if (m_string!=text) {
		[m_string release];
		[text retain];
		m_string=text;
		[super setString:m_string];
	}
}

-(NSString*) getString {
	return m_string;
}

-(void) dealloc {
	[super dealloc];
}
@end
