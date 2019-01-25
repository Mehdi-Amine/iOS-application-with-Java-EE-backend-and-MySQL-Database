//
//  ServicesTableViewController.h
//  Capp
//
//  Created by Mehdi Amine on 3/17/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"

@interface ServicesTableViewController : UITableViewController

@property (nonatomic, strong) NSString *selectedSubCategory;
@property (nonatomic, strong) NSString *userCoordinates;

- (instancetype)initWithCoordinates: (NSString *)userCoordinates;

@end
