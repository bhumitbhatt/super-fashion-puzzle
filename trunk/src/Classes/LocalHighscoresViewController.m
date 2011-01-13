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

#import "LocalHighscoresViewController.h"
#import "LocalHighscoresView.h"
#import "HighscoreCell.h"
#import "Constants.h"
#import "LocalScore.h"

@implementation LocalHighscoresViewController

- (id)init {
	self = [super init];
    if (self!=nil) {
		m_localHighscores=[[LocalHighscoresModel alloc] init];
    }
    return self;
}

- (void)loadView {
	CGRect rect=CGRectMake(16, 127, 447, 120);
	self.tableView=[[[LocalHighscoresView alloc] initWithFrame:rect] autorelease];
	[self.tableView setDataSource:self];	
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_localHighscores getCount];
}

/*-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Local scores";
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row=[indexPath row];
	float height=self.tableView.rowHeight;	
	float width=self.tableView.frame.size.width;
	
	NSString* name=[[m_localHighscores getLocalScore:row] m_name];
	NSUInteger points=[[m_localHighscores getLocalScore:row] m_points];
	NSInteger level=[[m_localHighscores getLocalScore:row] m_level];

	UITableViewCell* cell=[[[HighscoreCell alloc] 
		initHighscoreWithRank:row+1 Name:name Country:nil Score:points Level:level IsEven:(row%2==0) Height:height Width:width
	] autorelease];	
	return cell;
}

/*!
Resets highscores file and controller's view. 
*/
-(void) reset {
	NSLog(@"reseteando local scores.");
	[m_localHighscores reset];
	[self.tableView reloadData];
}

- (void)dealloc {
	[m_localHighscores release];
    [super dealloc];
}

@end

