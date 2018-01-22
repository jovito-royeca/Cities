//
//  CitiesViewController.m
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import "CitiesViewController.h"

@interface CitiesViewController ()

@property(strong,nonatomic) UISearchController *searchController;
@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) NSArray *cities;
@property(strong,nonatomic) NSMutableDictionary *sectionIndexTitles;
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
- (void) showCities:(NSString*) filter {
    if (filter) {
        self.cities = [CitiesManager.sharedInstance filterCities: filter];
    } else {
        self.cities = CitiesManager.sharedInstance.cities;
    }
    
    [self createSectionIndexTitles];
    [self.tableView reloadData];
}


- (void) createSectionIndexTitles {
    self.sectionIndexTitles = [[NSMutableDictionary alloc] init];
    
    for (City *city in self.cities) {
        NSInteger sentinel = 1;
        NSString *prefix = [city.name substringToIndex: sentinel].uppercaseString;
        // remove the accents
        prefix = [prefix stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale: [NSLocale localeWithLocaleIdentifier:@"en"]].uppercaseString;
        
        // convert numbers to "#"
        if ([prefix rangeOfCharacterFromSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
            prefix = [[NSMutableString alloc] initWithString:@"#"];
            // ignore other characters
        } else if ([prefix rangeOfCharacterFromSet: NSCharacterSet.alphanumericCharacterSet].location == NSNotFound) {
            do {
                prefix = [city.name substringWithRange: NSMakeRange(sentinel, 1)].uppercaseString;
                // remove the accents
                prefix = [prefix stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale: [NSLocale localeWithLocaleIdentifier:@"en"]].uppercaseString;
                
                sentinel++;
            } while ([prefix rangeOfCharacterFromSet: NSCharacterSet.alphanumericCharacterSet].location == NSNotFound);
        }
        
        NSMutableArray *array = self.sectionIndexTitles[prefix];
        // we found a previous array, just append the city
        if (array) {
            [array addObject: city];
            // create a new array for the prefix
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject: city];
            self.sectionIndexTitles[prefix] = array;
        }
    }
    
    // sort alphabetically
    self.sortedSectionIndexTitles = [self.sectionIndexTitles.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    NSInteger rows = 0;
    
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
    
    if (self.cities) {
        sections = self.sectionIndexTitles.allKeys.count;
    } else {
        sections = 1;
    }
    
    return sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
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
