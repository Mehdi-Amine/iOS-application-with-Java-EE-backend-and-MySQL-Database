//
//  CreateAccountViewController.m
//  Capp
//
//  Created by Mehdi Amine on 4/7/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

@interface CreateAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, strong) NSString *userId;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)createAccount:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSString *fName = self.firstName.text;
    NSString *lName = self.lastName.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/newUser/%@/%@/%@/%@/client", ngrok, fName, lName, email, password];
    NSLog(@"%@", urlAsString);
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"User creation response = %@", jsonObject);
        MenuViewController *menuVC = [[MenuViewController alloc]init];
        if (self.userId == NULL) {
            [self uIDFetcher];
        }
        menuVC.uID = self.userId;
        menuVC.email = self.emailField.text;
        menuVC.devToken = appDelegate.devToken;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:menuVC];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:navController animated:YES completion:nil];
        });
    }];
}

- (void)uIDFetcher {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/userByEmail/%@", ngrok, self.emailField.text];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:60.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSString *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             self.userId = jsonObject;
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
