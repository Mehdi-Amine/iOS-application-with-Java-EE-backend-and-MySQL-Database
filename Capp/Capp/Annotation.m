//
//  Annotation.m
//  Capp
//
//  Created by Mehdi Amine on 3/24/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinate title:(NSString *)title subtitle:(NSString *)subtitle{
    self = [super init];
    
    if (self) {
        _coordinate = paramCoordinate;
        _title = title;
        _subtitle = subtitle;
    }
    
    return self;
}

@end

