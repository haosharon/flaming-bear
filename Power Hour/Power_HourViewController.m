//
//  Power_HourViewController.m
//  Power Hour
//
//  Created by Sharon Hao on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Power_HourViewController.h"
#import "SettingsViewController.h"



const float FLASH_INTERVAL = .5;
const int FONT_SIZE = 80;

#if 1
const int TOTAL_DRINKS = 60;
const int TIME_INTERVAL = 60;
const int FLASH_REPEATS = 40;

#endif

#if 0
const int TOTAL_DRINKS = 2;
const int TIME_INTERVAL = 10;
const int FLASH_REPEATS = 10;

#endif
@implementation Power_HourViewController

@synthesize clock;
@synthesize drinkLabel;
@synthesize countLabel, doneLabel;
@synthesize totalDrinks, drinkCount, flashRepeats;
@synthesize drinkView, doneView, clockView;
@synthesize settingsButton, startButton, pauseButton;
@synthesize doneButton;
@synthesize fontName;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    hour = 0;
    minute = 0;
    second = 0;
    totalDrinks = TOTAL_DRINKS;
    
    fontName = [[NSString alloc] initWithString:@"Verdana-Bold"];
    clockBackground = [[UIColor alloc] initWithRed:.12549 green:.901961 blue:.00392 alpha:1.0];
    //clockText = [UIColor whiteColor];
    clockText = [[UIColor alloc] init];
    clockText = [UIColor whiteColor];
                 
    doneColor = [[UIColor alloc] initWithRed:51./255 green:102./255 blue:1 alpha:1.0];
    color1 = [[UIColor alloc] initWithRed:1 green:.42751 blue:.009322 alpha:1.0];
    color2 = [[UIColor alloc] initWithRed:.87451 green:.003922 blue:.54902 alpha:1.0];
    [self.view setBackgroundColor:clockBackground];
    
    paused = NO;
    
    clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    [clockView setBackgroundColor:clockBackground];
    
    clock = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 480, 200)];
    [clock setBackgroundColor:[UIColor clearColor]];
    [clock setTextColor:clockText];
    [clock setFont:[UIFont fontWithName:fontName size:FONT_SIZE]];
    [clock setTextAlignment:UITextAlignmentCenter];
    [clock setContentMode:UIViewContentModeCenter];
    [self displayTime];
    [clockView addSubview:clock];
    [self.view addSubview:clockView];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    [settingsButton.titleLabel setTextColor:clockText];
    [settingsButton.titleLabel setFont:[UIFont fontWithName:fontName size:18]];
    [settingsButton setFrame:CGRectMake(360, 0, 120, 40)];
    [settingsButton setBackgroundColor:[UIColor clearColor]];
    [settingsButton addTarget:self action:@selector(settings:) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setHidden:NO];
    [settingsButton setEnabled:YES];
    [self.view addSubview:settingsButton];
    
    doneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    [doneView setBackgroundColor:doneColor];
    
    doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 480, 90)];
    [doneLabel setText:@"DONE"];
    [doneLabel setFont:[UIFont fontWithName:fontName size:FONT_SIZE]];
    [doneLabel setTextAlignment:UITextAlignmentCenter];
    [doneLabel setTextColor:clockText];
    [doneLabel setBackgroundColor:[UIColor clearColor]];
    [doneView setHidden:YES];
    [doneView addSubview:doneLabel];
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(0, 0, 480, 320)];
    [doneButton setBackgroundColor:[UIColor clearColor]];
    [doneButton addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    
    [doneView addSubview:doneButton];
    
    [self.view addSubview:doneView];
    

    
    drinkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    [drinkView setBackgroundColor:color1];
    
    
    drinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 480, 90)];
    [drinkLabel setText:@"SHOTS!"];
    [drinkLabel setFont:[UIFont fontWithName:fontName size:FONT_SIZE]];
    [drinkLabel setTextAlignment:UITextAlignmentCenter];
    [drinkLabel setTextColor:clockText];
    [drinkLabel setBackgroundColor:[UIColor clearColor]];
    [drinkView setHidden:YES];
    [drinkView setUserInteractionEnabled:YES];
    [drinkView addSubview:drinkLabel];
    
    [self.view addSubview:drinkView];
    

    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, 40)];
    [countLabel setText:[NSString stringWithFormat:@"%d/%d", drinkCount, totalDrinks]]; 
    [countLabel setFont:[UIFont fontWithName:fontName size:18]];
    [countLabel setTextAlignment:UITextAlignmentCenter];
    [countLabel setTextColor:clockText];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:countLabel];
    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setBackgroundColor:[UIColor clearColor]];
    [startButton.titleLabel setFont:[UIFont fontWithName:fontName size:30]];
    [startButton.titleLabel setTextColor:clockText];
    [startButton setFrame:CGRectMake(140, 200, 200, 60)];
    [startButton setTitle:@"START!" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startClock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton setFrame:CGRectMake(0, 0, 90, 40)];
    [pauseButton.titleLabel setTextColor:clockText];
    [pauseButton setBackgroundColor:[UIColor clearColor]];
    [pauseButton.titleLabel setFont:[UIFont fontWithName:fontName size:20]];
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    [pauseButton setEnabled:NO];
    [pauseButton setHidden:YES];
    [self.view addSubview:pauseButton];
    
    [super viewDidLoad];
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/shots_clipo.mp3", [[NSBundle mainBundle] resourcePath]]];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	player.numberOfLoops = -1;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return !(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    soundOff = [prefs boolForKey:@"sound"];
    if (soundOff) {
        NSLog(@"sound is off");
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    flashRepeats = FLASH_REPEATS; //stops flashing
    flashing = NO;
    [player stop];
    player.currentTime = 0;
}

- (IBAction)tick:(id)sender {
    if (ticking) {
        second ++;
        if (second == 60) {
            second = 0;
            minute ++;
        }
        if (minute == 60) {
            minute = 0;
            hour += 1;
        }
        if (hour == 12) {
            hour = 0;
        }
    }

    [self displayTime];

    if (drinkCount < totalDrinks && ticking) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
        if (second % TIME_INTERVAL == 0 && minute >= 0) {
            //time to drink
            drinkCount ++;
            [countLabel setText:[NSString stringWithFormat:@"%d/%d", drinkCount, totalDrinks]];
            flashing = YES;
            [self drink:drinkCount];
        }
    }
    else if (drinkCount == totalDrinks){
        //done
        [doneView setHidden:NO];
        done = YES;
        [pauseButton setHidden:YES];
        
    }
    

    
}

- (void) displayTime {
    NSString *secString, *minString, *hString;
    if (second < 10) {
        secString = [[NSString alloc] initWithFormat:@"0%d", second];
    }
    else {
        secString = [[NSString alloc] initWithFormat:@"%d", second];
    }
    if (minute < 10) {
        minString = [[NSString alloc] initWithFormat:@"0%d", minute];
    }
    else {
        minString = [[NSString alloc] initWithFormat:@"%d", minute];
    }
    if (hour < 10) {
        hString = [[NSString alloc] initWithFormat:@"0%d", hour];
    }
    else {
        hString = [[NSString alloc] initWithFormat:@"%d", hour];
    }
    [clock setText:[NSString stringWithFormat:@"%@:%@:%@", hString, minString, secString]];
    [secString release];
    [minString release];
    [hString release];
}



- (void)drink:(int)drinkNumber {
    flashRepeats = 0;
    [drinkView setHidden:NO];
    [self flashScreen:nil];
    [self playMusic];
    
    
}

- (void) playMusic {
    if (!soundOff && flashing) {
        /*
        //NSString *path = [[NSString alloc] initWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/shots_clipo.mp3"];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"shots_clipo" ofType:@"mp3"];

        //NSString *path = [[NSString alloc] initWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/MOVE.WAV"];
        NSLog(@"path %@", path);
        NSURL *filepath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((CFURLRef)filepath, &soundID);

        AudioServicesPlaySystemSound(soundID);
        [NSTimer scheduledTimerWithTimeInterval:7.3 target:self selector:@selector(playMusic) userInfo:nil repeats:NO];
         */
        [player play];
    }
    


    

}

- (IBAction)flashScreen:(id)sender{

    if ([drinkView.backgroundColor isEqual:color1]) {
        [drinkView setBackgroundColor:color2];
        [drinkLabel setTextColor:[UIColor whiteColor]];
    }
    else {
        [drinkView setBackgroundColor:color1];
        [drinkLabel setTextColor:[UIColor whiteColor]];
    }
    flashRepeats ++;
    if (paused) {
        //don't do anything
    }
    else {
        if (flashRepeats < FLASH_REPEATS && flashing) {
            [NSTimer scheduledTimerWithTimeInterval:FLASH_INTERVAL target:self selector:@selector(flashScreen:) userInfo:nil repeats:NO];
            
        }
        else {
            [drinkView setHidden:YES];
            [player stop];
            player.currentTime = 0;
            flashing = NO;
            
        }
    }


    
    
}

- (IBAction)settings:(id)sender {
    SettingsViewController *targetViewController;
    NSString *viewControllerName = @"SettingsViewController";
    targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
    //viewController = targetViewController;
    //[self performSelector:@selector(animateTransition:) withObject:[NSNumber numberWithFloat: TIME_FOR_EXPANDING]];
    [self presentModalViewController:targetViewController animated:YES];
    
    [targetViewController release];
}


- (IBAction)startClock:(id)sender {
    [startButton setHidden:YES];
    [startButton setEnabled:NO];
    [pauseButton setHidden:NO];
    [pauseButton setEnabled:YES];
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    done = NO;
    ticking = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:NO];

}

- (IBAction)pause:(id)sender {
    ticking = NO;
    paused = YES;
    [player stop];
    UIAlertView *alertView;
   
    alertView = [[UIAlertView alloc] initWithTitle:@"Paused" message:nil delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:@"Reset", nil];

    

    [alertView show];
    [alertView release];

    }

- (IBAction)reset:(id)sender {
    [doneView setHidden:YES];
    ticking = NO;
    paused = YES;
    [player stop];
    [startButton setEnabled:YES];
    [startButton setHidden:NO];
    second = 0;
    minute = 0;
    hour = 0;
    drinkCount = 0;
    player.currentTime = 0;
    paused = NO;
    flashing = NO;
    [pauseButton setHidden:YES];
    NSLog(@"%d/%d", drinkCount, totalDrinks);
    [countLabel setText:[NSString stringWithFormat:@"%d/%d", drinkCount, totalDrinks]]; 
    
    [self displayTime];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        //reset
        /*
        [startButton setEnabled:YES];
        [startButton setHidden:NO];
        second = 0;
        minute = 0;
        hour = 0;
        drinkCount = 0;
        player.currentTime = 0;
        paused = NO;
        flashing = NO;
        
        NSLog(@"%d/%d", drinkCount, totalDrinks);
        [countLabel setText:[NSString stringWithFormat:@"%d/%d", drinkCount, totalDrinks]]; 
        
        [self displayTime];
         */
        [self reset:nil];
        
    }
    else {
        
        ticking = YES;
        paused = NO;
        [self tick:nil];
        if (flashing) {
            [self flashScreen:nil];
        }
    }

    
}

- (void)dealloc {
	[player release];
    [fontName release];
    [clock release];
    [drinkLabel release];
    [countLabel release];
    [doneLabel release];
    [drinkView release];
    [doneView release];
    [clockView release];
    [clockBackground release];
    [clockText release];
    [color1 release];
    [color2 release];
    [doneColor release];
    
    
	[super dealloc];
}


@end
