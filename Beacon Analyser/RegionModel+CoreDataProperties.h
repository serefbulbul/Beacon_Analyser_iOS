//
//  RegionModel+CoreDataProperties.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RegionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegionModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *major;
@property (nullable, nonatomic, retain) NSNumber *minor;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *proximityUUID;
@property (nullable, nonatomic, retain) NSNumber *willBeScanned;

@end

NS_ASSUME_NONNULL_END
