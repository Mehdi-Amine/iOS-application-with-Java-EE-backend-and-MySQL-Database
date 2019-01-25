//
//  CustomCell.m
//  Capp
//
//  Created by Mehdi Amine on 4/4/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "CustomCell.h"
#import "ServiceManagerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"

@interface CustomCell () <UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *subCategories;
@property (nonatomic, strong) NSMutableArray *perimeters;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation CustomCell
@synthesize titleLabel = _titleLabel;
@synthesize detailLabel = _detailLabel;
@synthesize phoneTxt = _phoneTxt;
@synthesize image1 = _image1;
@synthesize descriptionTxtView = _descriptionTxtView;
@synthesize categoryPicker = _categoryPicker;
@synthesize perimeterPicker = _perimeterPicker;
@synthesize mapView = _mapView;
@synthesize freeTimeTxtView = _freeTimeTxtView;
@synthesize statusSeg = _statusSeg;
@synthesize datePicker1 = _datePicker1;
@synthesize datePicker2 = _datePicker2;
@synthesize delegate = _delegate;

@synthesize phone = _phone;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIColor *primaryColor = [UIColor blackColor];
    UIColor *secondaryColor = [UIColor lightGrayColor];
    
    UIFont *bigFont = [UIFont fontWithName:@"Avenir-Book" size:17];
    UIFont *smallFont = [UIFont fontWithName:@"Avenir-Light" size:17];
    
    if (self.titleLabel) {
        self.titleLabel.font = bigFont;
        self.titleLabel.textColor = primaryColor;
    }
    
    if (self.detailLabel) {
        //self.detailLabel.font = smallFont;
        //self.detailLabel.textColor = secondaryColor;
        self.detailLabel.font = bigFont;
        self.detailLabel.textColor = primaryColor;
    }
    
    if (self.phoneTxt) {
        self.phoneTxt.delegate = self;
    }
    
    if (self.categoryPicker) {
        self.categoryPicker.delegate = self;
        self.categoryPicker.dataSource = self;
        
        [self categoriesLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.categoryPicker reloadAllComponents];
        });
    }
    
    if (self.descriptionTxtView) {
        self.descriptionTxtView.delegate = self;
    }
    
    if (self.freeTimeTxtView) {
        self.freeTimeTxtView.delegate = self;
    }
    
    if (self.mapView) {
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self.mapView addGestureRecognizer:longPressGesture];
        
    }
    
    if (self.perimeterPicker) {
        self.perimeterPicker.delegate = self;
        
        for (NSInteger i = 0; i < 50; i++) {
            [self.perimeters setObject:[NSNumber numberWithInteger:i] atIndexedSubscript:i];
        }
    }
    
    if (self.statusSeg) {
        [self.statusSeg addTarget:self action:@selector(statusChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)descriptionTxtViewDidChange:(id)sender {
    // Handle change.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView.tag == 0) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        if (component == 0) {
            return [self.categories count];
        }
        else {
            return [self.subCategories count];
        }
    }
    else{
        return 50;
    }
}

- (void)categoriesLoader {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/categories", ngrok];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.categories = jsonObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.categoryPicker reloadAllComponents];
            });
            //NSLog(@"%@", self.categories);
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
}

- (void)subCategoriesLoader:(NSString *)selectedCategory {
    NSString *urlAsString = [NSString stringWithFormat:@"https://%@.ngrok.io/CapstoneApp-war/resources/MyRestService/subCategories/%@", ngrok, selectedCategory];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil) {
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            self.subCategories = jsonObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.categoryPicker reloadAllComponents];
            });
            //NSLog(@"From init SubCategory: %@", self.subCategories);
        }
        else if ([data length] == 0 && connectionError == nil){
            NSLog(@"Nothing was downloaded.");
        }
        else if (connectionError != nil){
            NSLog(@"Error happened %@", connectionError);
        }
    }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        if(component == 0) {
            NSDictionary *categoryDict = [self.categories objectAtIndex:row];
            NSString *category = categoryDict[@"categoryTitle"];
            //NSLog(@"CATEGORY: %@", category);
            [self subCategoriesLoader:category];
            [self.categoryPicker reloadComponent:1];
        }
        else if (component == 1){
            NSDictionary *subCategoryRecord = [self.subCategories objectAtIndex:row];
            self.subCategory = subCategoryRecord[@"subCategoryTitle"];
            [self.delegate saveSubCategory:self.subCategory];
        }
    }
    else {
        /////////
    }
}

- (IBAction)changedDate1:(id)sender {
    NSDateFormatter *date1 = [[NSDateFormatter alloc]init];
    date1.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    date1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *date1Str = [date1 stringFromDate:[self.datePicker1 date]];
    
    NSLog(@"Date1 str: %@", date1Str);
    [self.delegate saveDate1:date1Str];
}

- (IBAction)changedDate2:(id)sender {
    NSDateFormatter *date2 = [[NSDateFormatter alloc]init];
    date2.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    date2.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *date2Str = [date2 stringFromDate:[self.datePicker2 date]];
    
    NSLog(@"Date2 str: %@", date2Str);
    [self.delegate saveDate2:date2Str];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (pickerView.tag == 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.categoryPicker rowSizeForComponent:component].width, [self.categoryPicker rowSizeForComponent:component].height)];
        
        if(component == 0)
        {
            NSDictionary *dictionary = [self.categories objectAtIndex:row];
            NSString *dictCategory = dictionary[@"categoryTitle"];
            
            label.text = dictCategory;
            label.font = [UIFont systemFontOfSize:16];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.categoryPicker reloadAllComponents];
            });
            
            return label;
        }
        else
        {
            NSDictionary *subCategoriesDict = [self.subCategories objectAtIndex:row];
            NSString *subCategoryStr = subCategoriesDict[@"subCategoryTitle"];
            
            label.text = subCategoryStr;
            label.font = [UIFont systemFontOfSize:14];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.categoryPicker reloadAllComponents];
            });
            
            return label;
        }
    }
    else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.perimeterPicker rowSizeForComponent:component].width, [self.perimeterPicker rowSizeForComponent:component].height)];
        label.text = self.perimeters[row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.perimeterPicker reloadAllComponents];
        });

        return label;
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        Annotation *dropPin = [[Annotation alloc] init];
        dropPin.coordinate = locCoord;
        [self.mapView addAnnotation:dropPin];
        
        NSNumber *lat = [[NSNumber alloc] initWithDouble:dropPin.coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc] initWithDouble:dropPin.coordinate.longitude];
                              
        NSString *latitude = [NSString stringWithFormat:@"%@", lat];
        NSString *longitude = [NSString stringWithFormat:@"%@", lng];
        NSString *coordinate = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
        
        [self.delegate saveLatitude:latitude];
        [self.delegate saveLongitude:longitude];
        
    }
}
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* annotationView;
    //NSLog(@"MAPS ARE FUN");
    
    if (annotation == mapView.userLocation)
    {
        
        
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"blueDot"];
        if (annotationView != nil)
        {
            annotationView.annotation = annotation;
        }
    }
    else
    {
        
        annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"regularPin"];
        
        if (annotationView != nil)
        {
            annotationView.annotation = annotation;
        }
    }
    return annotationView;
}*/

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self.delegate loadNewScreen:imagePicker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.image1.image = image;
    
    NSData *imageBytes = UIImageJPEGRepresentation(image, 0);
    
    [self.delegate dismissScreen];
    [self.delegate saveImageData:imageBytes];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 0) {
        self.desc = self.descriptionTxtView.text;
        [self.delegate saveDescription:self.desc];
    }
    else if(textView.tag == 1){
        self.freeTime = self.freeTimeTxtView.text;
        [self.delegate saveFreeTime:self.freeTime];
      
    }
    else{
        
        self.phone = self.phoneTxt.text;
        [self.delegate savePhone:self.phone];
        
    }
}

- (void)statusChanged:(id)sender{
    self.status = [self.statusSeg titleForSegmentAtIndex:self.statusSeg.selectedSegmentIndex];
    [self.delegate saveStatus:self.status];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changedDatePicker2:(id)sender {
}
@end
