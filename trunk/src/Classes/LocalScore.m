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

#import "LocalScore.h"

@implementation LocalScore

@synthesize m_name;
@synthesize m_points;
@synthesize m_level;

-(id) initWithCoder:(NSCoder*)coder {
	self=[super init];
	if (self!=nil) {
		self.m_name=[coder decodeObjectForKey:kLocalScoreNameKey];
		self.m_points=[coder decodeIntForKey:kLocalScorePointsKey];
		self.m_level=[coder decodeIntForKey:kLocalScoreLevelKey];
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject:self.m_name forKey:kLocalScoreNameKey];
	[coder encodeInt:self.m_points forKey:kLocalScorePointsKey];
	[coder encodeInt:self.m_level forKey:kLocalScoreLevelKey];
}

- (void)dealloc {
    [m_name release];
	[super dealloc];
}

@end
