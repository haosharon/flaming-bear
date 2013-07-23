//
//  SettingsViewController.m
//  Power Hour
//
//  Created by Sharon Hao on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "Power_HourViewController.h"



@implementation SettingsViewController

@synthesize doneButton;
@synthesize soundSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    soundOff = [prefs boolForKey:@"sound"];
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(360, 0, 120, 40)];
    [doneButton.titleLabel setFont:[UIFont fontWithName:@"Verdana-Bold" size:18]];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    //[self.view addSubview:doneButton];
    [self.view setBackgroundColor:[UIColor colorWithRed:51./255 green:102./255 blue:1 alpha:1.0]];
    
    soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 35, 100, 40)];
    [soundSwitch setOn:!soundOff];
    
    /*
    UITextView *soundView = [[UITextView alloc] initWithFrame:CGRectMake(20, 40, 120, 80)];
    [soundView setText:@"Sound"];
    [soundView setTextAlignment:UITextAlignmentCenter];
    [soundView setFont:[UIFont systemFontOfSize:20]];
    [soundView setContentMode:UIViewContentModeTop];
    [soundView setBackgroundColor:[UIColor whiteColor]];
    [soundView.layer setBorderWidth:1.0];
    [soundView.layer setMasksToBounds:YES];
    [soundView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [soundView.layer setCornerRadius:8.0];
    [soundView addSubview:soundSwitch];
    //[self.view addSubview:soundView];
    [soundView release];
    */
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    /*
    [emailButton.layer setCornerRadius:8.0];
    [emailButton.layer setMasksToBounds:YES];
    [emailButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [emailButton.layer setBorderWidth:1.0];
    */
    
    [emailButton setBackgroundColor:[UIColor clearColor]];
    [emailButton addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
     
    [emailButton setFrame:CGRectMake(0, 0, 310, 80)];
    UITextView *emailLabel = [[UITextView alloc] initWithFrame:CGRectMake(150, 40, 310, 80)];
    
    [emailLabel.layer setCornerRadius:8.0];
    [emailLabel.layer setMasksToBounds:YES];
    [emailLabel.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [emailLabel.layer setBorderWidth:1.0];
    
    [emailLabel setBackgroundColor:[UIColor whiteColor]];
    [emailLabel setTextAlignment:UITextAlignmentCenter];
    [emailLabel setContentMode:UIViewContentModeCenter];
    [emailLabel setTextColor:[UIColor blackColor]];
    [emailLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [emailLabel setEditable:NO];
    [emailLabel setText:@"Questions, comments, or concerns? \n Send an email!"];
    [emailLabel addSubview:emailButton];
    //[self.view addSubview:emailLabel];
    [emailLabel release];
    
    
    //add textview with description
    NSString *description = [[NSString alloc] initWithString:@"We all know that as the hour wears on, time and numbers become increasingly fuzzy and seemingly unnecessary. This Power Hour app helps participants of a power hour keep track of the time and their shot number with a flashing screen and a peppy audio clip."];
    NSString *disclaimer = [[NSString alloc] initWithString:@"*Please drink responsibly. The creator of Power Hour is not responsible for any harm or damages inflicted on the user or surrounding participants."];
    UITextView *desc = [[UITextView alloc] initWithFrame:CGRectMake(20, 130, 440, 160)];
    [desc setText:[NSString stringWithFormat:@"%@\n\n%@", description, disclaimer]];
    [desc setContentMode:UIViewContentModeCenter];
    [desc.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [desc.layer setBorderWidth:1.0];
    [desc.layer setMasksToBounds:YES];
    [desc.layer setCornerRadius:8.0];
    [desc setBackgroundColor:[UIColor whiteColor]];
    [desc setFont:[UIFont systemFontOfSize:14]];
    //[self.view addSubview:desc];
    
    [description release];
    [disclaimer release];
    [desc release];
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)doneAction:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:!soundSwitch.on forKey:@"sound"];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        //do somtenhig
        
        MFMailComposeViewController *mComposer = [[MFMailComposeViewController alloc] init];
        [mComposer setMailComposeDelegate:self];
        [mComposer setToRecipients:[NSArray arrayWithObjects:@"hsharon@mit.edu", nil]];
        [mComposer setSubject:@"Questions, Comments, or concerns"];
        [mComposer setMessageBody:@"Dear Sharon: \nPlease read my email." isHTML:NO];
        
        [self presentModalViewController:mComposer animated:YES];
        
        [mComposer release];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
    if (result == MFMailComposeResultSent) {
        //sent
        NSLog(@"email sent");
        
    }
    else if (result == MFMailComposeResultCancelled) {
        //cancelled
        NSLog(@"email cancelled");
        
    }
    else if (result == MFMailComposeResultSaved) {
        //saved
        NSLog(@"email saved");
    }
    else {
        //error?
        NSLog(@"email error?");
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //power hour title
        return 40;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        //description
        return 47;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        //sound
        return 40;
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        return 40;
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        // feedback
        return 40;
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        // disclaimer
        return 40;
    }
    else {
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 2;
    }
    else {
        return 2;
    }
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
                [cell.textLabel setText:@"Power Hour 1.0"];
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                

            }
            
            else if (indexPath.row == 1) {
                UITextView *tmpLabel = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 470, 47)];
                [tmpLabel setText:@"As the hour wears on, time and numbers become increasingly fuzzy. This Power Hour app does the thinking for you!"];
                [tmpLabel setTextAlignment:UITextAlignmentCenter];
                [tmpLabel setEditable:NO];
                [tmpLabel setFont:[UIFont systemFontOfSize:14]];
                [tmpLabel setBackgroundColor:[UIColor clearColor]];
                //[cell.contentView addSubview:tmpLabel];
                [cell setAccessoryView:tmpLabel];
                //[cell addSubview:tmpLabel];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                [tmpLabel release];
            }/*
            else if (indexPath.row == 2) {
                [cell.textLabel setText:@""];
                UITextView *tmpLabel = [[UITextView alloc] initWithFrame:CGRectMake(7, 0, 468, 40)];
                [tmpLabel setText:@"*Please drink responsibly. The creator of Power Hour is not responsible for any harm or damages inflicted on the user or surrounding participants."];
                [tmpLabel setTextAlignment:UITextAlignmentCenter];
                [tmpLabel setFont:[UIFont systemFontOfSize:12]];
                [tmpLabel setEditable:NO];
                [tmpLabel setBackgroundColor:[UIColor clearColor]];
                //[cell.contentView addSubview:tmpLabel];
                [cell setAccessoryView:tmpLabel];
                //[cell addSubview:tmpLabel];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [tmpLabel release];

            }
            else {
                [cell.textLabel setText:@"Send feedback"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }*/
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Sound"];
                [cell setAccessoryView:soundSwitch];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            }
            else {
                [cell.textLabel setText:@"Save/ Back"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                //[cell.textLabel setTextAlignment:UITextAlignmentCenter];
            }
            
            break;
        }
        case 2:
        {
            /*
            if (indexPath.row == 0) {
                //instructions
                [cell.textLabel setText:@"Instructions"];
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            */
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Send feedback"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            /*
            else if (indexPath.row == 1) {
                [cell.textLabel setText:@""];

                UITextView *tmpView = [[UITextView alloc] initWithFrame:CGRectMake(7, 0, 468, 65)];
                [tmpView setText:@"Take a shot of beer in one minute intervals for one hour.\n To turn off flashing DRINK message, tap the screen."];
                [tmpView setTextAlignment:UITextAlignmentCenter];
                [tmpView setFont:[UIFont systemFontOfSize:14]];
                [tmpView setEditable:NO];
                [tmpView setBackgroundColor:[UIColor clearColor]];
                //[cell.contentView addSubview:tmpView];
                [cell setAccessoryView:tmpView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [tmpView release];
                
            }*/
            else if (indexPath.row == 1) {
                [cell.textLabel setText:@""];
                UITextView *tmpLabel = [[UITextView alloc] initWithFrame:CGRectMake(7, 0, 468, 40)];
                [tmpLabel setText:@"*Please drink responsibly. The creator of Power Hour is not responsible for any harm or damages inflicted on the user or surrounding participants."];
                [tmpLabel setTextAlignment:UITextAlignmentCenter];
                [tmpLabel setFont:[UIFont systemFontOfSize:12]];
                [tmpLabel setEditable:NO];
                [tmpLabel setBackgroundColor:[UIColor clearColor]];
                [tmpLabel setContentMode:UIViewContentModeCenter];
                //[cell.contentView addSubview:tmpLabel];
                [cell setAccessoryView:tmpLabel];
                //[cell addSubview:tmpLabel];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [tmpLabel release];
            }
            /*
            else {
                [cell.textLabel setText:@""];
                UITextView *tmpLabel = [[UITextView alloc] initWithFrame:CGRectMake(7, 0, 468, 65)];
                [tmpLabel setText:@"*Please drink responsibly. The creator of Power Hour is not responsible for any harm or damages inflicted on the user or surrounding participants."];
                [tmpLabel setTextAlignment:UITextAlignmentCenter];
                [tmpLabel setFont:[UIFont systemFontOfSize:14]];
                [tmpLabel setEditable:NO];
                [tmpLabel setBackgroundColor:[UIColor clearColor]];
                //[cell.contentView addSubview:tmpLabel];
                [cell setAccessoryView:tmpLabel];
                //[cell addSubview:tmpLabel];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [tmpLabel release];
            }
       */
            

         
            break;
        }
        default:
            break;
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        //save
        [self doneAction:nil];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        //send feedback
        [self email:nil];
    }
    else {
        NSLog(@"none");
    }
}






@end
