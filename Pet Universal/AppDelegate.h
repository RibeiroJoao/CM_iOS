//
//  AppDelegate.h
//  Pet Universal
//
//  Created by students@deti on 18/11/17.
//  Copyright © 2017 pet@ua.pt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> //Firebase

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

