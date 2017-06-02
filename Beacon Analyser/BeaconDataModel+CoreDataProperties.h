//
//  BeaconDataModel+CoreDataProperties.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeaconDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeaconDataModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *actualProximity;
@property (nullable, nonatomic, retain) BeaconModel *beacon;

@end

NS_ASSUME_NONNULL_END
