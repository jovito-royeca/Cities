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

@property (strong,nonnull) NSMutableArray *cities;

+ (instancetype _Nonnull) sharedInstance;
- (void) loadCities;
- (NSArray*_Nonnull) filterCities:(NSString* _Nullable) filter;

@end
