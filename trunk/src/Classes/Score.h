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

#import "ObjectiveResource.h"

/*!
Actually this class represents a global score, but Objective Resource requires it is named Score. 
*/
@interface Score : NSObject {
	NSString* scoreId;
	NSString* name;
	NSString* country;
	NSNumber* points;
	NSNumber* level;
	NSDate* createdAt;
	NSDate* updatedAt;
}
@property (nonatomic , retain) NSString* scoreId;
@property (nonatomic , retain) NSString* name;
@property (nonatomic , retain) NSString* country;
@property (nonatomic , retain) NSNumber* points;
@property (nonatomic , retain) NSNumber* level;
@property (nonatomic , retain) NSDate* createdAt;
@property (nonatomic , retain) NSDate* updatedAt;
@end
