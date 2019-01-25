//
//  AuthenticationViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/11/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "MenuViewController.h"
#import "CreateAccountViewController.h"
#import "AppDelegate.h"

@interface AuthenticationViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTxtField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTxtField;
@property (nonatomic, strong) NSString *devToken;

@end

@implementation AuthenticationViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)authenticate:(id)sender {
    NSString *email = self.emailTxtField.text;
    NSString *password = self.passwordTxtField.text;
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/authenticationResponse/%@/%@", ngrok, email, password];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Authentication response = %@", jsonObject);
            if (![jsonObject isEqual: @"failure"]) {
                MenuViewController *menuVC = [[MenuViewController alloc]init];
                menuVC.uID = jsonObject;
                menuVC.devToken = appDelegate.devToken;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuVC];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:navController animated:YES completion:nil];
                });
            }
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];

}

- (IBAction)newAccount:(id)sender {
    CreateAccountViewController *createAccountVC = [[CreateAccountViewController alloc]init];
    [self presentViewController:createAccountVC animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
