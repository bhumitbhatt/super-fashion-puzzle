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

#import "RenameView.h"

@implementation RenameView

@synthesize m_renameTextField;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		// background
		UIColor* viewBgColor=[UIColor colorWithRed:1 green:0.81 blue:0.96 alpha:0.9];
		[self setBackgroundColor:viewBgColor];
		
		// write your name label
		const float labelWidth=300;
		UILabel* bgLabel=[[[UILabel alloc] initWithFrame:CGRectMake(240-0.5*labelWidth, 40, labelWidth, 30)] autorelease];
		UIColor* bgColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
		[bgLabel setBackgroundColor:bgColor];
		[bgLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[bgLabel setTextAlignment:UITextAlignmentCenter];
		UIColor* textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[bgLabel setTextColor:textColor];
		[bgLabel setText:@"Write your name:"];
		[self addSubview:bgLabel];
		
		// edit field
		const float fieldWidth=300;
		m_renameTextField=[[UITextField alloc] initWithFrame:CGRectMake(240-0.5*fieldWidth, 70, fieldWidth, 30)];
		UIColor* editFieldBackgroundColor=[UIColor whiteColor];
		[m_renameTextField setBackgroundColor:editFieldBackgroundColor];
		[m_renameTextField setBorderStyle:UITextBorderStyleBezel];
		[m_renameTextField setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[m_renameTextField setTextAlignment:UITextAlignmentCenter];
		UIColor* editFieldTextColor=[UIColor blackColor];
		[m_renameTextField setTextColor:editFieldTextColor];
		m_renameTextField.returnKeyType=UIReturnKeyDone;
		m_renameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		m_renameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		m_renameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
		m_renameTextField.keyboardType = UIKeyboardTypeDefault; 
		[self addSubview:m_renameTextField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[m_renameTextField release];
    [super dealloc];
}

@end
