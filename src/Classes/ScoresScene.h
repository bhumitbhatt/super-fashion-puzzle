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

#import "cocos2d.h"
#import "LocalHighscoresViewController.h"
#import "GlobalHighscoresViewController.h"

typedef enum {
	LOCAL,
	GLOBAL
} ScoresState;

@interface ScoresScene : CCScene <UIAlertViewDelegate> {
	LocalHighscoresViewController* m_localHighscoresViewController;
	GlobalHighscoresViewController* m_globalHighscoresViewController;
	ScoresState m_state;
}

// button callbacks
-(void) okButtonPressed: (id)sender;
-(void) resetLocalButtonPressed: (id)sender;
-(void) localButtonPressed: (id)sender;
-(void) globalButtonPressed: (id)sender;
-(void) changeScoresState:(ScoresState)scoresState;

@end