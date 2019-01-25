//
//  CustomCell.h
//  Capp
//
//  Created by Mehdi Amine on 4/4/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define ngrok @"1fcc6f29"

@protocol changePictureProtocol <NSObject>
-(void)loadNewScreen:(UIViewController *)controller;
-(void)dismissScreen;
-(void)savePhone:(NSString *)phone;
-(void)saveSubCategory:(NSString *)subCategory;
-(void)saveDescription:(NSString *)description;
-(void)saveImage:(UIImage *)image;
-(void)saveLatitude:(NSString *)latitude;
-(void)saveLongitude:(NSString *)longitude;
-(void)saveFreeTime:(NSString *)freeTime;
-(void)saveStatus:(NSString *)status;
-(void)saveDate1:(NSString *)date1Str;
-(void)saveDate2:(NSString *)date2Str;
-(void)saveImageData:(NSData *)imageBytes;
@end


@interface CustomCell : UITableViewCell<UIPickerViewDelegate, UIPickerViewDataSource>{

}
@property (nonatomic, weak) IBOutlet UITextView *descriptionTxtView;
@property (nonatomic, weak) IBOutlet UIPickerView *categoryPicker;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIImageView *image1;
@property (nonatomic, weak) IBOutlet UIPickerView *perimeterPicker;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextView *freeTimeTxtView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *statusSeg;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker1;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker2;
@property (nonatomic, weak) IBOutlet UITextView *phoneTxt;

@property (nonatomic, retain) id<changePictureProtocol> delegate;

@property (nonatomic, strong) NSString *uID;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *perimeter;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *freeTime;
@property (nonatomic, strong) NSString *status;


@end




