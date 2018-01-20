//
//  CitiesViewController.m
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import "CitiesViewController.h"

@interface CitiesViewController ()

@property(strong,nonatomic) NSArray *cities;

@end

@implementation CitiesViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Cities";
    self.cities = CitiesManager.sharedInstance.cities;
    
    // Setup the Search Controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
    self.searchController.searchResultsUpdater = self;
    if (@available(iOS 9.1, *)) {
        self.searchController.obscuresBackgroundDuringPresentation = NO;
    } else {
        // Fallback on earlier versions
    }
    self.searchController.searchBar.placeholder = @"Search Cities";
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        // Fallback on earlier versions
    }
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.searchController.active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    City *city = sender[@"city"];
    MapViewController *mapVC = segue.destinationViewController;
    
    mapVC.city = city;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = self.cities.count;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    City *city = self.cities[indexPath.row];
    
    if (self.searchController.searchBar.text.length == 0) {
        cell.textLabel.text = city.name;
    } else {
        NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString: city.name attributes: nil];
        NSRange range = [attrib.string.lowercaseString rangeOfString: self.searchController.searchBar.text.lowercaseString];
        [attrib setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize: 18]} range:range];
        cell.textLabel.attributedText = attrib;
    }
    cell.detailTextLabel.text = city.country;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *city = self.cities[indexPath.row];
    
    [self performSegueWithIdentifier: @"showMap" sender: @{@"city": city}];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.cities = [CitiesManager.sharedInstance filterCities: searchController.searchBar.text];
    [self.tableView reloadData];
}

@end
