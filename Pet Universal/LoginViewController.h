//
//  ViewController.h
//  Pet Universal
//
//  Created by students@deti on 18/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UIKit;
@import FirebaseDatabase;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)LoginButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *InitButton;
- (IBAction)InitButtonClicked:(id)sender;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

