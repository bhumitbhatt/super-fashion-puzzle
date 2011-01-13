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

#import "LocalHighscoresModel.h"

@implementation LocalHighscoresModel

#define MAX_LOCAL_SCORES 50
#define kFilename @"archive"
#define kLocalHighscoresKey @"LocalHighscores"

- (id)init {
	self = [super init];
    if (self!=nil) {
	
		// try to load it, otherwise create a default set
		if (![self loadData]) {
			m_localHighscores=[[NSMutableArray alloc] init];
			for (int i=0; i<MAX_LOCAL_SCORES; i++) {
				LocalScore* localScore=[[[LocalScore alloc] init] autorelease];
				localScore.m_name=@"Player1";
				localScore.m_points=MAX_LOCAL_SCORES-i;
				localScore.m_level=0;
				[m_localHighscores addObject:localScore];
			}
		}
    }
    return self;
}

/*!
Tries to de-serialize local highscores from disk and tells if it was sucessfull.  
*/
-(BOOL) loadData {
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
		NSData* data=[[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
		NSKeyedUnarchiver* unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		m_localHighscores=(NSMutableArray*)[unarchiver decodeObjectForKey:kLocalHighscoresKey];
		[unarchiver finishDecoding];
		[unarchiver release];
		[data release];
		if (m_localHighscores!=nil) {
			[m_localHighscores retain];
			return YES;
		}
		return NO;
	}
	return NO;
}

-(NSUInteger) getCount {
	return [m_localHighscores count];
}

-(LocalScore*) getLocalScore:(NSUInteger)index {
	NSAssert(index<[m_localHighscores count], @"index must be less than m_localScores count.");
	return (LocalScore*)[m_localHighscores objectAtIndex:index];	
}

/*!
Save this score only if it is a highscore, that is, it is among MAX_LOCAL_SCORES best scores. 
*/
-(void) saveScoreIfNecessary:(LocalScore*)score {

	// localHighscores model is ordered (first one is the higher one). 
	// If found anyone greater or equal, then insert before it and remove last one.
	for (int i=0; i<[m_localHighscores count]; i++) {
		LocalScore* aLocalScore=[m_localHighscores objectAtIndex:i];
		if (score.m_points>=aLocalScore.m_points) {
			[m_localHighscores insertObject:score atIndex:i];
			[m_localHighscores removeLastObject];
			return;
		}
	}
}

-(NSString*) dataFilePath {
	NSArray* paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory=[paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

-(void) reset {
	[m_localHighscores removeAllObjects];
	for (int i=0; i<MAX_LOCAL_SCORES; i++) {
		LocalScore* localScore=[[[LocalScore alloc] init] autorelease];
		localScore.m_name=@"Player1";
		localScore.m_points=MAX_LOCAL_SCORES-i;
		localScore.m_level=0;
		[m_localHighscores addObject:localScore];
	}
}

-(NSUInteger) getBestLocalHighscorePoints {
	if ([m_localHighscores count]==0) return 0;
	LocalScore* localScore=[m_localHighscores objectAtIndex:0];
	return localScore.m_points;
}

-(void) dealloc {
	
	// save data model
	NSMutableData* data=[[NSMutableData alloc] init];
	NSKeyedArchiver* archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:m_localHighscores forKey:kLocalHighscoresKey];
	[archiver finishEncoding];
	[data writeToFile:[self dataFilePath] atomically:YES];
	[archiver release];
	[data release];
	[m_localHighscores release];
	[super dealloc];
}

@end
