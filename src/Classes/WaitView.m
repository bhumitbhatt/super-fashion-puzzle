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

#import "WaitView.h"

@implementation WaitView

- (id)initWithFrame:(CGRect)frame {
	self=[super initWithFrame:frame];
    if (self!=nil) {
		UILabel* bgLabel=[[[UILabel alloc] initWithFrame:frame] autorelease];
		UIColor* bgColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
		[bgLabel setBackgroundColor:bgColor];
		[bgLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[bgLabel setTextAlignment:UITextAlignmentCenter];
		UIColor* textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		[bgLabel setTextColor:textColor];
		[bgLabel setText:@"Please wait..."];
		[self addSubview:bgLabel];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
