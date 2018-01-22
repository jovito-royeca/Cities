//
//  CitiesManager.h
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface CitiesManager : NSObject

@property(strong, nullable) NSMutableArray *cities;
@property(strong, nullable) NSMutableDictionary *sectionIndexTitles;
@property(strong, nullable) NSArray *sortedSectionIndexTitles;

+ (instancetype _Nonnull) sharedInstance;
- (void) loadCities;
- (NSArray*_Nonnull) filterCities:(NSString* _Nullable) filter;
- (void) createSectionIndexTitles;

@end
