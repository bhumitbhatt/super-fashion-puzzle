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

#import "GlobalHighscoresViewController.h"
#import "HighscoreCell.h"
#import "GlobalHighscoresView.h"
#import "ObjectiveResource.h"
#import "Score.h"
#import "ConnectionManager.h"
#import "Constants.h"

@implementation GlobalHighscoresViewController

@synthesize m_highscores;

- (id)init {
	self = [super init];
    if (self!=nil) {		
		// start server communication
		m_modelDataState=RETRIEVING_DATA;
		m_errorCode=0;
		[[ConnectionManager sharedInstance] runJob:@selector(loadHighscores) onTarget:self];
    }
    return self;
}

/*!
Method called in background in constructor.
*/
-(void) loadHighscores {
	[ObjectiveResourceConfig setSite:@"http://www.superfashionpuzzle.com/"];
	[ObjectiveResourceConfig setResponseType:XmlResponse];
	[ObjectiveResourceConfig setUser:nil];
	[ObjectiveResourceConfig setPassword:nil];
	
	// get it!
	NSError* error=[[[NSError alloc] init] autorelease];
	self.m_highscores=[Score findAllRemoteWithResponse:&error];
	if (error.code!=0) {
		m_modelDataState=ERROR_RETRIEVING_DATA;
		m_errorCode=error.code;
		NSLog(@"Error downloading highscores. Error code: %d. Description: %@", error.code, error.localizedDescription);
	} else {
		m_modelDataState=DATA_WAS_RETRIEVED_CORRECTLY;
		NSLog(@"Highscores downloaded correctly.");
	}
	
	// refresh view (warning: maybe is not loaded)
	if (self.tableView!=nil) {
		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
	}
}

- (void) loadView {	
	CGRect rect=CGRectMake(16, 127, 447, 120);
	self.tableView=[[[GlobalHighscoresView alloc] initWithFrame:rect] autorelease];
	[self.tableView setDataSource:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (m_modelDataState==RETRIEVING_DATA) {
		return 1;
	} else if (m_modelDataState==ERROR_RETRIEVING_DATA) {
		return 1;
	} else if (m_modelDataState==DATA_WAS_RETRIEVED_CORRECTLY) { 
		return [m_highscores count];
	} else {
		return 1;
	}
}

/*
-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Global scores";
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row=[indexPath row];
	float height=self.tableView.rowHeight;	
	float width=self.tableView.frame.size.width;

	// cell values depends on which state we are right now
	if (m_modelDataState==RETRIEVING_DATA) {
		UITableViewCell* cell=[[[HighscoreCell alloc] initHighscoreWithRank:row+1 
			Name:@"Getting data..."
			Country:@""
			Score:0
			Level:0
			IsEven:(row%2==0) 
			Height:height Width:width] autorelease];
		return cell;
		
	} else if (m_modelDataState==ERROR_RETRIEVING_DATA) {
		NSString* errorDescription;
		if (m_errorCode==-1009) {
			errorDescription=[NSString stringWithFormat:@"No Internet"];
		} else if (m_errorCode==-1001) {
			errorDescription=[NSString stringWithFormat:@"Error: Timeout"];
		} else {
			errorDescription=[NSString stringWithFormat:@"Error"];
		}
		UITableViewCell* cell=[[[HighscoreCell alloc] initHighscoreWithRank:row+1 
			Name:errorDescription
			Country:@""
			Score:0
			Level:0
			IsEven:(row%2==0) 
			Height:height Width:width] autorelease];
		return cell;
		
	} else if (m_modelDataState==DATA_WAS_RETRIEVED_CORRECTLY) { 
		Score* score=[m_highscores objectAtIndex:row];
		UITableViewCell* cell=[[[HighscoreCell alloc] initHighscoreWithRank:row+1 
				Name:score.name 
				Country:score.country
				Score:score.points.intValue
				Level:score.level.intValue
				IsEven:(row%2==0) 
				Height:height Width:width] autorelease];	
		return cell;
		
	} else { 
		UITableViewCell* cell=[[[HighscoreCell alloc] initHighscoreWithRank:row+1 
			Name:@"Error"
			Country:@"Error"
			Score:0
			Level:0
			IsEven:(row%2==0) 
			Height:height Width:width] autorelease];	
		return cell;
	}
}

- (void)dealloc {
	[[ConnectionManager sharedInstance] cancelAllJobs];
	[m_highscores release];
    [super dealloc];
}

@end

