//
//  CategoryTableViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/12/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "SubCategoryTableViewController.h"

@interface CategoryTableViewController () <UINavigationControllerDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *categories;

@end

@implementation CategoryTableViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self) {
        [self categoriesLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    return self;
}

/*
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}
*/

- (void)categoriesLoader {
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Catégories";
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/categories", ngrok];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            _categories = jsonObject;
            //NSLog(@"%@", self.categories);
            //NSLog(@"%lu", [self.categories count]);
            
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        //activityIndicator.hidden = TRUE;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self categoriesLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = self.categories[indexPath.row];
    
    cell.textLabel.text = dictionary[@"categoryTitle"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    NSDictionary *dictionary = self.categories[indexPath.row];
    NSString *dictCategory = dictionary[@"categoryTitle"];
    
    SubCategoryTableViewController *subCategoryTVC = [[SubCategoryTableViewController alloc] init];
    subCategoryTVC.selectedCategory = dictCategory;
    
    [self.navigationController pushViewController:subCategoryTVC animated:YES];
    */
    NSDictionary *dictionary = self.categories[indexPath.row];
    NSString *dictCategory = dictionary[@"categoryTitle"];
    
    SubCategoryTableViewController *subCategoryTVC = [[SubCategoryTableViewController alloc] initWithSelectedCategory:dictCategory];
    
    [self.navigationController pushViewController:subCategoryTVC animated:YES];
}


@end
