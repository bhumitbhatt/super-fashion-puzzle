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

@interface MenuMainScene : CCScene {
	CCTexture2D* m_sun_lights_texture;
}

// button callbacks
-(void) howToPlayButtonPressed: (id)sender;
-(void) playButtonPressed: (id)sender;
-(void) optionsButtonPressed: (id)sender;
-(void) scoresButtonPressed: (id)sender;
-(void) creditsButtonPressed: (id)sender;
#ifdef FREE_VERSION
-(void) buyFullVersionButtonPressed:(id)sender;
#endif
@end

