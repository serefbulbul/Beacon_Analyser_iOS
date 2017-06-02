//
//  BeaconModel+CoreDataProperties.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeaconModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeaconModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *major;
@property (nullable, nonatomic, retain) NSNumber *minor;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *proximityUUID;
@property (nullable, nonatomic, retain) BeaconDataModel *beaconData;
@property (nullable, nonatomic, retain) NSSet<SavedBeaconModel *> *savedBeacon;

@end

@interface BeaconModel (CoreDataGeneratedAccessors)

- (void)addSavedBeaconObject:(SavedBeaconModel *)value;
- (void)removeSavedBeaconObject:(SavedBeaconModel *)value;
- (void)addSavedBeacon:(NSSet<SavedBeaconModel *> *)values;
- (void)removeSavedBeacon:(NSSet<SavedBeaconModel *> *)values;

@end

NS_ASSUME_NONNULL_END
