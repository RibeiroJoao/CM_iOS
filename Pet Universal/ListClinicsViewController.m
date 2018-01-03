//
//  ListClinicsViewController.m
//  Pet Universal
//
//  Created by students@deti on 21/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import "ListClinicsViewController.h"
#import "MainViewController.h"

@interface ListClinicsViewController ()

@end


@implementation ListClinicsViewController

NSMutableArray *tableData;
NSMutableArray *tableDataIDs;
NSMutableArray *tableImageURLs;
NSString *token2 = nil;
NSString *clinicName;
NSString *clinicID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [NSMutableArray new];
    tableDataIDs = [NSMutableArray new];
    tableImageURLs = [NSMutableArray new];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingNotification:) name:@"NOTIFICATION_TOKEN" object:nil];
    
    if (_tokenList != NULL){
        NSLog(@"TOKEN AT LIST = %@",_tokenList);
        token2 = _tokenList;
        //Get clinics from API
        [self getPetClinics];
    }else{
        NSLog(@"TOKEN AT LIST is %@",_tokenList);
        //Get clinics from FIREBASE
        FIRDatabaseReference *rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/clinics",@"https://pet-universal-app-id.firebaseio.com/"]];
        [rootRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
         {
             if (snapshot.exists)
             {
                 for ( FIRDataSnapshot *child in snapshot.children) {
                     if ([child.key containsString:@"name"]){
                         [tableData addObject:child.value];
                         NSLog(@"CLINIC NAME Firebase LIST= %@",child.value);
                     }
                     else if ([child.key containsString:@"imagem"]){
                         [tableImageURLs addObject:child.value];
                     }
                 }
                 [_tableview reloadData];
             }
         }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*- (void) incomingNotification:(NSNotification *)notification{
    if ([[notification name] isEqualToString:@"NOTIFICATION_TOKEN"]){
        token2 = [notification object];
        NSLog(@"NOTIFICATION_TOKEN IN LIST = %@",token2);
    }
}*/

- (NSString *)getPetClinics {
    NSString *apisuccess;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://qa.petuniversal.com/hospi/api/clinics"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",token2] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API LIST");
        NSError *serializeError = nil;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:kNilOptions
                                                          error:&serializeError];
        if (json.count>0) {
            NSLog(@"CLINIC NAME API LIST= %@",json[0][@"name"]);
            [tableData addObject:json[0][@"name"]];
            NSLog(@"CLINIC ID API LIST= %@",json[0][@"id"]);
            [tableDataIDs addObject:json[0][@"id"]];
            //TODO
            //NSData* imageData = [json[0][@"image"] dataUsingEncoding:NSUTF8StringEncoding];
            //self.imgage.image= [UIImage imageWithData:imageData];
        }
    }
    else {
        NSLog(@"ERROR LIST %@ %@ %@", @"Cant connect to API", urlData,  response1);
        apisuccess = @"FALSE";
    }
    return apisuccess;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Clinicas";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"myTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    if([tableImageURLs count] != 0){
        NSString* urlString = [tableImageURLs objectAtIndex:indexPath.row];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        cell.imageView.image = [UIImage imageWithData:imageData];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"logo-clinic.png"]; //generic image
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"CLICK LIST CELL = %@ %@ %lu",clinicID, clinicName, (unsigned long)tableDataIDs.count);
    if (tableDataIDs.count>0){ //API
        clinicID = [tableDataIDs objectAtIndex:indexPath.row];
        clinicName = cell.textLabel.text;
    }
    [self performSegueWithIdentifier:@"ListSegueMain" sender:tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ListSegueMain"]){
        MainViewController *mVC = (MainViewController *)segue.destinationViewController;
        NSLog(@"SEGUE para MAIN com %@ %@ %@ ", token2, clinicID, _userIDList);
        mVC.tokenMain = token2;
        mVC.clinicIDMain = clinicID;
        mVC.userIDMain = _userIDList;
    }
}

@end
