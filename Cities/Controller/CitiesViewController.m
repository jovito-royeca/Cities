//
//  CitiesViewController.m
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import "CitiesViewController.h"

@interface CitiesViewController ()

/*
 * The @see UISearchController for iOS 9.1 and above
 */
@property(strong,nonatomic) UISearchController *searchController;

/*
 * The @see UISearchBar for below iOS 9.1
 */
@property(strong,nonatomic) UISearchBar *searchBar;

/*
 * Conveniece property for @see CityManager.cities.
 */
@property(strong,nonatomic) NSArray *cities;

/*
 * Conveniece property for @see CityManager.sectionIndexTitles.
 */
@property(strong,nonatomic) NSMutableDictionary *sectionIndexTitles;

/*
 * Conveniece property for @see CityManager.sortedSectionIndexTitles.
 */
@property(strong,nonatomic) NSArray *sortedSectionIndexTitles;

@end

@implementation CitiesViewController

#pragma mark - Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Cities";
    
    // Setup the Search Controller
    if (@available(iOS 9.1, *)) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.searchBar.placeholder = @"Search Cities";
        [self.searchController.searchBar sizeToFit];
        self.searchController.obscuresBackgroundDuringPresentation = NO;
        self.definesPresentationContext = YES;
    } else {
        // Fallback on earlier versions
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        self.searchBar.delegate = self;
        self.searchBar.placeholder = @"Search Cities";
    }
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        // Fallback on earlier versions
        self.tableView.tableHeaderView = self.searchBar;
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    if (@available(iOS 11.0, *)) {
        self.searchController.active = YES;
        [self.searchController.searchBar becomeFirstResponder];
    } else {
        // Fallback on earlier versions
        [self showCities: nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods
/*
 * Filters the list of cities
 * @param filter The text typed by the user in the UISearchBar
 *
 */
- (void) showCities:(NSString*) filter {
    self.cities = [CitiesManager.sharedInstance filterCities: filter];
    
    [CitiesManager.sharedInstance createSectionIndexTitlesFrom: self.cities];
    self.sectionIndexTitles = CitiesManager.sharedInstance.sectionIndexTitles;
    self.sortedSectionIndexTitles = CitiesManager.sharedInstance.sortedSectionIndexTitles;
    
    [self.tableView reloadData];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new MapViewController using [segue destinationViewController].
    // Pass the selected City to the new view controller.
    City *city = sender[@"city"];
    MapViewController *mapVC = segue.destinationViewController;
    
    mapVC.city = city;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    // return 1 if we have not loaded our cities yet
    if (self.cities) {
        NSString *key = self.sortedSectionIndexTitles[section];
        NSArray *arrayValues = self.sectionIndexTitles[key];
        
        rows = arrayValues.count;
    } else {
        rows = 1;
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    
    // return 1 if we have not loaded our cities yet
    if (self.cities) {
        sections = self.sectionIndexTitles.allKeys.count;
    } else {
        sections = 1;
    }
    
    return sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    // Show a "Loading..." cell if we have not loaded the cities first
    if (self.cities) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
        NSString *key = self.sortedSectionIndexTitles[indexPath.section];
        NSArray *arrayValues = self.sectionIndexTitles[key];
        City *city = arrayValues[indexPath.row];
        
        if (self.searchController.searchBar.text.length == 0) {
            cell.textLabel.text = city.name;
        } else {
            NSMutableAttributedString *attrib = [[NSMutableAttributedString alloc] initWithString: city.name attributes: nil];
            NSRange range = [attrib.string.lowercaseString rangeOfString: self.searchController.searchBar.text.lowercaseString];
            [attrib setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize: 18]} range:range];
            cell.textLabel.attributedText = attrib;
        }
        cell.detailTextLabel.text = city.country;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
    }
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle;
    
    if (self.cities) {
        headerTitle = self.sortedSectionIndexTitles[section];
    }
    
    return headerTitle;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray<NSString *> *indexTitles;
    
    if (self.cities) {
        indexTitles = [self.sectionIndexTitles.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cities) {
        NSString *key = self.sortedSectionIndexTitles[indexPath.section];
        NSArray *arrayValues = self.sectionIndexTitles[key];
        City *city = arrayValues[indexPath.row];
        
        [self performSegueWithIdentifier: @"showMap" sender: @{@"city": city}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    // return table height  if we have not loaded our cities yet
    if (self.cities) {
        height = UITableViewAutomaticDimension;
    } else {
        height = self.tableView.frame.size.height;
    }
    
    return height;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // to limit searching, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(showCities:) object: nil];
    [self performSelector:@selector(showCities:) withObject: searchController.searchBar.text afterDelay: 0.5];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // to limit searching, reload half a second after last key press.
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(showCities:) object: nil];
    [self performSelector:@selector(showCities:) withObject: searchBar.text afterDelay: 0.5];
}

@end
