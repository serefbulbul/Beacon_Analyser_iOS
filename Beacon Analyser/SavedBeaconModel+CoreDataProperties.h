//
//  SavedBeaconModel+CoreDataProperties.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SavedBeaconModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SavedBeaconModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *accuracy;
@property (nullable, nonatomic, retain) NSString *examinationId;
@property (nullable, nonatomic, retain) NSNumber *proximity;
@property (nullable, nonatomic, retain) NSNumber *rssi;
@property (nullable, nonatomic, retain) NSString *saveTime;
@property (nullable, nonatomic, retain) NSNumber *actualProximity;
@property (nullable, nonatomic, retain) BeaconModel *beacon;

@end

NS_ASSUME_NONNULL_END
