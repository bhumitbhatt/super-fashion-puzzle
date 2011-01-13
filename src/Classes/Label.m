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

#import "Label.h"

@implementation Label

-(id) initWithFontSize:(float)fontSize Offset:(int)offset FontName:(NSString*)fontName ForegroundColor:(ccColor3B)foregroundColor BackgroundColor:(ccColor3B)backgroundColor {
	
	if((self=[super initWithString:@"" dimensions:CGSizeZero alignment:UITextAlignmentLeft fontName:fontName fontSize:fontSize]) ) {		
		self.anchorPoint=ccp(0,0.5);
		self.color=foregroundColor;
		
		for (int i=0; i<8; i++) {
			CCLabelTTF* label=[CCLabelTTF labelWithString:@""
				dimensions:CGSizeZero
				alignment:UITextAlignmentLeft
				fontName:fontName
				fontSize:fontSize];
			
			int h_offset=0;
			int v_offset=0;
			// clock-wise from 0 (north) to 7
			if (i==0) {
				h_offset=0;
				v_offset=offset;
			} else if (i==1) {
				h_offset=offset;
				v_offset=offset;
			} else if (i==2) {
				h_offset=offset;
				v_offset=0;
			} else if (i==3) {
				h_offset=offset;
				v_offset=-offset;
			} else if (i==4) {
				h_offset=0;
				v_offset=-offset;
			} else if (i==5) {
				h_offset=-offset;
				v_offset=-offset;
			} else if (i==6) {
				h_offset=-offset;
				v_offset=0;
			} else if (i==7) {
				h_offset=-offset;
				v_offset=offset;
			}
			label.position = ccp(h_offset, v_offset);
			label.anchorPoint=ccp(0,0);
			label.color=backgroundColor;
			[self addChild:label z:self.zOrder-1];	
		}
	}
	return self;	
}

-(void) setString:(NSString*)string {
	[super setString:string];
	for (CCNode* node in self.children) {
		CCLabelTTF* label=(CCLabelTTF*)node;
		[label setString:string];
	}
}

-(void) dealloc {
	[super dealloc];
}
@end
