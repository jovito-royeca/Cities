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

/*
 * This is an array of @code City objects in memory.
 * @see loadCities After reading and loading data from the JSON file, each City is created and added to this array.
 * Since this project does not use Core Data or other database implementation, we are storing all data in this in-memory array.
 * Working with data in memory may consume a lot of memory, but it is faster to filter and sort.
 *
 * @see City The city object to store the keys and values from the JSON file
 *
 */
@property(strong, nullable) NSArray *cities;

/*
 * This is a dictionary of {prefix-letter : array-of-cities} to be used in a @code UITableView section indexes.
 * @see createSectionIndexTitles for generating this dictionary.
 *
 */
@property(strong, nullable) NSMutableDictionary *sectionIndexTitles;

/*
 * This is a sorted array of prefix-letter to be used in a @code UITableView section indexes and headers.
 * @see createSectionIndexTitles for generating this array.
 *
 */
@property(strong, nullable) NSArray *sortedSectionIndexTitles;

/*
 * This is the singleton generator for this class. We need a singleton object of this class because we are dealing with the
 * potentially large @see cities objects in memory.
 *
 */
+ (instancetype _Nonnull) sharedInstance;

/*
 * This reads the data/cities.json file and stores them as an array of City objects in memory.
 * @see cities
 *
 */
- (void) loadCities;

/*
 * This filters the cities array prefixing the city.name using the given filter.
 * We define a prefix string as: a substring that matches the initial characters of the target string. For instance, assume the following entries:
 * Alabama, US
 * Albuquerque, US
 * Anaheim, US Arizona, US Sydney, AU
 * If the given prefix is 'A', all cities but Sydney should appear. Contrariwise, if the given prefix is “s”, the only result should be “Sydney, AU”.
 * If the given prefix is “Al”, “Alabama, US” and “Albuquerque, US” are the only results.
 * If the prefix given is “Alb” then the only result is “Albuquerque, US”
 
 * @param filter the String to be used for prefixing the city.name property
 * @return an array of prefixed (filterd) city objects
 *
 */
- (NSArray*_Nonnull) filterCities:(NSString* _Nullable) filter;

/*
 * A convinience method to create a dictionary of @see sectionIndexTitles and @see sortedSectionIndexTitles.
 * Note that accents to characters are removed and treated as a normal character, i.e. À becomes normal A.
 * However, accents on some some non-English characters are not removed, i.e. Ł, Ø, etc.
 * Also, non-English characters without English equivalent remain as is, i.e. Russian and Chinese characters.
 *
 * @param cities An array of cities to create sectionIndexTitles from
 */
- (void) createSectionIndexTitlesFrom:(NSArray*_Nonnull) cities;

@end
