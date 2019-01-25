//
//  ServicesTableViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/17/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "ServicesTableViewController.h"
#import "ServiceDetailViewController.h"
#import "ASStarRatingView.h"

@interface ServicesTableViewController () <UINavigationControllerDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *services;
@property (nonatomic, copy) NSDictionary *distances;

@end

@implementation ServicesTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Services";
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //Service list request
    //NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/closestServices/%@/%@", ngrok, self.selectedSubCategory, @"33.542276,-5.104513"];
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/closestServices/%@/%@", ngrok, self.selectedSubCategory, self.userCoordinates];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.services = jsonObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            //NSLog(@"%@", self.services);
            //NSLog(@"Counting services: %lu", [self.services count]);
            
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
    
}

- (void)setSelectedSubCategory:(NSString *)selectedSubCategory {
    _selectedSubCategory = selectedSubCategory;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.services count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.services[indexPath.row];
    NSDictionary *serviceOwnerDict = dictionary[@"serviceOwner"];
    NSString *fname = [serviceOwnerDict[@"FName"] description];
    NSString *lname = [serviceOwnerDict[@"LName"] description];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", fname, lname];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, 60, 20)];
    distanceLabel.text = [dictionary[@"distance"] description];
    [distanceLabel setFont:[UIFont systemFontOfSize:12]];
    
    ASStarRatingView *ratingView = [[ASStarRatingView alloc] initWithFrame:CGRectMake(5, 10, 90, 90)];
    ratingView.canEdit = NO;
    ratingView.maxRating = 5;
    ratingView.rating = [dictionary[@"totalRating"] floatValue];
    
    UIView *accessoryContainer = [[UIView alloc] initWithFrame:CGRectMake(25, 25, 80, 90)];
    [accessoryContainer addSubview:distanceLabel];
    [accessoryContainer addSubview:ratingView];
    
    cell.accessoryView = accessoryContainer;
    //cell.accessoryView = distanceLabel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.services[indexPath.row];
    ServiceDetailViewController *serviceDetail = [[ServiceDetailViewController alloc] init];
    
    serviceDetail.service = dictionary;
    
    [self.navigationController pushViewController:serviceDetail animated:YES];
    
}


@end
