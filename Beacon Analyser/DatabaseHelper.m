//
//  DatabaseHelper.m
//  iBeaconAnalyser
//
//  Created by Şeref Bülbül on 19/11/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import "DatabaseHelper.h"

@implementation DatabaseHelper

+ (NSManagedObject *)insertNewEntityWithName:(NSString *)entityName
                                  andContext:(NSManagedObjectContext *)managedObjectContext {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    return entity;
}

// Fetch objects with a predicate
+ (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext {
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// If a sort key was passed then use it in the request
	if (sortKey != nil) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
	}
    
	// Execute the fetch request
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
	// If the returned array was nil then there was an error
	if (mutableFetchResults == nil)
		NSLog(@"Couldn't get objects for entity %@", entityName);
    
	// Return the results
	return mutableFetchResults;
}

+ (NSMutableArray *)searchObjectsForEntityWithBlock:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    if (predicate != nil)
        [request setPredicate:predicate];
    
    if (sortKey != nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
    }
    
    __block NSMutableArray *mutableFetchResults;
    
    [managedObjectContext performBlock:^{
        NSError *error = nil;
        mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    }];
    
    if (mutableFetchResults == nil)
        NSLog(@"Couldn't get objects for entity %@", entityName);
    
    return mutableFetchResults;
}

// Fetch objects without a predicate
+ (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext {
	return [self searchObjectsForEntity:entityName withPredicate:nil andSortKey:sortKey andSortAscending:sortAscending andContext:managedObjectContext];
}

#pragma mark - Count objects

// Get a count for an entity with a predicate
+ (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext {
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
	// If the count returned NSNotFound there was an error
	if (count == NSNotFound)
		NSLog(@"Couldn't get count for entity %@", entityName);
    
	// Return the results
	return count;
}

// Get a count for an entity without a predicate
+ (NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext {
	return [self countForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}

#pragma mark - Delete Objects

// Delete all objects for a given entity
+ (BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext {
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// Ignore property values for maximum performance
	[request setIncludesPropertyValues:NO];
    
	// Execute the count request
	NSError *error = nil;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil) {
		for (NSManagedObject *manObj in fetchResults) {
			[managedObjectContext deleteObject:manObj];
		}
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;
}

#pragma mark - Get Highest Value

// Fetch objects with a predicate
+ (NSManagedObject *)getLastObjectForEntity:(NSString *)entityName forAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext {
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    // If a predicate was specified then use it in the request
    if (predicate != nil)
        [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:attribute ascending:NO selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    // Execute the fetch request
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];

    if (mutableFetchResults == nil)
        NSLog(@"Couldn't get objects for entity %@", entityName);

    return [mutableFetchResults firstObject];
}

#pragma mark - Get Distict Attribute Values

// Fetch objects with a predicate
+ (NSMutableArray *)getDistictAttributeValuesForEntity:(NSString *)entityName forAttribute:(NSString *)attribute andContext:(NSManagedObjectContext *)managedObjectContext {
    // Create fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
    // Since you only want distinct names, only ask for the 'name' property.
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:attribute]];
    request.returnsDistinctResults = YES;
    
    // Execute the fetch request
    NSError *error = nil;
    NSArray *mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in mutableFetchResults) {
        [returnArray addObject:[dictionary objectForKey:attribute]];
    }
    
    if (mutableFetchResults == nil)
        NSLog(@"Couldn't get objects for entity %@", entityName);
    
    return returnArray;
}

#pragma mark - Utils

+ (NSError *)saveCoreData:(NSManagedObjectContext *)managedObjectContext {
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
//        SCLAlertView *alertView = [Utils initCustomAlert];
//        [alertView addButton:@"Tamam" actionBlock:^{
//            abort();
//        }];
//        [alertView showEdit:@"" subTitle:[@"DatabaseSaveError" localize] closeButtonTitle:nil duration:0.0f];
    }
    return error;
}

@end
