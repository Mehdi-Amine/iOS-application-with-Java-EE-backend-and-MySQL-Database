//
//  Annotation.h
//  Capp
//
//  Created by Mehdi Amine on 3/24/16.
//  Copyright © 2016 Mehdi Amine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinate title:(NSString *)title subtitle:(NSString *)subtitle;

@end
