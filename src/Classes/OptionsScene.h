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
#import "FacebookSessionDelegate.h"
#import "WaitView.h"

/*!
El MainMenu reemplaza la escena, pero el manu pause, la apila, y al acabar la ejecución OptionsScene debe desapilarse.
Por tanto, el menú de pausa llamará a setPopAtExit nada más crear el menú de opciones.
*/
@interface OptionsScene : CCScene <FacebookSessionDelegate> {
	bool m_pop_at_exit;
	WaitView* m_waitView;
	CCMenu* m_loginMenu;
	CCMenu* m_logoutMenu;
}
-(void) okButtonPressed: (id)sender;
-(void) rightBoardRadioButtonSelected: (id)sender;
-(void) leftBoardRadioButtonSelected: (id)sender;
-(void) loginButtonPressed:(id)sender;
-(void) logoutButtonPressed:(id)sender;
-(void) setPopAtExit;
@end