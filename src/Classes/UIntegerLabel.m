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

#import "UIntegerLabel.h"

@implementation UIntegerLabel

-(id) init {
	return [self initWithFontSize:30 Offset:2 FontName:@"Helvetica" ForegroundColor:ccBLACK BackgroundColor:ccWHITE];
}

-(id) initWithFontSize:(float)fontSize Offset:(int)offset FontName:(NSString*)fontName ForegroundColor:(ccColor3B)foregroundColor BackgroundColor:(ccColor3B)backgroundColor {
	if( (self=[super initWithFontSize:fontSize Offset:offset FontName:fontName ForegroundColor:foregroundColor BackgroundColor:backgroundColor]) ) {		
		m_unsigned_integer=0;
	}
	return self;
}

/*!
Save this unsigned integer and update base class with a new string that represents this integer.
*/ 
-(void) setUInteger:(unsigned int)uInteger {
	m_unsigned_integer=uInteger;
	NSString* string=[[NSString stringWithFormat:@"%d", uInteger] retain];
	[super setString:string];
	[string release];
}

-(unsigned int) getUInteger {
	return m_unsigned_integer;
}

-(void) dealloc {
	[super dealloc];
}

@end
