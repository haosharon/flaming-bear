//
//  SettingsViewController.h
//  Power Hour
//
//  Created by Sharon Hao on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    UIButton *doneButton;
    UISwitch *soundSwitch;
    BOOL soundOff;
}

@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) UISwitch *soundSwitch;

- (IBAction)doneAction:(id)sender;
- (IBAction)email:(id)sender;

@end
