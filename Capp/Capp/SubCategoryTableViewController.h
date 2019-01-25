//
//  SubCategoryTableViewController.h
//  Capp
//
//  Created by Mehdi Amine on 3/14/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"

@interface SubCategoryTableViewController : UITableViewController

@property (nonatomic, strong) NSString *selectedCategory;

-(instancetype) initWithSelectedCategory: (NSString *)selectedCategory;

@end
