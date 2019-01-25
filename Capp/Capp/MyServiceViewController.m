//
//  MyServiceViewController.m
//  Capp
//
//  Created by Mehdi Amine on 3/29/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "MyServiceViewController.h"

@interface MyServiceViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *subCategories;
@end

@implementation MyServiceViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self categoriesLoader];
        dispatch_async(dispatch_get_main_queue(), ^{
            [categoryPicker reloadAllComponents];
        });
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Mon Service";
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(600, 870)];
    
    [imageScroller setScrollEnabled:YES];
    
    categoryPicker.delegate = self;
    categoryPicker.dataSource = self;
    categoryPicker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    categoryPicker.layer.borderWidth = 0.5;
    categoryPicker.layer.cornerRadius = 8;
    
    [self categoriesLoader];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [categoryPicker reloadAllComponents];
    });
    
    descriptionTxtView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    descriptionTxtView.layer.borderWidth = 0.5;
    descriptionTxtView.layer.cornerRadius = 8;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setEmail:(NSString *)email{
    _email = email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.categories count];
    }
    else {
        return [self.subCategories count];
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
                [categoryPicker reloadAllComponents];
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
                [categoryPicker reloadAllComponents];
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

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSDictionary *dictionary = [self.categories objectAtIndex:row];
        NSString *dictCategory = dictionary[@"categoryTitle"];
        return dictCategory;
    }
    else
    {
        NSDictionary *subCategoriesDict = [self.subCategories objectAtIndex:row];
        NSString *subCategoryStr = subCategoriesDict[@"subCategoryTitle"];
        
        return subCategoryStr;
    }
}
*/
 
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0) {
        NSDictionary *categoryDict = [self.categories objectAtIndex:row];
        NSString *category = categoryDict[@"categoryTitle"];
        NSLog(@"CATEGORY: %@", category);
        [self subCategoriesLoader:category];
        [categoryPicker reloadComponent:1];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [categoryPicker rowSizeForComponent:component].width, [categoryPicker rowSizeForComponent:component].height)];
    
    
    if(component == 0)
    {
        NSDictionary *dictionary = [self.categories objectAtIndex:row];
        NSString *dictCategory = dictionary[@"categoryTitle"];
        
        label.text = dictCategory;
        label.font = [UIFont systemFontOfSize:16];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [categoryPicker reloadAllComponents];
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
            [categoryPicker reloadAllComponents];
        });
        
        return label;
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    self.view.frame = newFrame;
    
    [UIView commitAnimations];
}

- (IBAction)takePicture:(id)sender
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    servicePicture.image = image;
    
    [imageScroller setContentSize:servicePicture.frame.size];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
