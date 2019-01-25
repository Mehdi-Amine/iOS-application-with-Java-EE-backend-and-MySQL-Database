//
//  MenuViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/29/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "MenuViewController.h"
#import "ServiceManagerViewController.h"
#import "CategoryTableViewController.h"
#import "ServiceRequest.h"
#import "MissionTableViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Menu";
    if (self.uID == NULL) {
        NSLog(@"fetching");
        [self uIDFetcher];
        NSLog(@"fetched %@", self.uID);
    }
    //NSLog(@"Menu id: %@", self.uID);
    //NSLog(@"Menu dev: %@", self.devToken);
    [self saveDevTokenForUser];
}

- (void)uIDFetcher {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/userByEmail/%@", ngrok, self.email];
    NSLog(@"%@", urlAsString);
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"logging json: %@", jsonObject[@"UID"]);
            self.uID = jsonObject[@"UID"];
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
}


- (void)saveDevTokenForUser {
    //NSLog(@"token: %@", self.devToken);
    //NSLog(@"uID: %@", self.uID);
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/saveDevice/%@/%@", ngrok, self.devToken, self.uID];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestService:(id)sender {
    ServiceRequest *serviceRequest = [[ServiceRequest alloc] init];
    serviceRequest.uID = self.uID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:serviceRequest animated:YES];
    });
}
- (IBAction)browseServices:(id)sender {
    CategoryTableViewController *categoryTVC = [[CategoryTableViewController alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:categoryTVC animated:YES];
    });
}

- (IBAction)myService:(id)sender {
    if (self.uID == NULL) {
        NSLog(@"fetching");
        [self uIDFetcher];
        NSLog(@"fetched %@", self.uID);
    }
    ServiceManagerViewController *serviceManager = [[ServiceManagerViewController alloc]init];
    serviceManager.uID = self.uID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:serviceManager animated:YES];
    });
}

- (IBAction)archive:(id)sender {
    //NSLog(@"Archive");
    MissionTableViewController *missionTVC = [[MissionTableViewController alloc] init];
    missionTVC.uID = self.uID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:missionTVC animated:YES];
    });
}


@end
