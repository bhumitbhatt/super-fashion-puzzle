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

#import "BackgroundGirls.h"
#import "Constants.h"

@implementation BackgroundGirls

@synthesize m_currentGirlNumber;

-(id) init {
	if( (self=[super init] )) {
		
		// init vars
		m_currentGirlNumber=0;
		
		// frame indices and its size (copied from a text file)
		unsigned int framesIndices[]={1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 9, 8, 1, 8, 9, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 9, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 11, 10, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1, 8, 9, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8, 9, 8, 1, 8, 9, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 11, 10, 11, 10, 11, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 11, 10, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 10, 11, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 6, 5, 4, 3, 2, 1};
		unsigned int framesIndicesNumberOfElements=sizeof(framesIndices)/sizeof(framesIndices[0]);
		
		// test frame indices, all must be between 1 and 11
		for (unsigned int i=0; i<framesIndicesNumberOfElements; i++) {
			if (framesIndices[i]<1 || framesIndices[i]>NUMBER_OF_FRAMES_PER_GIRL) {
				NSLog(@"Frame indices must be between 1 and 11.");
				exit(1);
			}
		}
		
		// load all sprite sheets and create animations
		m_differentGirlsActions=[[NSMutableArray alloc] init];
		m_spriteSheetTextures=[[NSMutableArray alloc] init];
		CCSpriteFrameCache* spriteFrameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
		
		for (unsigned int girl=0; girl<NUMBER_OF_GIRLS; girl++) {
		
			// if odd (1 texture/coordinate for 2 girls)
			if (girl%2==0) {
				
				// texture filename and path			
				NSString* name=[NSString stringWithFormat:@"girls_%02d_%02d", girl+1, girl+2];
				NSString* texturePathAndFilename = [[NSBundle mainBundle] pathForResource:name ofType: @"pvr"];
				
				// load texture	
				CCTexture2D* texture=[[CCTexture2D alloc] initWithPVRFile:texturePathAndFilename];
				[m_spriteSheetTextures addObject:texture];
				[texture release];
				
				// load sprite sheet coordinates file
				NSString* plistFilename=[NSString stringWithFormat:@"girls_%02d_%02d.plist", girl+1, girl+2];
				[spriteFrameCache addSpriteFramesWithFile:plistFilename texture:texture];
			}
	
			// add as many textures as frame indices we have
			CCAnimation* girlAnimation = [CCAnimation animationWithName:@"girl" delay:1/12.0f];
			for (unsigned int frameIndex=0; frameIndex<framesIndicesNumberOfElements; frameIndex++) {
				NSString* originalTextureFilename=[NSString stringWithFormat:@"girl_%02d_%04d.png", girl+1, framesIndices[frameIndex]];
				CCSpriteFrame* spriteFrame=[spriteFrameCache spriteFrameByName:originalTextureFilename];
				[girlAnimation addFrame:spriteFrame];
			}
			
			// create an animation/action and add it to action container
			CCAnimate* girlAction=[CCAnimate actionWithAnimation:girlAnimation];
			CCRepeatForever* repeatForever=[CCRepeatForever actionWithAction:girlAction];
			[m_differentGirlsActions addObject:repeatForever];
		}
		
		// girl sprite		
		CCSpriteFrame* spriteFrame=[spriteFrameCache spriteFrameByName:@"girl_01_0001.png"];
		m_girlSprite=[[CCSprite spriteWithSpriteFrame:spriteFrame] retain];
		[self addChild:m_girlSprite];
	}
	return self;
}

/*!
 Activate next girl modifiying m_currentGirlNumber. 0...NUMBER_OF_GIRLS-1,0,1,2...
 */
-(void) incrementGirl {	
	unsigned int newGirlNumber=(m_currentGirlNumber+1) % NUMBER_OF_GIRLS;
	[self setGirlNumber:newGirlNumber];
}

-(void) setGirlNumber:(unsigned int)girlNumber {
	NSAssert(girlNumber<NUMBER_OF_GIRLS, @"girlNumber too high.");
	m_currentGirlNumber=girlNumber;
	[m_girlSprite stopAllActions];
	[m_girlSprite runAction:[m_differentGirlsActions objectAtIndex:m_currentGirlNumber]];
	NSLog(@"setting girlNumber to: %d", m_currentGirlNumber);
}

-(void) onEnter {
	NSLog(@"background girl onEnter");
	[m_girlSprite stopAllActions];
	[m_girlSprite runAction:[m_differentGirlsActions objectAtIndex:m_currentGirlNumber]];
	[super onEnter];
}

-(void) onExit {
	NSLog(@"background girl onExit");
	[m_girlSprite stopAllActions];
	[super onExit];
}

-(void) dealloc {
	[m_spriteSheetTextures release];
	[m_differentGirlsActions release];
	[m_girlSprite release];
	[super dealloc];
}

@end
