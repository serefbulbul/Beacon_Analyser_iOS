//
//  BeaconModel+CoreDataProperties.m
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeaconModel+CoreDataProperties.h"

@implementation BeaconModel (CoreDataProperties)

@dynamic major;
@dynamic minor;
@dynamic name;
@dynamic proximityUUID;
@dynamic beaconData;
@dynamic savedBeacon;

@end
