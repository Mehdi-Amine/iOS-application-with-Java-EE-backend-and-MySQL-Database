//
//  ServiceManagerViewController.h
//  Capp
//
//  Created by Mehdi Amine on 4/4/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface ServiceManagerViewController : UITableViewController{
    IBOutlet UITableView *expandableTableView;
}

@property (nonatomic, strong) NSString *uID;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *perimeter;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *freeTime;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *serviceCreated;
@end
