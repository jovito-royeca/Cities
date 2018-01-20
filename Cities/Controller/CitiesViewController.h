//
//  CitiesViewController.h
//  Cities
//
//  Created by Jovito Royeca on 20/01/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitiesManager.h"
#import "MapViewController.h"

@interface CitiesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
