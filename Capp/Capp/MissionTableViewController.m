//
//  MissionTableViewController.m
//  Capp
//
//  Created by Mehdi Amine on 4/15/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "MissionTableViewController.h"
#import "MissionDetailViewController.h"

@interface MissionTableViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, copy) NSArray *missions;

@end

@implementation MissionTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Missions";
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood.png"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/getMissions", ngrok];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.missions = jsonObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood.png"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/getMissions", ngrok];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.missions = jsonObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.missions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    
    UIToolbar *translucentView = [[UIToolbar alloc] initWithFrame:CGRectZero];
    cell.backgroundView = translucentView;
    
    NSDictionary *dictionary = self.missions[indexPath.row];
    
    NSDictionary *clientDict = dictionary[@"client"];
    
    NSString *userType = [clientDict[@"userType"] description];
    
    NSString *description = [dictionary[@"description"] description];
    description = [description stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    cell.textLabel.text = description;
    
    NSString *status = [dictionary[@"status"] description];
    
    if ([status isEqualToString:@"confirme"]) {
        NSLog(@"Statusccc: %@", status);
        cell.detailTextLabel.text = @"confirmée";
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }
    else if([status isEqualToString:@"En attente"]){
        NSLog(@"Status: %@", status);
        cell.detailTextLabel.text = status;
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.missions[indexPath.row];
    
    NSDictionary *serviceOwnerDict = dictionary[@"SProvider"];
    NSString *sProvider = serviceOwnerDict[@"UID"];
    
    NSString *sID = [dictionary[@"SID"] description];
    NSDictionary *clientDict = dictionary[@"client"];
    NSString *fname = [clientDict[@"FName"] description];
    NSString *lname = [clientDict[@"LName"] description];
    NSString *userType = [clientDict[@"userType"] description];
    NSString *client = [clientDict[@"UID"] description];
    
    NSString *date1 = [dictionary[@"startingDate"] description];
    date1 = [date1 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    date1 = [date1 stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSString *date2 = [dictionary[@"endingDate"] description];
    date2 = [date2 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    date2 = [date2 stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    
    NSString *description = [dictionary[@"description"] description];
    description = [description stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    NSString *status = [dictionary[@"status"] description];

    MissionDetailViewController *missionDetail = [[MissionDetailViewController alloc] init];
    
    missionDetail.uID = self.uID;
    missionDetail.serviceOwner = sProvider;
    missionDetail.client = client;
    missionDetail.sID = sID;
    missionDetail.fullName = [NSString stringWithFormat:@"%@ %@", fname, lname];
    missionDetail.descript = description;
    missionDetail.date1 = date1;
    missionDetail.date2 = date2;
    missionDetail.status = status;
    [self.navigationController pushViewController:missionDetail animated:YES];
    
}


@end
