//
//  RateViewController.m
//  Capp
//
//  Created by Mehdi Amine on 4/16/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "RateViewController.h"
#import "ASStarRatingView.h"

@interface RateViewController ()

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qualityRatingView.canEdit = YES;
    self.qualityRatingView.maxRating = 5;
    self.qualityRatingView.minAllowedRating = 0;
    
    self.priceRatingView.canEdit = YES;
    self.priceRatingView.maxRating = 5;
    self.priceRatingView.minAllowedRating = 0;
    
    self.punctualityRatingView.canEdit = YES;
    self.punctualityRatingView.maxRating = 5;
    self.punctualityRatingView.minAllowedRating = 0;

    self.friendlinessRatingView.canEdit = YES;
    self.friendlinessRatingView.maxRating = 5;
    self.friendlinessRatingView.minAllowedRating = 0;
    
}
- (IBAction)rateService:(id)sender {
    NSLog(@"quality: %lf", self.qualityRatingView.rating);
    NSLog(@"price: %lf", self.priceRatingView.rating);
    NSLog(@"punctuality: %lf", self.punctualityRatingView.rating);
    NSLog(@"friendliness: %lf", self.friendlinessRatingView.rating);
    float totalRating = (self.qualityRatingView.rating + self.priceRatingView.rating + self.punctualityRatingView.rating
                            + self.friendlinessRatingView.rating) / 4;
    int r = totalRating;
    NSNumber *rating = [NSNumber numberWithInt:r];
    NSString *totalGiven = [rating description];
    NSLog(@"total: %@", totalGiven);
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/rateService/%@/%@", ngrok, self.serviceOwner, totalGiven];
    
    NSLog(@"%@", urlAsString);
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"rating response = %@", jsonObject);
    }];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
