//
//  AppDelegate.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 07/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self beaconAnalyserSaveContext];
}

#pragma mark - Core Data stack

@synthesize beaconAnalyserManagedObjectContext = _beaconAnalyserManagedObjectContext;
@synthesize beaconAnalyserManagedObjectModel = _beaconAnalyserManagedObjectModel;
@synthesize beaconAnalyserPersistentStoreCoordinator = _beaconAnalyserPersistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.adesso.Beacon_Analyser" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)beaconAnalyserManagedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_beaconAnalyserManagedObjectModel != nil) {
        return _beaconAnalyserManagedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Beacon_Analyser" withExtension:@"momd"];
    _beaconAnalyserManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _beaconAnalyserManagedObjectModel;
}

- (NSPersistentStoreCoordinator *)beaconAnalyserPersistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_beaconAnalyserPersistentStoreCoordinator != nil) {
        return _beaconAnalyserPersistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _beaconAnalyserPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self beaconAnalyserManagedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Beacon_Analyser.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_beaconAnalyserPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _beaconAnalyserPersistentStoreCoordinator;
}


- (NSManagedObjectContext *)beaconAnalyserManagedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_beaconAnalyserManagedObjectContext != nil) {
        return _beaconAnalyserManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self beaconAnalyserPersistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _beaconAnalyserManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_beaconAnalyserManagedObjectContext setPersistentStoreCoordinator:coordinator];
    return _beaconAnalyserManagedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)beaconAnalyserSaveContext {
    NSManagedObjectContext *managedObjectContext = self.beaconAnalyserManagedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
