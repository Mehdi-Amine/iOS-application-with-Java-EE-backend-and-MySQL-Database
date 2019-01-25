//
//  RateViewController.h
//  Capp
//
//  Created by Mehdi Amine on 4/16/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"
@class ASStarRatingView;

@interface RateViewController : UIViewController
@property (nonatomic, strong) IBOutlet ASStarRatingView *qualityRatingView;
@property (nonatomic, strong) IBOutlet ASStarRatingView *priceRatingView;
@property (nonatomic, strong) IBOutlet ASStarRatingView *punctualityRatingView;
@property (nonatomic, strong) IBOutlet ASStarRatingView *friendlinessRatingView;
@property (nonatomic, strong) NSString *sID;
@property (nonatomic, strong) NSString *serviceOwner;
@end
