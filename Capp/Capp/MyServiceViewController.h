//
//  MyServiceViewController.h
//  Capp
//
//  Created by Mehdi Amine on 3/29/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"

@interface MyServiceViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    IBOutlet UIScrollView *scroller;
    IBOutlet UIScrollView *imageScroller;
    IBOutlet UIControl *background;
    IBOutlet UIPickerView *categoryPicker;
    IBOutlet UITextView *descriptionTxtView;
    IBOutlet UIImageView *servicePicture;
}

@property (strong, nonatomic) NSString *email;

@end
