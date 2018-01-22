//
//  City.h
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * The object representation of the cities in data/cities.json file.
 * This is stored as an in-memory array of cities in @see CitiesManager.cities.
 *
 */
@interface City : NSObject


/*
 * The "_id" field in the JSON file.
 *
 */
@property (nonatomic, retain) NSString *cityId;

/*
 * The "name" field in the JSON file.
 *
 */
@property (nonatomic, retain) NSString *name;

/*
 * The "country" field in the JSON file.
 *
 */
@property (nonatomic, retain) NSString *country;

/*
 * The "coord.lat" field in the JSON file. Needed for displaying in a @see MKMapView.
 *
 */
@property (nonatomic, retain) NSNumber *latitude;

/*
 * The "coord.lon" field in the JSON file. Needed for displaying in a @see MKMapView.
 *
 */
@property (nonatomic, retain) NSNumber *longitude;


@end
