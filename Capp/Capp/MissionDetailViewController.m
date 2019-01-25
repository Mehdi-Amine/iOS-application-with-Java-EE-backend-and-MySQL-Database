//
//  MissionDetailViewController.m
//  Capp
//
//  Created by Mehdi Amine on 4/16/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "MissionDetailViewController.h"
#import "RateViewController.h"
#import <EventKit/EventKit.h>

@interface MissionDetailViewController ()<UINavigationControllerDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NSDate *d1;
@property (nonatomic, strong) NSDate *d2;

@end

@implementation MissionDetailViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    sDate.delegate = self;
    eDate.delegate = self;
    name.text = self.fullName;
    desc.text = self.descript;
    
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [gmtDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.d1 = [gmtDateFormatter dateFromString:self.date1];
    self.d2 = [gmtDateFormatter dateFromString:self.date2];
    
    [gmtDateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    self.date1 = [gmtDateFormatter stringFromDate:self.d1];
    self.date2 = [gmtDateFormatter stringFromDate:self.d2];
    
    sDate.text = self.date1;
    eDate.text = self.date2;
    
    if ([self.uID isEqualToString:self.client]) {
        confirm.hidden = YES;
        finish.hidden = NO;
    }
    else{
        confirm.hidden = NO;
        finish.hidden = YES;
    }
    if ([self.status isEqualToString:@"confirme"]) {
        confirm.hidden = YES;
        finish.hidden = NO;
    }
}
- (IBAction)confimStatus:(id)sender {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/confirmStatus/%@/%@/confirme", ngrok, self.sID, self.uID];
    //NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/confirmStatus", ngrok];
    NSLog(@"%@", urlAsString);
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Confirmation response = %@", jsonObject);
    }];
    confirm.hidden = YES;
    finish.hidden = NO;
}
- (IBAction)finishedStatus:(id)sender {
    confirm.hidden = YES;
    finish.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mission Terminée"
                                                    message:@"Vous avez terminé cette mission"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"uID: %@", self.uID);
    NSLog(@"client: %@", self.client);
    if ([self.uID isEqualToString:self.client]){
        NSLog(@"Rate me");
        RateViewController *rateViewController = [[RateViewController alloc]init];
        rateViewController.sID = self.sID;
        rateViewController.serviceOwner = self.serviceOwner;
        [self presentViewController:rateViewController animated:YES completion:nil];
    }
}

- (bool)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) return;
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = [NSString stringWithFormat:@"Mission avec %@", self.fullName];
        event.startDate = self.d1;
        event.endDate = self.d2;
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //NSString *savedEventId = event.eventIdentifier;
    }];
    
    return YES;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if ([viewControllerToPresent isKindOfClass:UIAlertController.class] && !self.view.window) {
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
