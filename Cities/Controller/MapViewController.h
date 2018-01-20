//
//  MapViewController.h
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "City.h"

@interface MapViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) City *city;

#pragma mark - Custom methods
- (void) locateCity;

@end
