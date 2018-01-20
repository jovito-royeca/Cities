//
//  MapViewController.m
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self locateCity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Custom methods
- (void) locateCity {
    if (self.city) {
        self.title = [NSString stringWithFormat: @"%@, %@", self.city.name, self.city.country];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude = self.city.latitude.doubleValue;
        coordinate.longitude = self.city.longitude.doubleValue;
        annotation.coordinate = coordinate;
        
        [self.mapView addAnnotation: annotation];
        [self.mapView setCenterCoordinate: coordinate];
    }
}

@end
