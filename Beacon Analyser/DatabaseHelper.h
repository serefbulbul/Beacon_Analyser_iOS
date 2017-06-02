//
//  DatabaseHelper.h
//  iBeaconAnalyser
//
//  Created by Şeref Bülbül on 19/11/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseHelper : NSObject <NSFetchedResultsControllerDelegate> {
    
}

+ (NSManagedObject *)insertNewEntityWithName:(NSString *)entityName
                                  andContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey
                      andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSMutableArray *)searchObjectsForEntity:(NSString*)entityName
                            withPredicate:(NSPredicate *)predicate
                               andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending
                               andContext:(NSManagedObjectContext *)managedObjectContext;
+ (BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
                 andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSManagedObject *)getLastObjectForEntity:(NSString *)entityName forAttribute:(NSString *)attribute withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext;
//+ (NSMutableArray *)searchObjectsForEntityWithBlock:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSMutableArray *)getDistictAttributeValuesForEntity:(NSString *)entityName forAttribute:(NSString *)attribute andContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSError *)saveCoreData:(NSManagedObjectContext *)managedObjectContext;

@end
