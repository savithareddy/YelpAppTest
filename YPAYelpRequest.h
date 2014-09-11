//
//  YPAYelpRequest.h
//  YelpApp
//
//  Created by Savitha Reddy on 8/28/14.
//  Copyright (c) 2014 Savitha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CoreLocation/CoreLocation.h>

@protocol YPAYelpRequestDelegate <NSObject>

-(void) loadResultWithDataArray : (NSArray *) dataArray;

@end

@interface YPAYelpRequest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic) id <YPAYelpRequestDelegate> delegate;

//@property (nonatomic) NSString  *categoryFilter;
//@property (nonatomic) CLLocationDegrees currentLatitude;
//@property (nonatomic) CLLocationDegrees currentLongitude;

-(void) searchYelpNearbyPlaces : (NSString *) categoryFilter atLatitude:(CLLocationDegrees)currentLatitude atLongitude:(CLLocationDegrees)currentLongitude;

@end
