//
//  AuthenticationViewController.h
//  Capp
//
//  Created by Mehdi Amine on 3/11/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ngrok @"1fcc6f29"

@interface AuthenticationViewController : UIViewController
- (instancetype) initWithDevToken:(NSString *)devToken;
@end