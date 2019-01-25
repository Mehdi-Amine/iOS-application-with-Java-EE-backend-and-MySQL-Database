//
//  SubCategoryTableViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/14/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "SubCategoryTableViewController.h"
#import "ServicesTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SubCategoryTableViewController () <UINavigationControllerDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, copy) NSArray *subCategories;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *userCoordinates;

@end

@implementation SubCategoryTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (instancetype)initWithSelectedCategory:(NSString *)selectedCategory {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Spécialisations";
        
        _selectedCategory = selectedCategory;
        
        NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/subCategories/%@", ngrok, self.selectedCategory];
        NSURL *url = [NSURL URLWithString:urlAsString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"GET"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if ([data length] > 0 && connectionError == nil) {
                NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                _subCategories = jsonObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
                //NSLog(@"From init SubCategory: %@", self.subCategories);
            }
            else if ([data length] == 0 && connectionError == nil){
                NSLog(@"Nothing was downloaded.");
            }
            else if (connectionError != nil){
                NSLog(@"Error happened %@", connectionError);
            }
        }];

    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    //Getting the location of the device
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }else {
        NSLog(@"Location services are not enabled");
    }
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/subCategories/%@", ngrok, self.selectedCategory];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.subCategories = jsonObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            //NSLog(@"%@", self.subCategories);
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
    
    
}

- (void)setSelectedCategory:(NSString *)selectedCategory {
    _selectedCategory = selectedCategory;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu", [self.subCategories count]);
    return [self.subCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //NSLog(@"CellForRow accessed");
    //NSLog(@"From CellForRow SubCategory: %@", self.subCategories);
    
    NSDictionary *dictionary = self.subCategories[indexPath.row];
    
    cell.textLabel.text = dictionary[@"subCategoryTitle"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.subCategories[indexPath.row];
    NSString *dictSubCategory = dictionary[@"subCategoryTitle"];
    
    //ServicesTableViewController *servicesTVC = [[ServicesTableViewController alloc] initWithSelectedSubCategory:dictSubCategory];
    ServicesTableViewController *servicesTVC = [[ServicesTableViewController alloc] init];
    servicesTVC.selectedSubCategory = dictSubCategory;
    servicesTVC.userCoordinates = self.userCoordinates;
    [self.navigationController pushViewController:servicesTVC animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //NSLog(@"Latitude = %f", [locations lastObject].coordinate.latitude);
    //NSLog(@"Longitude = %f", [locations lastObject].coordinate.longitude);
    NSNumber *latitude = [[NSNumber alloc] initWithDouble:[locations lastObject].coordinate.latitude];
    NSNumber *longitude = [[NSNumber alloc] initWithDouble:[locations lastObject].coordinate.longitude];
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%@", latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%@", longitude];
    
    NSString *userCoordinates = [NSString stringWithFormat:@"%@,%@", latitudeStr, longitudeStr];
    
    NSLog(@"%@", userCoordinates);
    self.userCoordinates = userCoordinates;
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"ERROR: %@", error);
}


@end
