//
//  ServiceDetailViewController.h
//  Capp
//
//  Created by Mehdi Amine on 3/23/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define ngrok @"1fcc6f29"
@class ASStarRatingView;

@interface ServiceDetailViewController : UIViewController{
    IBOutlet UIScrollView *scroller;
    IBOutlet UILabel *totalRating;
    IBOutlet UILabel *fullName;
    IBOutlet UITextView *phone;
    IBOutlet UITextView *description;
    IBOutlet MKMapView *map;
    IBOutlet UIImageView *image;
    IBOutlet UITextView *freeTime;
}

@property (nonatomic, strong) NSDictionary *service;
@property (nonatomic, strong) NSString *sID;
@property (nonatomic, strong) IBOutlet ASStarRatingView *staticRatingView;

@end
