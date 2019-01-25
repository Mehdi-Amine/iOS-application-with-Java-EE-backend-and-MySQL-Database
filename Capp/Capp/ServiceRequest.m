//
//  ServiceRequest.m
//  Capp
//
//  Created by Mehdi Amine on 4/6/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "ServiceRequest.h"

@interface ServiceRequest () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *cellDescriptors;
@property (nonatomic, strong) NSMutableArray *visibleRows;

@end

@implementation ServiceRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellDescriptors = [[NSMutableArray alloc]init];
        self.visibleRows = [[NSMutableArray alloc]init];
        [self configureTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Demande de Service";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureTableView];
    [self loadCellDescriptors];
}

- (void)configureTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UINib *normalCellNib = [UINib nibWithNibName:@"NormalCell" bundle:nil];
    [self.tableView registerNib:normalCellNib forCellReuseIdentifier:@"idCellNormal"];
    
    UINib *categoryCellNib = [UINib nibWithNibName:@"CategoryPickerCell" bundle:nil];
    [self.tableView registerNib:categoryCellNib forCellReuseIdentifier:@"idCellCategory"];
    
    UINib *textCellNib = [UINib nibWithNibName:@"TextViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:@"idCellDescription"];
    
    UINib *dateCellNib1 = [UINib nibWithNibName:@"DateCell1" bundle:nil];
    [self.tableView registerNib:dateCellNib1 forCellReuseIdentifier:@"idCellDate1"];
    
    UINib *requestCellNib = [UINib nibWithNibName:@"RequestCell" bundle:nil];
    [self.tableView registerNib:requestCellNib forCellReuseIdentifier:@"idCellRequestService"];
}

- (void)loadCellDescriptors {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RequestCellDescriptor" ofType:@"plist"];
    if (path) {
        self.cellDescriptors = [NSMutableArray arrayWithContentsOfFile:path];
        [self getIndicesOfVisibleRows];
        [self.tableView reloadData];
    }
}

- (void)getIndicesOfVisibleRows {
    [self.visibleRows removeAllObjects];
    
    for (int i = 0; i < [self.cellDescriptors count]; i++) {
        NSDictionary *dict = [self.cellDescriptors objectAtIndex:i];
        //NSLog(@"%@", dict);
        if ([dict[@"isVisible"] boolValue] == true) {
            NSNumber *number = [NSNumber numberWithInt:i];
            [self.visibleRows addObject:number];
        }
    }
}

- (NSDictionary *)getCellDescriptorForIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfVisibleRow = [[self.visibleRows objectAtIndex:indexPath.row] integerValue];
    
    NSDictionary *cellDescriptor = [self.cellDescriptors objectAtIndex:indexOfVisibleRow];
    
    return cellDescriptor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.visibleRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:currentCellDescriptor[@"cellIdentifier"]];
    
    if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellNormal"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NormalCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString *primaryTitle = currentCellDescriptor[@"primaryTitle"];
        if (primaryTitle) {
            cell.titleLabel.text = primaryTitle;
        }
        
        NSString *secondaryTitle = currentCellDescriptor[@"secondaryTitle"];
        if (secondaryTitle) {
            cell.detailLabel.text = secondaryTitle;
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellCategory"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoryPickerCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellDescription"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellDate1"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DateCell1" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellDate2"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DateCell2" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellRequestService"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    NSString *identifier = currentCellDescriptor[@"cellIdentifier"];
    
    if ([identifier isEqualToString:@"idCellNormal"]) {
        return 60.0;
    }
    else if ([identifier isEqualToString:@"idCellCategory"]) {
        return 228.0;
    }
    else if ([identifier isEqualToString:@"idCellDescription"]){
        return 270.0;
    }
    else if ([identifier isEqualToString:@"idCellDate1"]){
        return 230.0;
    }
    else if ([identifier isEqualToString:@"idCellDate2"]){
        return 230.0;
    }
    else{
        return 70.0;
    }
}

-(void)saveSubCategory:(NSString *)subCategory{
    self.subCategory = subCategory;
    NSLog(@"controller subCategory: %@", self.subCategory);
}

-(void)saveDescription:(NSString *)description{
    self.desc = description;
    NSLog(@"controller description: %@", self.desc);
}

- (void)saveDate1:(NSString *)date1Str{
    self.date1 = date1Str;
    NSLog(@"controller date1: %@", self.date1);
}

- (void)saveDate2:(NSString *)date2Str{
    self.date2 = date2Str;
    NSLog(@"controller date2: %@", self.date2);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int selectedIndex = [self.visibleRows[indexPath.row] intValue];
    NSDictionary *currentCellDescriptor = [self.cellDescriptors objectAtIndex:selectedIndex];
    
    if ([currentCellDescriptor[@"isExpandable"]boolValue] == true) {
        BOOL shouldExpandAndShowSubRows = false;
        if ([currentCellDescriptor[@"isExpanded"]boolValue] == false) {
            shouldExpandAndShowSubRows = true;
        }
        [currentCellDescriptor setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isExpanded"];
        [self.cellDescriptors setObject:currentCellDescriptor atIndexedSubscript:selectedIndex];
        
        for (NSInteger i = indexPath.row + 1; i <= indexPath.row + [currentCellDescriptor[@"additionalRows"]intValue]; i++) {
            NSDictionary *cellDescriptor = [self.cellDescriptors objectAtIndex:i];
            [cellDescriptor setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isVisible"];
            [self.cellDescriptors setObject:cellDescriptor atIndexedSubscript:i];
        }
        
        [self getIndicesOfVisibleRows];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([currentCellDescriptor[@"cellIdentifier"] isEqualToString:@"idCellRequestService"]){
        NSLog(@"controller uID: %@", self.uID);
        NSLog(@"controller subCategory: %@", self.subCategory);
        NSLog(@"controller description: %@", self.desc);
        NSLog(@"controller date1: %@", self.date1);
        NSLog(@"controller date1: %@", self.date2);
        
        NSString *filledDescription = [self.desc stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *filledD1 = [self.date1 stringByReplacingOccurrencesOfString:@" " withString:@","];
        NSString *filledD2 = [self.date2 stringByReplacingOccurrencesOfString:@" " withString:@","];
        
        NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/saveMission/%@/%@/%@/%@/%@", ngrok, self.uID, self.subCategory, filledDescription, filledD1, filledD2];
        
        NSLog(@"%@", urlAsString);
        NSURL *url = [NSURL URLWithString:urlAsString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Request creation response = %@", jsonObject);
            
        }];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end