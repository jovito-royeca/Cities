//
//  CitiesTests.m
//  CitiesTests
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CitiesManager.h"

@interface CitiesTests : XCTestCase

@end

@implementation CitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

// This test measures the performance of loading the cities from JSON file.
- (void)testSearchPerformance {
    [self measureBlock:^{
        [CitiesManager.sharedInstance filterCities: nil];
    }];
}

// This test measures the performance of loading the cities from JSON file, and creating the sectionIndexTitles
- (void)testFilteringPerformance {
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [CitiesManager.sharedInstance createSectionIndexTitles];
    }];
}

// This test checks that non-alphabetic search filters are working
- (void) testSearchNonAlpha {
    NSString *filter = @"‘";
    
    NSArray *results = [CitiesManager.sharedInstance filterCities: filter];
    XCTAssert(results.count > 0);
}

// This test checks that normal alphabetic search filters are working
- (void) testSearchNormal {
    NSString *filter = @"Manila";
    
    NSArray *results = [CitiesManager.sharedInstance filterCities: filter];
    XCTAssert(results.count > 0);
}

// This test checks that numeric search filters are working
- (void) testSearchNumeric {
    NSString *filter = @"6";
    
    NSArray *results = [CitiesManager.sharedInstance filterCities: filter];
    XCTAssert(results.count > 0);
}

// This test checks that search filters with no results are working
- (void) testSearchNoResults {
    NSString *filter = @"ThisCityIsNonExixtent";
    
    NSArray *results = [CitiesManager.sharedInstance filterCities: filter];
    XCTAssert(results.count == 0);
}


@end
