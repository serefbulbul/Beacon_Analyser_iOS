//
//  BeaconModel.h
//  Beacon Analyser
//
//  Created by Şeref Bülbül on 21/12/15.
//  Copyright © 2015 adesso TR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconDataModel, SavedBeaconModel;

NS_ASSUME_NONNULL_BEGIN

@interface BeaconModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "BeaconModel+CoreDataProperties.h"
