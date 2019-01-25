//
//  ServiceRequest.h
//  Capp
//
//  Created by Mehdi Amine on 4/6/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface ServiceRequest : UITableViewController

@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) NSString *subCategory;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *date1;
@property (strong, nonatomic) NSString *date2;
@end
