//
//  MainViewController.h
//  Pet Universal
//
//  Created by students@deti on 21/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk/System/Library/Frameworks/UserNotificationsUI.framework/Headers/UserNotificationsUI.h"

@import FirebaseDatabase;

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

- (IBAction)buttonMenuPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *sideview;

@property (weak, nonatomic) IBOutlet UIImageView *imageAnimal1;
@property (weak, nonatomic) IBOutlet UIImageView *imageAnimal2;
@property (weak, nonatomic) IBOutlet UIButton *buttonName1;
- (IBAction)button1Clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonName2;
@property (weak, nonatomic) IBOutlet UIButton *buttonDrug1;
@property (weak, nonatomic) IBOutlet UIButton *buttonDrug2;

- (IBAction)notificationValueChanged:(id)sender;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet NSString *tokenMain;
@property (weak, nonatomic) IBOutlet NSString *clinicIDMain;
@property (weak, nonatomic) IBOutlet NSString *userIDMain;
@end
