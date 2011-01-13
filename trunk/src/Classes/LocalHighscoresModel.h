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

#import <Foundation/Foundation.h>
#import "LocalScore.h"

@interface LocalHighscoresModel : NSObject {
	NSMutableArray* m_localHighscores;
}
-(BOOL) loadData;
-(LocalScore*) getLocalScore:(NSUInteger)index;
-(NSUInteger) getCount;
-(void) saveScoreIfNecessary:(LocalScore*)score;
-(void) reset;
-(NSString*) dataFilePath;
-(NSUInteger) getBestLocalHighscorePoints;
@end
