//
//  MissionDetailViewController.h
//  Capp
//
//  Created by Mehdi Amine on 4/16/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"

@interface MissionDetailViewController : UIViewController{
    IBOutlet UILabel *name;
    IBOutlet UILabel *desc;
    IBOutlet UITextView *sDate;
    IBOutlet UITextView *eDate;
    IBOutlet UIButton *confirm;
    IBOutlet UIButton *finish;
}
@property (nonatomic, strong) NSString *uID;
@property (nonatomic, strong) NSString *client;
@property (nonatomic, strong) NSString *sID;
@property (nonatomic, strong) NSString *serviceOwner;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *date1;
@property (nonatomic, strong) NSString *date2;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *status;
@end
