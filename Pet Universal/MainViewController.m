//
//  MainViewController.m
//  Pet Universal
//
//  Created by students@deti on 21/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import "MainViewController.h"
#import "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk/System/Library/Frameworks/UserNotificationsUI.framework/Headers/UserNotificationsUI.h"
#import "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS10.2.sdk/System/Library/Frameworks/NotificationCenter.framework/Headers/NotificationCenter.h"
#import "AnimalViewController.h"
#import "ListClinicsViewController.h"

@interface MainViewController (){
    BOOL isSideViewOpen;
    NSUserDefaults *defaults; //this will keep track as to whether the notification is on or off
}
@end

@implementation MainViewController
@synthesize sideview;

NSArray *animalNameData;
NSArray *drugNameData;

NSString *hoursString;
NSString *thisTokenMain;
NSString *thisClinicIDMain;

UIButton *animalButton1;
UIButton *animalButton2;
UIButton *animalButton3;

UIButton *drugButton1;
UIButton *drugButton2;
UIButton *drugButton3;


NSMutableArray *fAnimalNames;
NSMutableArray *fAnimalImageURLs;
NSMutableArray *fAnimalTask;
NSMutableArray *fAnimalTaskColor;

NSMutableArray *apiAnimalNames;
NSMutableDictionary *apiAnimalInternIDandNames;
NSMutableArray *apiDrugNames;
NSMutableDictionary *apiAnimalInternIDandDrug;
NSMutableArray *clinicAnimalIDs;
NSString *personID;

bool notificationState;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    notificationState = FALSE;
    //This initializes the UIUserNotifcations
    /*defaults = [NSUserDefaults standardUserDefaults];
    UIUserNotificationType types = UIUserNotificationTypeBadge| UIUserNotificationTypeSound| UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];*/
    
    sideview.hidden=YES;
    isSideViewOpen = false;
    
    apiAnimalInternIDandNames = [[NSMutableDictionary alloc] init];
    apiAnimalInternIDandDrug = [[NSMutableDictionary alloc] init];
    clinicAnimalIDs = [NSMutableArray new];
    
    fAnimalNames = [NSMutableArray new];
    fAnimalImageURLs = [NSMutableArray new];
    fAnimalTask = [NSMutableArray new];
    fAnimalTaskColor = [NSMutableArray new];
    
    if(_tokenMain != NULL){
        NSLog(@"API AT MAIN");
        thisTokenMain = _tokenMain;
        thisClinicIDMain = _clinicIDMain;
        
        NSLog(@"TOKEN AT MAIN = %@",thisTokenMain);
        NSLog(@"ClinicID AT MAIN = %@",thisClinicIDMain);
        
        //TODO Check button color
        
        [self getPetAnimals];
        [self getPetDrugs];
    }else{
        //try with Firebase
        NSLog(@"FIREBASE AT MAIN");
        FIRDatabaseReference *rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/animals",@"https://pet-universal-app-id.firebaseio.com/"]];
        [rootRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
         {
             if (snapshot.exists)
             {
                 for ( FIRDataSnapshot *child in snapshot.children) {
                     if ([child.key containsString:@"nome"]){
                         [fAnimalNames addObject:child.value];
                     }
                     else if ([child.key containsString:@"image"]){
                         [fAnimalImageURLs addObject:child.value];
                     }
                     else if ([child.key containsString:@"cor"]){
                         [fAnimalTaskColor addObject:child.value];
                     }
                     else if ([child.key containsString:@"tarefa"]){
                         [fAnimalTask addObject:child.value];
                     }
                 }
                 
                 NSURL *url1 = [NSURL URLWithString:[fAnimalImageURLs objectAtIndex:0]];
                 NSData *data1 = [NSData dataWithContentsOfURL:url1];
                 UIImage* image1 = [[UIImage alloc] initWithData:data1];
                 [self.imageAnimal1 setImage:image1];
                 
                 NSURL *url2 = [NSURL URLWithString:[fAnimalImageURLs objectAtIndex:1]];
                 NSData *data2 = [NSData dataWithContentsOfURL:url2];
                 UIImage* image2 = [[UIImage alloc] initWithData:data2];
                 [self.imageAnimal2 setImage:image2];
                 
                 [self.buttonName1 setTitle:[fAnimalNames objectAtIndex:0] forState:UIControlStateNormal];
                 [self.buttonName2 setTitle:[fAnimalNames objectAtIndex:1] forState:UIControlStateNormal];
                 [self.buttonDrug1 setTitle:[fAnimalTask objectAtIndex:0] forState:UIControlStateNormal];
                 if ([[fAnimalTaskColor objectAtIndex:0] isEqualToString:@"colorPet"]){
                     [self.buttonDrug1 setBackgroundColor:[UIColor greenColor]];
                 }
                 [self.buttonDrug2 setTitle:[fAnimalTask objectAtIndex:1] forState:UIControlStateNormal];
                 if ([[fAnimalTaskColor objectAtIndex:1] isEqualToString:@"colorPet"]){
                     //[self.buttonDrug2 setBackgroundColor:[UIColor colorWithRed:0.53 green:1.51 blue:1.42 alpha:1.0]];
                     [self.buttonDrug2 setBackgroundColor:[UIColor greenColor]];
                 }
                 
                 NSLog(@"FIRE MAIN= %@ %@ %@",fAnimalNames, fAnimalTask ,fAnimalImageURLs);
             }
         }];
    }
    
    
    animalNameData = [NSArray arrayWithObjects:@"Animal 1", @"Animal 2",@"Animal 3", nil];
    drugNameData = [NSArray arrayWithObjects:@"Droga 1", @"Droga 2",@"Droga 3", nil];
    hoursString = [self curentDateStringFromDate:[NSDate date] withFormat:@"HH"];
    
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    [self.buttonDrug1 addGestureRecognizer:tapOnce];
    [self.buttonDrug1 addGestureRecognizer:tapTwice];
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    UITapGestureRecognizer *tapOnce2 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce2:)];
    UITapGestureRecognizer *tapTwice2 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice2:)];
    tapOnce2.numberOfTapsRequired = 1;
    tapTwice2.numberOfTapsRequired = 2;
    [self.buttonDrug2 addGestureRecognizer:tapOnce2];
    [self.buttonDrug2 addGestureRecognizer:tapTwice2];
    //stops tapOnce from overriding tapTwice
    [tapOnce2 requireGestureRecognizerToFail:tapTwice2];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle;
    if ([tableView isEqual:_mainTableView]) {
        sectionTitle = [@"Animal                                               " stringByAppendingString:hoursString];
        sectionTitle = [sectionTitle stringByAppendingString:@"h"];
    }

    return sectionTitle;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_mainTableView]) {
        return [animalNameData count];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"myTableItem";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        //cell.textLabel.text = [animalNameData objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"dogIcon.png"];
        
        UIButton *buttonName = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the position of the button (floatX, floatY, Weight, Height)
        buttonName.frame = CGRectMake(cell.frame.origin.x + 44, cell.frame.origin.y, 135, 44);
        [buttonName setTitle:[animalNameData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        //[buttonName addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
        //buttonName.backgroundColor= [UIColor colorWithDisplayP3Red:255 green:127 blue:80 alpha:0];
        [cell.contentView addSubview:buttonName];
        
        UIButton *buttonDrug = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //set the position of the button (floatX, floatY, Weight, Height)
        buttonDrug.frame = CGRectMake(cell.frame.origin.x + 185, cell.frame.origin.y, 135, 44);
        [buttonDrug setTitle:[drugNameData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        //[buttonDrug addTarget:self action:@selector(customActionPressed:) forControlEvents:UIControlEventTouchUpInside];
        //buttonDrug.backgroundColor= [UIColor colorWithDisplayP3Red:255 green:127 blue:80 alpha:0];
        [cell.contentView addSubview:buttonDrug];
    }
    
    return cell;
}

- (NSString *)curentDateStringFromDate:(NSDate *)dateTimeInLine withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSString *convertedString = [formatter stringFromDate:dateTimeInLine];
    return convertedString;
}

- (IBAction)buttonMenuPressed:(id)sender {
    sideview.hidden=NO;
    //sidebar.hidden=NO;
    [self.view bringSubviewToFront:sideview]; //UIView passa a principal
    if(!isSideViewOpen){
        isSideViewOpen=true;
        [UIView beginAnimations:@"TableAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView commitAnimations];
    }else{
        isSideViewOpen=false;
        sideview.hidden=YES;
        //sidebar.hidden=YES;
        [UIView beginAnimations:@"TableAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView commitAnimations];
    }
}
- (void)tapOnce:(UIGestureRecognizer *)gesture{NSLog(@"%@", @"Tocou 1 vez");}
- (void)tapOnce2:(UIGestureRecognizer *)gesture{NSLog(@"%@", @"Tapped Once");}

- (void)tapTwice:(UIGestureRecognizer *)gesture{
    //[self checkMySender:gesture.view];
    //NSLog(@"GESTURE1 %@",gesture.view);
    UIButton *mButton = (UIButton *) gesture.view;
    if (mButton == _buttonDrug1){
        if (thisTokenMain == nil){
            self.ref = [[FIRDatabase database] reference];
            [[[_ref child:@"animals"] child:@"corTarefaAnimal1"] setValue:@"colorPet"];
            mButton.backgroundColor = [UIColor greenColor];
        }else{
            NSLog(@"GESTURE MAIN API B1");
            [self getClinicPerson];
            NSString *actionWasSuccessful = [self doAction];
            if ([actionWasSuccessful  isEqual: @"TRUE"]){
                mButton.backgroundColor = [UIColor greenColor];
            }else{
                mButton.backgroundColor = [UIColor redColor];
            }
        }
    }else
        NSLog(@"MAJOR ERROR 1 AT GESTURE MAIN");
}
- (void)tapTwice2:(UIGestureRecognizer *)gesture{
    //[self checkMySender:gesture.view];
    //NSLog(@"GESTURE2 %@",gesture.view);
    UIButton *mButton = (UIButton *) gesture.view;
    if (mButton == _buttonDrug2){
        if (thisTokenMain == nil){
            self.ref = [[FIRDatabase database] reference];
            [[[_ref child:@"animals"] child:@"corTarefaAnimal2"] setValue:@"colorPet"];
            mButton.backgroundColor = [UIColor greenColor];
        }else{
            NSLog(@"GESTURE MAIN API B2");
            if(personID == nil)
                [self getClinicPerson];
            NSString *actionWasSuccessful = [self doAction2];
            if ([actionWasSuccessful  isEqual: @"TRUE"]){
                mButton.backgroundColor = [UIColor greenColor];
            }else{
                mButton.backgroundColor = [UIColor redColor];
            }
        }
    }else
        NSLog(@"MAJOR ERROR 2 AT GESTURE MAIN");
}


- (void)getClinicPerson{
    NSLog(@"PERSOOOOONNNN   ======= %@", _userIDMain);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/users/%@",_userIDMain]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    NSString *person;
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API MAIN ClinicPerson");
        NSInteger success = 1;
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            NSLog(@"SUCCESS API MAIN Person %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"person"]){
                    person = [jsonData objectForKey:key];
                }
            }
        }
        else {
            NSLog(@"UNSUCCESS API person MAIN %@", jsonData);
        }
        NSLog(@"Clinic Person API MAIN= %@",person);
        [self getPersonID: person];
    } else {
        NSLog(@"ERROR MAIN %@ %@ %@", @"Cant get clinicPerson from API", urlData,  response1);
    }
}
- (void)getPersonID: (NSString*) person {
    NSLog(@"/clinicPeople?clinic=%@&person=%@", thisClinicIDMain,person);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/clinicPeople?clinic=%@&person=%@", thisClinicIDMain,person]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API MAIN ClinicPerson");
        NSError *serializeError = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:kNilOptions
                                                          error:&serializeError];
        
        personID = json[0][@"id"];
        
        NSLog(@"PersonID API MAIN= %@",personID);
    } else {
        NSLog(@"ERROR MAIN %@ %@ %@", @"Cant get PersonID from API", urlData,  response1);
    }
}

- (NSString *)doAction{
    NSString *actionSucceded;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/actions"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //GET DATE
    NSString *tmpDate=[self curentDateStringFromDate:[NSDate date] withFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSMutableString *date = [NSMutableString stringWithString:tmpDate];
    [date insertString:@"T" atIndex:10];
    
    //DRUG Dopamina #1=224487  Glucose 5=224495
    NSDictionary *rawContent = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"1", @"status",
                                date, @"started",
                                @"224487", @"drug",
                                personID, @"doer",
                         nil];
    NSLog(@"   Action Content 1!!! %@",rawContent);
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:rawContent options:0 error:&error];
    [request setHTTPBody:postdata];
    //NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&error];
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        NSLog(@"Connected to API ACTION MAIN");
        NSInteger success = 1;
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            NSLog(@"SUCCESS API ACTION MAIN %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"started"]){
                    NSLog(@"succeded in posting action 1");
                    actionSucceded = @"TRUE";
                }
            }
        }
        else {
            NSLog(@"UNSUCCESS API ACTION MAIN %@", jsonData);
            actionSucceded = @"FALSE";
        }
    }
    else {
        NSLog(@"ERROR MAIN %@ %@ %@", @"Cant connect to ACTION API", urlData,  response1);
        actionSucceded = @"FALSE";
    }
    return actionSucceded;
}

- (NSString *)doAction2{
    NSString *actionSucceded;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/actions"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //GET DATE
    NSString *tmpDate=[self curentDateStringFromDate:[NSDate date] withFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSMutableString *date = [NSMutableString stringWithString:tmpDate];
    [date insertString:@"T" atIndex:10];
    
    //DRUG  Glucose 5 #1=224495
    NSDictionary *rawContent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"1", @"status",
                                date, @"started",
                                @"224495", @"drug",
                                personID, @"doer",
                                nil];
    NSLog(@"  Action Content %@",rawContent);
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:rawContent options:0 error:&error];
    [request setHTTPBody:postdata];
    
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&error];
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        NSLog(@"Connected to API ACTION 2 MAIN");
        NSInteger success = 1;
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            NSLog(@"SUCCESS API ACTION 2 MAIN %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"started"]){
                    NSLog(@"succeded in posting action 2");
                    actionSucceded = @"TRUE";
                }
            }
        }
        else {
            NSLog(@"UNSUCCESS API ACTION 2 MAIN %@", jsonData);
            actionSucceded = @"FALSE";
        }
    }
    else {
        NSLog(@"ERROR MAIN %@ %@ %@", @"Cant connect to ACTION 2 API", urlData,  response1);
        actionSucceded = @"FALSE";
    }
    return actionSucceded;
}

- (IBAction)notificationValueChanged:(id)sender {
    if (!notificationState) {
        notificationState = TRUE;
        NSLog(@"NOTICATIONS MAIN %@",@"ON!");
        [defaults setBool:YES forKey:@"notificationIsActive"];
        [defaults synchronize];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0]; //Enter the time for delay here in seconds.
        localNotification.alertBody= @"Please check your pet's tasks";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.repeatInterval= NSCalendarUnitMinute;// Repeat every hour
        localNotification.soundName= UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }else{
        notificationState = FALSE;
        NSLog(@"NOTICATIONS MAIN %@",@"OFF!");
        [defaults setBool:NO forKey:@"notificationIsActive"];
        [defaults synchronize];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
}
- (void) getPetAnimals {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/internments?clinic=%@&open=true",thisClinicIDMain]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API MAIN ANIMALS");
        NSError *serializeError = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:kNilOptions
                                                          error:&serializeError];

        for (int i=0; i<json.count; i++){
            NSUInteger start=[json[i][@"name"] rangeOfString: @"-"].location+2;
            NSUInteger end= (NSUInteger)[json[i][@"name"] rangeOfString: @"["].location;
            NSString *shortName=[json[i][@"name"] substringWithRange: NSMakeRange(start, end-start)];
            apiAnimalInternIDandNames [json[i][@"id"]]= shortName;
            
            //TODO
            //NSData* imageData = [json[0][@"image"] dataUsingEncoding:NSUTF8StringEncoding];
            //self.imgage.image= [UIImage imageWithData:imageData];
            [clinicAnimalIDs addObject: json[i][@"clinicAnimal"]];
        }
        
        NSLog(@"ANIMAL CLINICnames API MAIN= %@",clinicAnimalIDs);
        NSLog(@"ANIMAL Intern + NAMEs API MAIN= %@",apiAnimalInternIDandNames);
        //Não sei fazer dinamico
        [self.buttonName1 setTitle:[[apiAnimalInternIDandNames allValues] objectAtIndex:0] forState:UIControlStateNormal];
        [self.buttonName2 setTitle:[[apiAnimalInternIDandNames allValues] objectAtIndex:1] forState:UIControlStateNormal];
    }
    else {
        NSLog(@"ERROR 1 MAIN %@ %@ %@", @"Cant connect to API", urlData,  response1);
    }
}

- (void) getPetDrugs {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/drugs?clinic=%@",thisClinicIDMain]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",thisTokenMain] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API MAIN DRUGS");
        NSError *serializeError = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:kNilOptions
                                                          error:&serializeError];
        
        for (int i=0; i<json.count; i++){
            apiAnimalInternIDandDrug [json[i][@"internment"]]= json[i][@"name"] ;
            //TODO
            //NSData* imageData = [json[0][@"image"] dataUsingEncoding:NSUTF8StringEncoding];
            //self.imgage.image= [UIImage imageWithData:imageData];
        }
        
        NSLog(@"ANIMAL Intern + DRUGs API MAIN= %@",apiAnimalInternIDandDrug);
        //Não sei fazer dinamico
        [self.buttonDrug1 setTitle:[[apiAnimalInternIDandDrug allValues] objectAtIndex:0] forState:UIControlStateNormal];
        [self.buttonDrug2 setTitle:[[apiAnimalInternIDandDrug allValues] objectAtIndex:1] forState:UIControlStateNormal];
    }
    else {
        NSLog(@"ERROR 2 LIST %@ %@ %@", @"Cant connect to API", urlData,  response1);
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MainSegueAnimal"]){
        AnimalViewController *aVC = (AnimalViewController *)segue.destinationViewController;
        aVC.localAnimalID = @"0";
        if (clinicAnimalIDs.count > 0){
            aVC.apiClinicAnimalID = [clinicAnimalIDs objectAtIndex:0];
            aVC.apiTokenAnimal = thisTokenMain;
        }
    }else if([segue.identifier isEqualToString:@"MainSegueAnimal2"]){
        AnimalViewController *aVC = (AnimalViewController *)segue.destinationViewController;
        aVC.localAnimalID = @"1";
        if (clinicAnimalIDs.count > 0){
            aVC.apiClinicAnimalID = [clinicAnimalIDs objectAtIndex:1];
            aVC.apiTokenAnimal = thisTokenMain;
        }
    }else if([segue.identifier isEqualToString:@"MainSegueList"]){
        ListClinicsViewController *lVC = (ListClinicsViewController *)segue.destinationViewController;
        lVC.tokenList = thisTokenMain;
        lVC.userIDList = _userIDMain;
    }
    
}
- (IBAction)button1Clicked:(id)sender {
    NSLog(@"ButtonClicked IN MAIN %@",@"HELLO");
}
@end
