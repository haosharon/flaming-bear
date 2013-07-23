//
//  Power_HourViewController.h
//  Power Hour
//
//  Created by Sharon Hao on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Power_HourViewController : UIViewController {
    NSString *fontName;
    int hour, minute, second;
    UILabel *clock, *drinkLabel, *countLabel, *doneLabel;
    UIView *drinkView, *doneView, *clockView;
    int totalDrinks, drinkCount, flashRepeats;
    UIColor *clockBackground, *clockText, *color1, *color2, *doneColor;
    UIButton *settingsButton, *doneButton;
    UIButton *startButton, *pauseButton;
    BOOL flashing, ticking, paused, done, soundOff;
    
    AVAudioPlayer *player;

}

@property (nonatomic, retain) IBOutlet UILabel *clock;
@property (nonatomic, retain) IBOutlet UILabel *drinkLabel;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UILabel *doneLabel;
@property (nonatomic, retain) IBOutlet UIView *drinkView;
@property (nonatomic, retain) IBOutlet UIView *doneView, *clockView;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UIButton *startButton, *pauseButton, *doneButton;
@property (nonatomic, retain) NSString *fontName;
@property int totalDrinks;
@property int drinkCount;
@property int flashRepeats;

- (IBAction)tick:(id)sender;
- (void) displayTime;
- (void)drink:(int)drinkNumber;
- (IBAction)flashScreen:(id)sender;
- (IBAction)startClock:(id)sender;
- (IBAction)settings:(id)sender;
- (void) playMusic;
- (IBAction)pause:(id)sender;
- (IBAction)reset:(id)sender;

@end
