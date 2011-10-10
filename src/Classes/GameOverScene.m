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

#import "GameOverScene.h"
#import "SoundManager.h"
#import "MenuMainScene.h"
#import "Constants.h"
#import "LoadingGameScene.h"
#import "PlayingScene.h"
#import "Score.h"
#import "ObjectiveResource.h"
#import "ConnectionManager.h"
#import "LocalHighscoresModel.h"
#import "LocalScore.h"
#import "FacebookManager.h"
#import "RenameView.h"

@implementation GameOverScene

@synthesize m_playingScene;
@synthesize m_level;
@synthesize m_playedTooMuch;

#define DEFAULT_NAME @"(Press rename)"

// every dialog has a tag in order to identify it when delegate is called
#define CONFIRM_MENU_WO_SUBMITTING_DIALOG 1
#define CONFIRM_PLAY_AGAIN_WO_SUBMITTING_DIALOG 2
#define GAME_OVER_FINISHED_BY_FREE_VERSION_DIALOG 3
#define ASK_FOR_FEEDBACK_DIALOG 4
#define SCORE_SENT_SUCCESSFULLY_DIALOG 5
#define SCORE_SENDING_FAILED_DIALOG 6
#define SCORE_ALREADY_SENT_DIALOG 7
#define WRITING_ON_WALL_FAILED_DIALOG 8

-(id) init
{
	if( (self=[super init] )) {
		
		// background
		CCSprite *background=[CCSprite spriteWithFile:@"shared_pink_background.pvr"];
		background.position=ccp(240,160);
		[self addChild: background];
		
		// spot_lights sprite
		CCSprite* spot_lights_sprite=[CCSprite spriteWithFile:@"shared_spot_lights.png"];
		spot_lights_sprite.scale=2;
		spot_lights_sprite.position=ccp(400, 360);
		[spot_lights_sprite runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:BACKGROUND_ROTATION_TIME angle: -360]]];
		[self addChild: spot_lights_sprite];
		
		// game over label sprite
		CCSprite *gameOverLabel=[CCSprite spriteWithFile:@"game_over_label.png"];
		gameOverLabel.position=ccp(240,250);
		[self addChild: gameOverLabel];
		
		// game over text sprite
		CCSprite *gameOverText=[CCSprite spriteWithFile:@"menu_game_over_text.png"];
		gameOverText.position=ccp(145,145);
		[self addChild: gameOverText];
		
		// play again button
		CCMenuItem *playAgainItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_game_over_play_again_button_released.png"
			selectedImage:@"menu_game_over_play_again_button_pressed.png" 
			target:self 
			selector:@selector(playAgainButtonPressed:)
		];
        playAgainItem.position = ccp(62, 35);
        CCMenu *playAgainMenu = [CCMenu menuWithItems:playAgainItem, nil];
        playAgainMenu.position = CGPointZero;
        [self addChild:playAgainMenu];
		
		// rename button
		CCMenuItem *renameItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_game_over_rename_button_released.png"
			selectedImage:@"menu_game_over_rename_button_pressed.png" 
			target:self 
			selector:@selector(renameButtonPressed:)
		];
        renameItem.position = ccp(180, 35);
        CCMenu *renameMenu = [CCMenu menuWithItems:renameItem, nil];
        renameMenu.position = CGPointZero;
        [self addChild:renameMenu];
		
		// submit button
		CCMenuItem *submitItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_game_over_submit_button_released.png"
			selectedImage:@"menu_game_over_submit_button_pressed.png" 
			target:self 
			selector:@selector(submitButtonPressed:)
		];
        submitItem.position = ccp(298, 35);
        CCMenu *submitMenu = [CCMenu menuWithItems:submitItem, nil];
        submitMenu.position = CGPointZero;
        [self addChild:submitMenu];
		
		// main menu button
		CCMenuItem *menuItem = [CCMenuItemImage 
			itemFromNormalImage:@"menu_game_over_menu_button_released.png"
			selectedImage:@"menu_game_over_menu_button_pressed.png" 
			target:self 
			selector:@selector(menuButtonPressed:)
		];
        menuItem.position = ccp(417, 35);
        CCMenu *menuMenu = [CCMenu menuWithItems:menuItem, nil];
        menuMenu.position = CGPointZero;
        [self addChild:menuMenu];

		// local high score label
		m_high_score_label=[[UIntegerLabel alloc] init];
		LocalHighscoresModel* locaHighscoresModel=[[LocalHighscoresModel alloc] init];
		[m_high_score_label setUInteger:[locaHighscoresModel  getBestLocalHighscorePoints]];
		[locaHighscoresModel release];
		m_high_score_label.position=ccp(256,111);
		[self addChild: m_high_score_label];
		
		// name label
		m_name_label=[[StringLabel alloc] init];
		m_name_label.position=ccp(170,187);
		NSString* loadedString=[[NSUserDefaults standardUserDefaults] stringForKey:@"playerName"];
		if (loadedString!=nil && [loadedString length]>0) {
			[m_name_label setString:loadedString];
		} else {
			[m_name_label setString:DEFAULT_NAME];
		}
		[self addChild: m_name_label];
		
		// current score label
		m_current_score_label=[[UIntegerLabel alloc] init];
		[m_current_score_label setUInteger:0];
		m_current_score_label.position=ccp(217,149);
		[self addChild: m_current_score_label];
		
#ifdef FREE_VERSION
		CCMenuItem* buyFullVersionItem = [CCMenuItemImage 
										  itemFromNormalImage:@"buy_full_version_label.png" 
										  selectedImage:@"buy_full_version_label.png" 
										  target:self 
										  selector:@selector(buyFullVersionButtonPressed:)
										  ];
        buyFullVersionItem.position = ccp(480-56.5, 320-56.5);
        CCMenu* buyFullVersionMenu = [CCMenu menuWithItems:buyFullVersionItem, nil];
        buyFullVersionMenu.position = CGPointZero;
        [self addChild:buyFullVersionMenu];
#endif
		
		// login/logut butttons
		BOOL isConnected=[[FacebookManager sharedFacebookManager] isConnected];
		const int loginX=417, loginY=86;
		
		// login button
		CCMenuItem* loginItem = [CCMenuItemImage 
								 itemFromNormalImage:@"facebook_login_released.png"
								 selectedImage:@"facebook_login_pressed.png" 
								 target:self 
								 selector:@selector(loginButtonPressed:)
								 ];
		loginItem.position = ccp(loginX, loginY);
		m_loginMenu = [CCMenu menuWithItems:loginItem, nil];
		[m_loginMenu retain];
		m_loginMenu.position = CGPointZero;
		m_loginMenu.visible=!isConnected;
		[self addChild:m_loginMenu];
		
		// logout button
		CCMenuItem* logoutItem = [CCMenuItemImage 
								  itemFromNormalImage:@"facebook_logout_released.png"
								  selectedImage:@"facebook_logout_pressed.png" 
								  target:self 
								  selector:@selector(logoutButtonPressed:)
								  ];
		logoutItem.position = ccp(loginX, loginY);
		m_logoutMenu = [CCMenu menuWithItems:logoutItem, nil];
		[m_logoutMenu retain];
		m_logoutMenu.position = CGPointZero;
		m_logoutMenu.visible=isConnected;
		[self addChild:m_logoutMenu];
		
		// waiting view used when submitting a score
		CGRect rect=CGRectMake(0, 0, 480, 320);
		m_waitView=[[WaitView alloc] initWithFrame:rect];
		
		// init vars
		m_playingScene=nil;
		m_scoreWasSentProperly=NO;
		m_facebookWallWasWrittenProperly=NO;
		m_playedTooMuch=NO;
		
		// inif facebook manager
		[[FacebookManager sharedFacebookManager] setStatusDelegate:self];
		[[FacebookManager sharedFacebookManager] setSessionDelegate:self];
		
		// renameViewController
		m_renameViewController=[[RenameViewController alloc] init];
		m_renameViewController.m_renameViewControllerDelegate=self;
	}
	return self;
}

#ifdef FREE_VERSION
-(void) buyFullVersionButtonPressed:(id)sender {
	NSLog(@"buyFullVersion");
	NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=384946158&mt=8";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
#endif

-(void) setHighScore:(unsigned int)highScore {
	[m_high_score_label setUInteger:highScore];
}

-(void) setCurrentScore:(unsigned int)currentScore {
	[m_current_score_label setUInteger:currentScore];
}

-(void) onEnter
{
	NSLog(@"GameOverScene onEnter");
	[self buildFacebookMessageWithPoints:22 AndLevel:33];
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	NSLog(@"GameOverScene: transition did finish");
	
	// after 10 times the game was played, ask for feedback. note that this dialog 
	NSInteger gameWasStarted=[[NSUserDefaults standardUserDefaults] integerForKey:@"gameWasStarted"];	
	BOOL wasAskedForReview=[[NSUserDefaults standardUserDefaults] boolForKey:@"wasAskedForReview"];

	if (gameWasStarted>=10 && !wasAskedForReview) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Do you like Super Fashion Puzzle?" message:@"Please rate it in the AppStore and support us. Thanks." delegate:self cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Rate it!",nil];
		msg.tag=ASK_FOR_FEEDBACK_DIALOG;
		[msg show];
		[msg release];
		
	// gamefinished by free version
	} else if (m_playedTooMuch) {
		UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Free version is limited to 3 girls. Would you like to buy the full version with more girls and infinite levels?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		alert.tag= GAME_OVER_FINISHED_BY_FREE_VERSION_DIALOG;
		[alert show];
		[alert release];
	}
	
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	NSLog(@"GameOverScene onExit");
	
	// save score in local scores with current name if name is different 
	if ([[m_name_label getString] compare:DEFAULT_NAME]!=NSOrderedSame && [[m_name_label getString] length]>0) {
		NSLog(@"guardando en local");
		LocalScore* currentScore=[[[LocalScore alloc] init] autorelease];
		currentScore.m_name=[m_name_label getString];
		currentScore.m_points=[m_current_score_label getUInteger];
		currentScore.m_level=m_level;
		
		LocalHighscoresModel* localHighscoresModel=[[LocalHighscoresModel alloc] init];
		[localHighscoresModel saveScoreIfNecessary:currentScore];
		[localHighscoresModel release];
	}
	[super onExit];
}

-(void) submitButtonPressed:(id)sender {

	// prevent sending several times the same score
	if (m_scoreWasSentProperly) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your score was already sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		return;
	}
	
	// It's not a good idea to upload DEFAULT_NAME
	if ([[m_name_label getString] compare:DEFAULT_NAME]==NSOrderedSame || [[m_name_label getString] length]==0) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Perhaps you want to choose a more interesting name. Press 'Rename' button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		return;
	}
	
	// do not allow uploading 0 points
	if ([m_current_score_label getUInteger]==0) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"It doesn't seem very interesting uploading 0 points." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		return;
	}
	
	// score should be sent only once
	if (m_scoreWasSentProperly) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Score already sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		return;
	}

	// put a wating screen
	[[CCDirector sharedDirector] stopAnimation];
	[[[CCDirector sharedDirector] openGLView] addSubview:m_waitView];
	
	// upload score or write on wall
	if (m_facebookWallWasWrittenProperly) {
		// send score to my server
		[[ConnectionManager sharedInstance] runJob:@selector(tryToUploadScore) onTarget:self];
	} else {
		// write in facebook	
		NSString* message=[self buildFacebookMessageWithPoints:[m_current_score_label getUInteger] AndLevel:m_level];
		[[FacebookManager sharedFacebookManager] setStatus:message];	
	}
}
		
-(void) tryToUploadScore {
	// Extract current country name in countryNameInEnglish var
	NSLocale* currentLocale=[NSLocale currentLocale];
	NSString* countryCode=[currentLocale objectForKey:NSLocaleCountryCode];
	NSLocale* enLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	NSString* countryNameInEnglish=[enLocale displayNameForKey:NSLocaleCountryCode value:countryCode];
	
	// set up Objetive Resource 
	[ObjectiveResourceConfig setResponseType:XmlResponse];
	[ObjectiveResourceConfig setUser:@"***********"];  /***** REMOVED ******/
	[ObjectiveResourceConfig setPassword:@"***********"];  /***** REMOVED ******/
	
	// create object to serialize
	Score* score=[[[Score alloc] init] autorelease];
	score.name=[m_name_label getString];
	score.country=countryNameInEnglish;
	[score setPoints:[NSNumber numberWithUnsignedInt:[m_current_score_label getUInteger]]];
	[score setLevel:[NSNumber numberWithUnsignedInt:m_level]];
	
	// try to upload it	
	NSError* error=[[[NSError alloc] init] autorelease];
	BOOL success=[score createRemoteAtPath:@"https://www.superfashionpuzzle.com/scores.xml" withResponse:&error];
	
	// succcess or fail?
	if (success) {
		NSLog(@"Score sent successfully.");
		m_scoreWasSentProperly=YES;
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Your score has been uploaded sucessfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		msg.tag=SCORE_SENT_SUCCESSFULLY_DIALOG;
		[msg show];
		[msg release];
	} else {
		NSString* errorMsg;
		if (error.code==-1009) {
			errorMsg=[NSString stringWithFormat:@"Error uploading score. No Internet connection."]; 
		} else if (error.code==-1001) {
			errorMsg=[NSString stringWithFormat:@"Error uploading score. Timeout."];
		} else {
			errorMsg=[NSString stringWithFormat:@"Error uploading score. Error: %@", error.localizedDescription]; 
		}
		NSLog(@"%@", errorMsg);
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		msg.tag=SCORE_SENDING_FAILED_DIALOG;
		[msg show];
		[msg release];
	}
}

/*!
This method will be called after input string dialog. 
And if OK is pressed (instead of Cancel), what is inside "if" statement will be executed.
*/
-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (alertView.tag==CONFIRM_MENU_WO_SUBMITTING_DIALOG) {
		if (buttonIndex!=[alertView cancelButtonIndex]) {
			[self goToMainMenu];
		}
		
	} else if (alertView.tag==CONFIRM_PLAY_AGAIN_WO_SUBMITTING_DIALOG) {
		if (buttonIndex!=[alertView cancelButtonIndex]) {
			[self goToPlayAgain];
		}
	
	} else if (alertView.tag==GAME_OVER_FINISHED_BY_FREE_VERSION_DIALOG) {
		if (buttonIndex!=[alertView cancelButtonIndex]) {
			NSLog(@"buyFullVersion");
			NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=384946158&mt=8";
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
		}
		
	} else if (alertView.tag==ASK_FOR_FEEDBACK_DIALOG) {
		
		// save a flag to know if user watched (and replied) this message
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wasAskedForReview"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		if (buttonIndex!=[alertView cancelButtonIndex]) {
			// ask for feedback (full and free)
			NSLog(@"Asking for feedback.");
#ifdef FREE_VERSION
			NSString* sstring = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",@"384955775"];
#else
			NSString* sstring = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",@"384946158"];
#endif
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString:sstring]];
		}
	} else if (alertView.tag==SCORE_SENDING_FAILED_DIALOG || alertView.tag==SCORE_SENT_SUCCESSFULLY_DIALOG || alertView.tag==WRITING_ON_WALL_FAILED_DIALOG) {
		[m_waitView removeFromSuperview];
		[[CCDirector sharedDirector] startAnimation];
	}
}

-(void) renameButtonPressed:(id)sender {	
	NSLog(@"renameButtonPressed.");
	[[SoundManager sharedSoundManager] playSoundFxTap];	
	RenameView* renameView=(RenameView*)m_renameViewController.view;
	if ([[m_name_label getString] compare:DEFAULT_NAME]==NSOrderedSame) {
		renameView.m_renameTextField.text=@"";
	} else {
		renameView.m_renameTextField.text=[m_name_label getString];
	}
	[[[CCDirector sharedDirector] openGLView] addSubview:m_renameViewController.view];
}

-(void) textChanged:(NSString*)text {
	NSLog(@"textChanged %@", text);

	// no interesting name
	if ([text compare:DEFAULT_NAME]==NSOrderedSame || [text length]==0) {
		[m_name_label setString:DEFAULT_NAME];
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Perhaps you want to choose a more interesting name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		
	} else { // interesting name
		[m_name_label setString:text];
		[[NSUserDefaults standardUserDefaults] setObject:text forKey:@"playerName"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[m_renameViewController.view removeFromSuperview];
	}
}

-(void) playAgainButtonPressed:(id)sender {
	NSLog(@"playAgainButtonPressed");
	
	// no interesting name
	if ([[m_name_label getString] compare:DEFAULT_NAME]==NSOrderedSame || [[m_name_label getString] length]==0) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Perhaps you want to choose a more interesting name. Press 'Rename' button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		
	} else { // interesting name
		if (!m_scoreWasSentProperly && [m_current_score_label getUInteger]>0) {
			// continue withot uploading results?
			UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Would you like to continue without submitting your score to the Internet?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			alert.tag=CONFIRM_PLAY_AGAIN_WO_SUBMITTING_DIALOG;
			[alert show];
			[alert release];
		} else {
			[self goToPlayAgain];
		}
	}
}

-(void) goToPlayAgain {
	NSInteger gameWasStarted=[[NSUserDefaults standardUserDefaults] integerForKey:@"gameWasStarted"];
	gameWasStarted++;
	[[NSUserDefaults standardUserDefaults] setInteger:gameWasStarted forKey:@"gameWasStarted"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[m_playingScene reset];
	[[CCDirector sharedDirector] popScene];  // remove gameover scene and replace playing scene	
}

-(void) menuButtonPressed:(id)sender {
	NSLog(@"menuButtonPressed");
	
	// no interesting name
	if ([[m_name_label getString] compare:DEFAULT_NAME]==NSOrderedSame || [[m_name_label getString] length]==0) {
		UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Perhaps you want to choose a more interesting name. Press 'Rename' button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[msg show];
		[msg release];
		
	} else { // interesting name
		if (!m_scoreWasSentProperly && [m_current_score_label getUInteger]>0) {
			// continue withot uploading results?
			UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Would you like to continue without submitting your score to the Internet?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			alert.tag=CONFIRM_MENU_WO_SUBMITTING_DIALOG;
			[alert show];
			[alert release];
			
		} else {
			[self goToMainMenu];
		}
	}
}

-(void) goToMainMenu {
	[[SoundManager sharedSoundManager] playSoundFxTap];
	[[CCDirector sharedDirector] popScene];  // remove gameover scene and replace playing scene
	MenuMainScene* menuMainScene=[MenuMainScene node];
	[[SoundManager sharedSoundManager] playSoundMusicMenu];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:TRANSITION_DURATION scene:menuMainScene withColor:ccWHITE]];
}

/*!
There are 18 sentences, 6 for each level, 3 in English and 3 in Spanish. Take one of them randomly.
If Spanish is used in this iPhone, Spanish will be used, otherwise English will be used.
*/
-(NSString*) buildFacebookMessageWithPoints:(NSUInteger)points AndLevel:(NSUInteger)level {
	
	// is spanish used?
	NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
	BOOL isSpanishUsed=NO;
	if (language!=nil && [language isEqualToString:@"es"]) isSpanishUsed=YES;
	NSLog(@"isSpanishUsed: %@", isSpanishUsed?@"YES":@"NO");

	// random sentence
	NSUInteger r=arc4random()%3;
	if (level<MEDIUM_MODE_STARTS_IN_LEVEL) {
		if (r==0) {
			if (isSpanishUsed) {
				return [NSString stringWithFormat:@"Has conseguido %d puntos y alcanzado el nivel %d jugando al Super Fashion Puzzle para iPhone. ¡Esfuérzate un poco más! http://www.superfashionpuzzle.com", points, level];
			} else {
				return [NSString stringWithFormat:@"You’ve %d points and reached level %d playing Super Fashion Puzzle for the iPhone. Try a bit harder! http://www.superfashionpuzzle.com", points, level];
			}	
		} else if (r==1) {
			if (isSpanishUsed) {
				return [NSString stringWithFormat:@"Has conseguido %d puntos y alcanzado el nivel %d jugando al Super Fashion Puzzle para iPhone. ¡Más suerte la próxima vez! http://www.superfashionpuzzle.com", points, level];
			} else {
				return [NSString stringWithFormat:@"You’ve earned %d points and reached level %d playing Super Fashion Puzzle for the iPhone. Better luck next time! http://www.superfashionpuzzle.com", points, level];
			}	
		}
		// else, r==2
		if (isSpanishUsed) {
			return [NSString stringWithFormat:@"Bueno, sólo %d puntos y nivel %d. Seguro que la próxima vez consigues más jugando al Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
		} else {
			return [NSString stringWithFormat:@"Only %d points and just up till level %d? C’mon, sure you’ll do better next time you play Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
		}	
	} else if (level>=MEDIUM_MODE_STARTS_IN_LEVEL && level<HARD_MODE_STARTS_IN_LEVEL) {
		if (r==0) {
			if (isSpanishUsed) {
				return [NSString stringWithFormat:@"No está nada mal... conseguiste %d puntos y llegaste al nivel %d en el Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
			} else {
				return [NSString stringWithFormat:@"Not so bad... you gained %d points and got to level %d in Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
			}	
		} else if (r==1) {
			if (isSpanishUsed) {
				return [NSString stringWithFormat:@"¡Maravilloso! %d puntos y nivel %d en el Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
			} else {
				return [NSString stringWithFormat:@"Wonderful! %d points and level %d in Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
			}	
		}
		// else, r==2
		if (isSpanishUsed) {
			return [NSString stringWithFormat:@"¡Increíble! %d puntos y nivel %d jugando al Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
		} else {
			return [NSString stringWithFormat:@"Incredible! %d points and level %d playing Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
		}	
	} 
	// else, level>=HARD_MODE_STARTS_IN_LEVEL
	if (r==0) {
		if (isSpanishUsed) {
			return [NSString stringWithFormat:@"¡Fantástico! Conseguiste %d puntos jugando al Super Fashion Puzzle de iPhone, además de llegar al nivel %d ¿quieres probar este fantástico juego? http://www.superfashionpuzzle.com", points, level];
		} else {
			return [NSString stringWithFormat:@"Terrific! You got up to %d points playing Super Fashion Puzzle for the iPhone and rocketed to level %d! Try it out at http://www.superfashionpuzzle.com", points, level];
		}	
	} else if (r==1) {
		if (isSpanishUsed) {
			return [NSString stringWithFormat:@"¡No me lo puedo creer! Has conseguido %d puntos y llegado al nivel %d jugando en el Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
		} else {
			return [NSString stringWithFormat:@"Unbelievable! You’ve earned %d points and reached level %d playing Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
		}	
	}
	// else, r==2
	if (isSpanishUsed) {
		return [NSString stringWithFormat:@"¡Absolutamente impresionante! ¡Sigue así! Has conseguido %d puntos y nivel %d en Super Fashion Puzzle de iPhone. http://www.superfashionpuzzle.com", points, level];
	} else {
		return [NSString stringWithFormat:@"Way to go! Keep it up! You got %d impressive points and conquered level %d in Super Fashion Puzzle for the iPhone. http://www.superfashionpuzzle.com", points, level];
	}	
}

-(void) statusChanged {
	NSLog(@"statusChangedProperly. Trying to upload score.");
	m_facebookWallWasWrittenProperly=YES;
	[[ConnectionManager sharedInstance] runJob:@selector(tryToUploadScore) onTarget:self];
}

-(void) statusChangedDidFail:(NSString*)errorMessage {
	NSLog(@"statusChangedDidFail: %@", errorMessage);
	NSString* error=[NSString stringWithFormat:@"Error writing on your Facebook wall. Your score cannot be uploaded. Error: %@", errorMessage];
	UIAlertView* msg=[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	msg.tag=WRITING_ON_WALL_FAILED_DIALOG;
	[msg show];
	[msg release];
}

-(void) sessionDidLogin {
	NSLog(@"sessionDidLogin");
	m_loginMenu.visible=NO;
	m_logoutMenu.visible=YES;
}

-(void) sessionDidNotLogin:(NSString*)errorMessage {
	NSLog(@"sessionDidNotLogin");
	// dialogo aqui
}

-(void) sessionDidLogout {
	NSLog(@"sessionDidLogout");
	m_loginMenu.visible=YES;
	m_logoutMenu.visible=NO;
}

-(void) loginButtonPressed:(id)sender {
	[[FacebookManager sharedFacebookManager] login];
}

-(void) logoutButtonPressed:(id)sender {
	[[FacebookManager sharedFacebookManager] logout];	
}

- (void) dealloc
{	
	NSLog(@"deallocating GameOverScene.");
	[[FacebookManager sharedFacebookManager] setStatusDelegate:nil];
	[[FacebookManager sharedFacebookManager] setSessionDelegate:nil];
	[m_loginMenu release];
	[m_logoutMenu release];
	[m_waitView release];
	[m_name_label release];
	[m_current_score_label release];
	[m_high_score_label release];
	[m_renameViewController release];
	[super dealloc];
}
@end
