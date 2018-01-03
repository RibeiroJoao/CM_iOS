//
//  AnimalViewController.m
//  Pet Universal
//
//  Created by students@deti on 05/12/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import "AnimalViewController.h"
#import "Pet Universal-Bridging-Header.h"

@interface AnimalViewController ()

@end

NSString *animalID;

@implementation AnimalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if( _apiClinicAnimalID == nil ){
        NSLog(@"ANIMAL ID at Animal = %@", _localAnimalID);
        if([_localAnimalID  isEqual: @"0"] ){
            FIRDatabaseReference *rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/animals",@"https://pet-universal-app-id.firebaseio.com/"]];
            [rootRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
             {
                 if (snapshot.exists)
                 {
                     for ( FIRDataSnapshot *child in snapshot.children) {
                         if ([child.key containsString:@"nomeAnimal1"]){
                             self.animalNameLabel.text = child.value;
                         }
                         else if ([child.key containsString:@"imagemLink1"]){
                            NSURL *url1 = [NSURL URLWithString:child.value];
                            NSData *data1 = [NSData dataWithContentsOfURL:url1];
                            UIImage* image1 = [[UIImage alloc] initWithData:data1];
                            [self.imagemAnimalView setImage:image1];
                        }
                         else if ([child.key containsString:@"especieAnimal1"]){
                             self.animalEspecieLabel.text = [@"Espécie: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"raçaAnimal1"]){
                             self.animalRacaLabel.text = [@"Raça: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"sexoAnimal1"]){
                             self.animalSexoLabel.text = [@"Sexo: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"idadeAnimal1"]){
                             self.animalIdadeLabel.text = [@"Idade: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"pesoAnimal1"]){
                             self.animalPesoLabel.text = [@"Peso: " stringByAppendingFormat:@"%@", child.value];
                         }
                     }
                 }
             }];
        }else if ([_localAnimalID  isEqual: @"1"]){
            FIRDatabaseReference *rootRef= [[FIRDatabase database] referenceFromURL:[NSString stringWithFormat:@"%@/animals",@"https://pet-universal-app-id.firebaseio.com/"]];
            [rootRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot)
             {
                 if (snapshot.exists)
                 {
                     for ( FIRDataSnapshot *child in snapshot.children) {
                         if ([child.key containsString:@"nomeAnimal2"]){
                             self.animalNameLabel.text = child.value;
                         }
                         else if ([child.key containsString:@"imagemLink2"]){
                             NSURL *url2 = [NSURL URLWithString:child.value];
                             NSData *data2 = [NSData dataWithContentsOfURL:url2];
                             UIImage* image2 = [[UIImage alloc] initWithData:data2];
                             [self.imagemAnimalView setImage:image2];
                         }
                         else if ([child.key containsString:@"especieAnimal2"]){
                             self.animalEspecieLabel.text = [@"Espécie: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"raçaAnimal2"]){
                             self.animalRacaLabel.text = [@"Raça: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"sexoAnimal2"]){
                             self.animalSexoLabel.text = [@"Sexo: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"idadeAnimal2"]){
                             self.animalIdadeLabel.text = [@"Idade: " stringByAppendingFormat:@"%@", child.value];
                         }
                         else if ([child.key containsString:@"pesoAnimal2"]){
                             self.animalPesoLabel.text = [@"Peso: " stringByAppendingFormat:@"%@", child.value];
                         }
                     }
                 }
             }];
        }
    }else{
        //api
        NSLog(@"ClinicAnimal in ANIMAL = %@", _apiClinicAnimalID);
        [self getAnimalID];
        [self getAnimalDetails];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getAnimalID {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/clinicAnimals/%@",_apiClinicAnimalID]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",_apiTokenAnimal] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected to API IN ANIMAL");
        NSInteger success = 1;
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            //NSLog(@"SUCCESS API ANIMAL %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"animal"]){
                    animalID = [jsonData objectForKey:key];
                }
            }
        }
        else {
            NSLog(@"UNSUCCESS API ANIMAL %@", jsonData);
        }
        NSLog(@"ANIMAL ID IN ANIMAL= %@",animalID);
    }
    else {
        NSLog(@"ERROR 1 ANIMAL %@ %@ %@", @"Cant connect to API", urlData,  response1);
    }
}

- (void) getAnimalDetails {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://qa.petuniversal.com/hospi/api/animals/%@",animalID]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %1$@",_apiTokenAnimal] forHTTPHeaderField:@"Authorization"];
    
    NSError *requestError = nil;
    NSHTTPURLResponse *response1 = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response1
                                                        error:&requestError];
    
    //if communication was successful
    if ([response1 statusCode] >= 200 && [response1 statusCode] < 300) {
        
        NSLog(@"Connected 2 to API IN ANIMAL");
        NSInteger success = 1;
        NSError *serializeError = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&serializeError];
        success = [jsonData[@"ERROR"] integerValue];
        
        if (success == 0) {
            NSLog(@"SUCCESS API 2 ANIMAL %@", jsonData);
            for (NSString* key in jsonData) {
                if ([key  containsString:@"name"]){
                    self.animalNameLabel.text = [jsonData objectForKey:key];
                }else if ([key  containsString:@"species"]){
                    NSString *breedStr = [NSString stringWithFormat:@"%@", [jsonData objectForKey:key]];
                    if([breedStr  isEqualToString: @"9615"]){
                        self.animalEspecieLabel.text = @"Espécie: Cão";
                    }else if([breedStr  isEqualToString: @"9685"]){
                        self.animalEspecieLabel.text = @"Espécie: Gato";
                    }
                }else if ([key  containsString:@"breed"]){
                    if([[jsonData objectForKey:key] isEqual:@"91"])     //ALTERAR
                        self.animalRacaLabel.text = @"Raça: Golden Retriever";
                    else
                        self.animalRacaLabel.text = @"Raça: Bengal"; //breed: 7
                }else if ([key  containsString:@"sex"]){
                    if([[jsonData objectForKey:key] isEqual:@"M"])
                        self.animalSexoLabel.text = @"Sexo: Masculino";
                    else
                        self.animalSexoLabel.text = @"Sexo: Feminino";
                }else if ([key  containsString:@"birthdate"]){
                    if([[jsonData objectForKey:key] isEqual:@"2013-11-23T00:00:00.000+0000"])
                        self.animalIdadeLabel.text = @"Idade: 4 anos";
                    else
                        self.animalIdadeLabel.text = @"Idade: 1 ano";
                }else if ([key  containsString:@"currentWeightValue"]){
                        self.animalPesoLabel.text = [NSString stringWithFormat:@"Peso: %@ kg",[jsonData objectForKey:key]];
                }
            }
        }
        else {
            NSLog(@"UNSUCCESS API 2 ANIMAL %@", jsonData);
        }
    }
    else {
        NSLog(@"ERROR 2 ANIMAL %@ %@ %@", @"Cant connect to API", urlData,  response1);
    }
}


@end
