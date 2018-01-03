//
//  ViewController.m
//  Pet Universal
//
//  Created by students@deti on 18/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import "LoginViewController.h"
#import "ListClinicsViewController.h"

@interface ViewController ()

@end

@implementation ViewController
    
NSString* email;
NSString* pass;
NSString* token;
NSString* userID;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.password.secureTextEntry = YES;
    //[FIRDatabase database].persistenceEnabled = YES;
}
//@"peixe@vet.com" @"a"

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Delegate textViews to ViewController to hide keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//Post To Firebase
/*self.ref = [[FIRDatabase database] reference];
 [[[_ref child:@"users"] child:@"user1name"] setValue:email];
 self.ref = [[FIRDatabase database] reference];
 [[[_ref child:@"users"] child:@"user1pass"] setValue:pass];*/

//Apagar?
- (IBAction)LoginButtonClicked:(id)sender {
    //Just for Segue
}
- (NSString *)tryPetLogin: (NSString *)e :(NSString *)p {
    NSString *apisuccess;
    __block NSInteger success = 1;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/tokens?grant_type=password&username=%@&password=%@",e,p]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];

    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API LOGIN");
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            NSLog(@"SUCCESS API LOGIN %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"access_token"]){
                    token = [jsonData objectForKey:key];
                }else if ([key  containsString:@"user_id"]){
                    userID = [jsonData objectForKey:key];
                }
            }
            apisuccess = @"TRUE";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:[NSString stringWithFormat: @"Login Success API with %@", email]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            int duration = 1; // duration in seconds
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:^{
                    [self performSegueWithIdentifier:@"LoginSegueList" sender:nil];
                }];
            });
        }
        else {
            NSLog(@"UNSUCCESS API LOGIN %@", jsonData);
            apisuccess = @"FALSE";
            token=nil;
            userID=nil;
            /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message: @"Login Incorrect!!!"preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            int duration = 1; // duration in seconds
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });*/
        }
    }
    else {
        NSLog(@"ERROR MAIN %@ %@ %@", @"Cant connect to API", urlData,  response1);
        apisuccess = @"FALSE";
    }
    return apisuccess;
}

- (IBAction)InitButtonClicked:(id)sender {
    email= self.username.text;
    pass= self.password.text;
    
    NSString *successAPI;
    //get from Pet
    successAPI = [self tryPetLogin: email :pass];
    if ([successAPI isEqual:@"TRUE"]){
        NSLog(@"Success API RESPONSE, Broadcasting Token");
        //PARA EMISSOR
        //[[NSNotificationCenter defaultCenter] postNotificationName: @"NOTIFICATION_TOKEN" object: token]; //+Emitir UserID
        
        //[self performSegueWithIdentifier:@"LoginSegueList" sender:nil];
    }else{
        //TODO Firebase
        NSLog(@"UnSuccess API RESPONSE, starting FIREBASE");
        token=nil;
        userID=nil;
        __block NSString * emailFIR;
        __block NSString * passFIR;
        
        
        FIRDatabaseReference *scoresRef = [[FIRDatabase database] referenceWithPath:@"scores"];
        [scoresRef keepSynced:YES];
        
        NSLog(@"               *****FIREBASE LOGIN AQUI 0");
        FIRDatabaseReference *rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/users",@"https://pet-universal-app-id.firebaseio.com/"]];
        [rootRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
         {
             if (snapshot.exists)
             {
                 for ( FIRDataSnapshot *child in snapshot.children) {
                     if ([child.key containsString:@"user1name"]){
                         emailFIR = child.value;
                     }
                     else if ([child.key containsString:@"user1pass"]){
                         passFIR = child.value;
                     }
                 }
             }
             NSLog(@"               *****FIREBASE LOGIN AQUI 1 %@ %@ - %@ %@", email, emailFIR, pass, passFIR);
             if ([email isEqual:emailFIR] && [pass isEqual:passFIR]){
                 NSLog(@"               *****FIREBASE LOGIN AQUI 2.1");
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                message:[NSString stringWithFormat: @"Login Success Firebase with %@", email]
                                                                         preferredStyle:UIAlertControllerStyleAlert];
                 [self presentViewController:alert animated:YES completion:nil];
                 int duration = 1; // duration in seconds
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                     [alert dismissViewControllerAnimated:YES completion:^{
                         [self performSegueWithIdentifier:@"LoginSegueList" sender:nil];
                     }];
                 });
             }else{
                 NSLog(@"               *****FIREBASE LOGIN AQUI 2.2");
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                message: @"Login Incorrect!!!"preferredStyle:UIAlertControllerStyleAlert];
                 [self presentViewController:alert animated:YES completion:nil];
                 int duration = 1; // duration in seconds
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                     [alert dismissViewControllerAnimated:YES completion:nil];
                 });
             }
             //[self performSegueWithIdentifier:@"LoginSegueList" sender:nil];
         }];
    }
    NSLog(@"               *****FIREBASE LOGIN AQUI 3");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"LoginSegueList"]){
        ListClinicsViewController *lVC = (ListClinicsViewController *)segue.destinationViewController;
        lVC.tokenList = token;
        lVC.userIDList = userID;
    }
}

@end


//PARA EMISSOR
//[[NSNotificationCenter defaultCenter] postNotificationName: @"NOTIFICATION_TOKEN" object: token];
//NSLog(@"NOTIFICATION FOR TOKEN %@",@" DO IT !");

//PARA RECEPTOR
/*
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"NOTIFICATION_TOKEN" object:nil];
 
 - (void) incomingNotification:(NSNotification *)notification{
 NSString *theString = [notification object];
 if ([[notification name] isEqualToString:@"NOTIFICATION_TOKEN"]){
 NSLog(@"NOTIFICATION IN LIST %@",theString);
 }
 }
 */
