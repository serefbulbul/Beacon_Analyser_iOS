//
//  AppDelegate.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *beaconAnalyserManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *beaconAnalyserManagedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *beaconAnalyserPersistentStoreCoordinator;

- (void)beaconAnalyserSaveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

