//
//  ServiceManagerViewController.m
//  Capp
//
//  Created by Mehdi Amine on 4/4/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "ServiceManagerViewController.h"

@interface ServiceManagerViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableArray *cellDescriptors;
@property (nonatomic, strong) NSMutableArray *visibleRows;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) CustomCell *customCell;
@end

@implementation ServiceManagerViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.cellDescriptors = [[NSMutableArray alloc]init];
        self.visibleRows = [[NSMutableArray alloc]init];
        [self configureTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
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
    
    UINib *phoneCellNib = [UINib nibWithNibName:@"PhoneCell" bundle:nil];
    [self.tableView registerNib:phoneCellNib forCellReuseIdentifier:@"idCellPhone"];
    
    UINib *categoryCellNib = [UINib nibWithNibName:@"CategoryPickerCell" bundle:nil];
    [self.tableView registerNib:categoryCellNib forCellReuseIdentifier:@"idCellCategory"];
    
    UINib *textCellNib = [UINib nibWithNibName:@"TextViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:@"idCellDescription"];
    
    UINib *imageCellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
    [self.tableView registerNib:imageCellNib forCellReuseIdentifier:@"idCellImage"];
    
    UINib *perimeterCellNib = [UINib nibWithNibName:@"PerimeterCell" bundle:nil];
    [self.tableView registerNib:perimeterCellNib forCellReuseIdentifier:@"idCellPerimeter"];
    
    UINib *mapCellNib = [UINib nibWithNibName:@"MapCell" bundle:nil];
    [self.tableView registerNib:mapCellNib forCellReuseIdentifier:@"idCellMap"];
    
    UINib *freeTimeCellNib = [UINib nibWithNibName:@"FreeTimeCell" bundle:nil];
    [self.tableView registerNib:freeTimeCellNib forCellReuseIdentifier:@"idCellFreeTime"];
    
    UINib *statusCellNib = [UINib nibWithNibName:@"StatusCell" bundle:nil];
    [self.tableView registerNib:statusCellNib forCellReuseIdentifier:@"idCellStatus"];
    
    UINib *createServiceCellNib = [UINib nibWithNibName:@"CreateServiceCell" bundle:nil];
    [self.tableView registerNib:createServiceCellNib forCellReuseIdentifier:@"idCellCreateService"];

}

- (void)loadCellDescriptors {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.visibleRows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:currentCellDescriptor[@"cellIdentifier"]];
    self.customCell = [tableView dequeueReusableCellWithIdentifier:currentCellDescriptor[@"cellIdentifier"]];
    
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
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellPhone"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [self.cells setObject:cell atIndexedSubscript:0];
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
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellImage"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellPerimeter"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PerimeterCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellMap"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MapCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellFreeTime"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FreeTimeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellStatus"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatusCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    else if ([currentCellDescriptor[@"cellIdentifier"]  isEqual: @"idCellCreateService"]) {
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreateServiceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }
    cell.delegate = self;
    cell.uID = self.uID;
    self.customCell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *currentCellDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    NSString *identifier = currentCellDescriptor[@"cellIdentifier"];
    if ([identifier isEqualToString:@"idCellNormal"]) {
        return 60.0;
    }
    else if ([identifier isEqualToString:@"idCellPhone"]){
        return 44;
    }
    else if ([identifier isEqualToString:@"idCellCategory"]) {
        return 228;
    }
    else if ([identifier isEqualToString:@"idCellDescription"]){
        return 270.0;
    }
    else if ([identifier isEqualToString:@"idCellImage"]){
        return 365.0;
    }
    else if ([identifier isEqualToString:@"idCellPerimeter"]){
        return 44.0;
    }
    else if ([identifier isEqualToString:@"idCellMap"]){
        return 500.0;
    }
    else if ([identifier isEqualToString:@"idCellFreeTime"]){
        return 150.0;
    }
    else if ([identifier isEqualToString:@"idCellStatus"]){
        return 44;
    }
    else{
        return 70.0;
    }
}

- (void)savePhone:(NSString *)phone{
    self.phone = phone;
    NSLog(@"controller phone: %@", self.phone);
}

-(void)saveSubCategory:(NSString *)subCategory{
    self.subCategory = subCategory;
    NSLog(@"controller subCategory: %@", self.subCategory);
}

-(void)saveDescription:(NSString *)description{
    self.desc = description;
    NSLog(@"controller description: %@", self.desc);
}

-(void)saveImage:(UIImage *)image{
    self.image = image;
    NSLog(@"controller image: %@", self.image.description);
}

-(void)saveLatitude:(NSString *)latitude{
    self.latitude = latitude;
    NSLog(@"controller latitude: %@", self.latitude);
}

-(void)saveLongitude:(NSString *)longitude{
    self.longitude = longitude;
    NSLog(@"controller longitude: %@", self.longitude);
}

-(void)saveFreeTime:(NSString *)freeTime{
    self.freeTime = freeTime;
    NSLog(@"controller freeTime: %@", self.freeTime);
}

-(void)saveStatus:(NSString *)status{
    self.status = status;
    NSLog(@"controller status: %@", self.status);
}

-(void)saveImageData:(NSData *)imageBytes{
    self.imageData = imageBytes;
    NSLog(@"controller imageData: %@", self.imageData);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int selectedIndex = [self.visibleRows[indexPath.row] intValue];
    NSDictionary *currentCellDescriptor = [self.cellDescriptors objectAtIndex:selectedIndex];
    
    if ([currentCellDescriptor[@"isExpandable"]boolValue] == true) {
        BOOL shouldExpandAndShowSubRows = false;
        if ([currentCellDescriptor[@"isExpanded"]boolValue] == false) {
            shouldExpandAndShowSubRows = true;
            [currentCellDescriptor setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isExpanded"];
            [self.cellDescriptors setObject:currentCellDescriptor atIndexedSubscript:selectedIndex];
            
            for (NSInteger i = indexPath.row + 1; i <= indexPath.row + [currentCellDescriptor[@"additionalRows"]intValue]; i++) {
                NSDictionary *cellDescriptor = [self.cellDescriptors objectAtIndex:i];
                [cellDescriptor setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isVisible"];
                [self.cellDescriptors setObject:cellDescriptor atIndexedSubscript:i];
            }
            
        }
        [self getIndicesOfVisibleRows];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if ([currentCellDescriptor[@"cellIdentifier"] isEqualToString:@"idCellCreateService"]){
        NSLog(@"controller uID: %@", self.uID);
        NSLog(@"controller phone: %@", self.phone);
        NSLog(@"controller subCategory: %@", self.subCategory);
        NSLog(@"controller description: %@", self.desc);
        NSLog(@"controller image: %@", self.image.description);
        NSLog(@"controller latitude: %@", self.latitude);
        NSLog(@"controller longitude: %@", self.longitude);
        NSLog(@"controller freeTime: %@", self.freeTime);
        NSLog(@"controller status: %@", self.status);
        
        NSString *filledDescription = [self.desc stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *filledFreeTime = [self.freeTime stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        self.perimeter = @"50";
        
        NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/saveService/%@/%@/%@/%@/%@/%@/%@/%@/%@", ngrok, self.uID, self.phone, self.subCategory, filledDescription, self.perimeter, self.latitude, self.longitude,
                                 filledFreeTime, self.status];
        
        NSLog(@"%@", urlAsString);
        NSURL *url = [NSURL URLWithString:urlAsString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        //[urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        /*NSData *d = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSString *jsonObject = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        self.serviceCreated = jsonObject;
        NSLog(@"Service creation response = %@", self.serviceCreated);*/
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.serviceCreated = jsonObject;
            NSLog(@"Service creation response = %@", self.serviceCreated);
            if (self.serviceCreated != NULL) {
                [self imageSender];
            }
        }];
        
    }
}


- (void)imageSender {
     NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/saveImage/%@", ngrok, self.serviceCreated];
     
     NSLog(@"%@", urlAsString);
     NSURL *url = [NSURL URLWithString:urlAsString];
     NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
     
     //[urlRequest setTimeoutInterval:30.0f];
     [urlRequest setHTTPMethod:@"POST"];
     [urlRequest setHTTPBody:self.imageData];
    NSLog(@"URL BODY: %@", [urlRequest HTTPBody]);
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     
     [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     NSData *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"Image creation response = %@", jsonObject);
     
     }];
}

- (void)loadNewScreen:(UIViewController *)controller;
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)dismissScreen {
    NSLog(@"Dismiss screen");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
