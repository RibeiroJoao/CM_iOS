//
//  ListClinicsViewController.h
//  Pet Universal
//
//  Created by students@deti on 21/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import UIKit;
@import FirebaseDatabase;
@interface ListClinicsViewController : UIViewController
    
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet NSString *tokenList;
@property (weak, nonatomic) IBOutlet NSString *userIDList;

@property (strong, nonatomic) FIRDatabaseReference *ref;
    
@end
