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

#define kLocalScoreNameKey @"Name"
#define kLocalScorePointsKey @"Points"
#define kLocalScoreLevelKey @"Level"

@interface LocalScore : NSObject <NSCoding> {
	NSString* m_name;
	NSUInteger m_points;
	NSUInteger m_level;
}
@property (nonatomic,retain) NSString* m_name;
@property (nonatomic,assign) NSUInteger m_points;
@property (nonatomic,assign) NSUInteger m_level;
@end
