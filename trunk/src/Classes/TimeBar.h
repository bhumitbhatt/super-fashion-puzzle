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
#import "cocos2d.h"
@class PlayingScene;

/*!
Timebar, es un nodo que contiene 3 sprites que simulan una barra de tiempo
Tamaño: 35*320
Posición con tablero a la derecha: 125+35*0.5
Posición con el tablero a la izquierda: 320-125-35*0.5
*/
@interface TimeBar : CCNode {
	float m_leftTime;
	CCSprite* m_timeBarSprite;
	bool m_isActivated;
	PlayingScene* m_playingScene;
	float m_duration;
}
-(id) initWithPlayingScene:(PlayingScene*)playingScene;
-(void) dealloc;
-(void) update:(ccTime)dt;
-(void) activate;
-(void) deactivate;
-(void) reset;
-(void) addSomeTime:(float)amount;
-(void) removeSomeTime:(float)amount;
-(void) setDuration:(float)duration;
@end
