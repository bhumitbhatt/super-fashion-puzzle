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

#import "HighscoreCell.h"
#import "Constants.h"

@implementation HighscoreCell
 
-(id) initHighscoreWithRank:(NSInteger)rank Name:(NSString*)name Country:(NSString*)country Score:(NSInteger)score Level:(NSInteger)level IsEven:(BOOL)isEven Height:(float)height Width:(float)width {

	self = [super  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self!=nil) {
        
		// background
		UIColor* bgColor;
		if (isEven) {
			bgColor=[UIColor colorWithRed:1 green:0.81 blue:0.96 alpha:1];
		} else {
			bgColor=[UIColor whiteColor];
		}
		
		// background label to fix a small separation problem among different text labels
		CGRect bgRank=CGRectMake(0, 0, width, height);
		id bgLabel=[[[UILabel alloc] initWithFrame:bgRank] autorelease];
		[bgLabel setBackgroundColor:bgColor];
		[self addSubview:bgLabel]; 
		
		// create rank label
		CGRect rectRank=CGRectMake(0, 0, RANK_WIDTH_PERCENTAGE*width, height);
		id rankLabel=[[[UILabel alloc] initWithFrame:rectRank] autorelease];
		[rankLabel setText:[NSString stringWithFormat:@"%d", rank]];
		[rankLabel setBackgroundColor:bgColor];
		[rankLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[rankLabel setTextAlignment:UITextAlignmentCenter];
		[self addSubview:rankLabel];
		
		// create name label
		CGRect rectName;
		if (country==nil) { // local
			rectName=CGRectMake(RANK_WIDTH_PERCENTAGE*width, 0, (NAME_WIDTH_PERCENTAGE+COUNTRY_WIDTH_PERCENTAGE)*width, height);
		} else {
			rectName=CGRectMake(RANK_WIDTH_PERCENTAGE*width, 0, NAME_WIDTH_PERCENTAGE*width, height);
		}
		id nameLabel=[[[UILabel alloc] initWithFrame:rectName] autorelease];
		[nameLabel setText:name];
		[nameLabel setBackgroundColor:bgColor];
		[nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[self addSubview:nameLabel];
		
		// create country label, only global highscores scores
		if (country!=nil) { 
			CGRect rectCountry=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE)*width, 0, COUNTRY_WIDTH_PERCENTAGE*width, height);
			id countryLabel=[[[UILabel alloc] initWithFrame:rectCountry] autorelease];
			[countryLabel setText:country];
			[countryLabel setBackgroundColor:bgColor];
			[countryLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
			[self addSubview:countryLabel];
		}

		// create score label
		CGRect rectScore=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE+COUNTRY_WIDTH_PERCENTAGE)*width, 0, SCORE_WIDTH_PERCENTAGE*width, height);
		id scoreLabel=[[[UILabel alloc] initWithFrame:rectScore] autorelease];
		[scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
		[scoreLabel setBackgroundColor:bgColor];
		[scoreLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[self addSubview:scoreLabel];
		
		// create level label
		CGRect rectLevel=rectLevel=CGRectMake((RANK_WIDTH_PERCENTAGE+NAME_WIDTH_PERCENTAGE+COUNTRY_WIDTH_PERCENTAGE+SCORE_WIDTH_PERCENTAGE)*width, 0, LEVEL_WIDTH_PERCENTAGE*width, height);
		id levelLabel=[[[UILabel alloc] initWithFrame:rectLevel] autorelease];
		[levelLabel setText:[NSString stringWithFormat:@"%d", level]];
		[levelLabel setBackgroundColor:bgColor];
		[levelLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		[self addSubview:levelLabel];
    }
    return self;
}

@end
