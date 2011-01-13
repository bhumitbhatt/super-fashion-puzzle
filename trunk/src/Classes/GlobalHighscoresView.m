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

#import "GlobalHighscoresView.h"
#import "Constants.h"

@implementation GlobalHighscoresView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self != nil) {
		[self setAllowsSelection:NO];
		[self setRowHeight:28];
		[self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
		// setup header
		UIColor* bgColor=[UIColor colorWithRed:0.97 green:0.36 blue:0.93 alpha:1];
		float width=self.frame.size.width;
		float height=20;
		CGRect rect=CGRectMake(0, 0, width, height);
		UIView* header=[[[UIView alloc] initWithFrame:rect] autorelease];
		[header setBackgroundColor:bgColor];
		[self setTableHeaderView:header];
		
		// create rank label
		CGRect rectRank=CGRectMake(0, 0, RANK_WIDTH_PERCENTAGE*width, height);
		id rankLabel=[[[UILabel alloc] initWithFrame:rectRank] autorelease];
		[rankLabel setText:@"#"];
		[rankLabel setBackgroundColor:bgColor];
		[rankLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[rankLabel setTextAlignment:UITextAlignmentCenter];
		[header addSubview:rankLabel];
		
		// create name label
		CGRect rectName=CGRectMake(RANK_WIDTH_PERCENTAGE*width, 0, NAME_WIDTH_PERCENTAGE*width, height);
		id nameLabel=[[[UILabel alloc] initWithFrame:rectName] autorelease];
		[nameLabel setText:@"Name"];
		[nameLabel setBackgroundColor:bgColor];
		[nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[header addSubview:nameLabel];
		
		// country label
		CGRect rectCountry=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE)*width, 0, COUNTRY_WIDTH_PERCENTAGE*width, height);
		id countryLabel=[[[UILabel alloc] initWithFrame:rectCountry] autorelease];
		[countryLabel setText:@"Country"];
		[countryLabel setBackgroundColor:bgColor];
		[countryLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[header addSubview:countryLabel];
		
		// create score label
		CGRect rectScore=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE+COUNTRY_WIDTH_PERCENTAGE)*width, 0, SCORE_WIDTH_PERCENTAGE*width, height);
		id scoreLabel=[[[UILabel alloc] initWithFrame:rectScore] autorelease];
		[scoreLabel setText:@"Score"];
		[scoreLabel setBackgroundColor:bgColor];
		[scoreLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[header addSubview:scoreLabel];
		
		// create level label
		CGRect rectLevel=rectLevel=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE+COUNTRY_WIDTH_PERCENTAGE+SCORE_WIDTH_PERCENTAGE)*width, 0, LEVEL_WIDTH_PERCENTAGE*width, height);
		id levelLabel=[[[UILabel alloc] initWithFrame:rectLevel] autorelease];
		[levelLabel setText:@"Level"];
		[levelLabel setBackgroundColor:bgColor];
		[levelLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[header addSubview:levelLabel];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
