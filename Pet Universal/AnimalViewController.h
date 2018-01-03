//
//  AnimalViewController.h
//  Pet Universal
//
//  Created by students@deti on 05/12/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import FirebaseDatabase;

@interface AnimalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imagemAnimalView;
@property (weak, nonatomic) IBOutlet NSString *localAnimalID;
@property (weak, nonatomic) IBOutlet NSString *apiClinicAnimalID;
@property (weak, nonatomic) IBOutlet NSString *apiTokenAnimal;
@property (weak, nonatomic) IBOutlet UILabel *animalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalEspecieLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalRacaLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalSexoLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalIdadeLabel;
@property (weak, nonatomic) IBOutlet UILabel *animalPesoLabel;

@end
