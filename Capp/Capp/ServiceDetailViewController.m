//
//  ServiceDetailViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/23/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "Annotation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ASStarRatingView.h"

@interface ServiceDetailViewController () <MKMapViewDelegate>

@end

@implementation ServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *serviceOwner = self.service[@"serviceOwner"];
    self.sID = self.service[@"SID"];
    [self imageFetcher];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(376, 1241)];
    
    //totalRating.text = [NSString stringWithFormat:@"%@/5", [self.service[@"totalRating"] description]];
    self.staticRatingView.canEdit = NO;
    self.staticRatingView.maxRating = 5;
    self.staticRatingView.rating = [self.service[@"totalRating"] floatValue];
    
    NSString *fname = [serviceOwner[@"FName"] description];
    NSString *lname = [serviceOwner[@"LName"] description];
    fullName.text = [NSString stringWithFormat:@"%@ %@", fname, lname];
    
    phone.text = [self.service[@"phone"] description];
    
    NSString *desc = [self.service[@"description"] description];
    desc = [desc stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    description.text = desc;
    freeTime.text = [self.service[@"freeTime"] description];
    
    map.mapType = MKMapTypeHybrid;
    map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.service[@"latitude"] doubleValue], [self.service[@"longitude"] doubleValue]);
    MKCoordinateRegion region = [map regionThatFits:MKCoordinateRegionMakeWithDistance(location, 800, 800)];
    [map setRegion:region animated:YES];
    
    Annotation *annotation = [[Annotation alloc]initWithCoordinates:location title:@"Mon addresse" subtitle:@""];
    [map addAnnotation:annotation];

}

- (void)imageFetcher {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/getPicture/%@", ngrok,
                             self.sID];
    NSLog(@"url: %@", urlAsString);
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlAsString]];
    NSLog(@"%@", imageData);
    image.image = [UIImage imageWithData: imageData];
}

- (void)setService:(NSDictionary *)service {
    _service = service;
    self.navigationItem.title = @"Service";
}

- (IBAction)serviceRequest:(id)sender {
    NSDictionary *serviceOwner = self.service[@"serviceOwner"];
    NSString *uID = serviceOwner[@"UID"];
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/requestService/%@", ngrok, @"1"];
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



@end
