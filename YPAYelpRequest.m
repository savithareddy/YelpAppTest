//
//  YPAYelpRequest.m
//  YelpApp
//
//  Created by Savitha Reddy on 8/28/14.
//  Copyright (c) 2014 Savitha. All rights reserved.
//

#define OAUTH_CONSUMER_KEY  @"FPJIAEJ6Sjp1JeN5ugkhiw"
#define OAUTH_CONSUMER_SECRET @"bK9WIXennWrrvoMBR45lvU4FV50"
#define OAUTH_TOKEN @"4EHPM12klJGL25xDiK3en108w3Z-YtEr"
#define OAUTH_TOKEN_SECRET @"-Fd_ERaJBthG_bh7ANuN7Y60PKg"
#define YELP_SEARCH_URL @"http://api.yelp.com/v2/search"

#import "YPAYelpRequest.h"
#import "OAConsumer.h"
#import "OAToken.h"
#import "OASignatureProviding.h"
#import "OAHMAC_SHA1SignatureProvider.h"
#import "OAMutableURLRequest.h"
//#import  "Restaurant.h"

@implementation YPAYelpRequest
{
    NSMutableData *urlRespondData;
    NSMutableArray *array;
    NSMutableDictionary *finalDict;
}

-(void)searchYelpNearbyPlaces:(NSString *)categoryFilter atLatitude:(CLLocationDegrees)currentLatitude atLongitude:(CLLocationDegrees)currentLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"%@?term=%@&categoty_filter=%@,Indian&ll=%f,%f",YELP_SEARCH_URL,@"food",categoryFilter,currentLatitude,currentLongitude];
    

    NSURL *url = [NSURL URLWithString:urlString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_CONSUMER_KEY secret:OAUTH_CONSUMER_SECRET];
    OAToken *token = [[OAToken alloc] initWithKey:OAUTH_TOKEN secret:OAUTH_TOKEN_SECRET];
    
  id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
    NSString *realm = nil;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:token realm:realm signatureProvider:provider];
    
    [request prepare];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        urlRespondData = [NSMutableData data];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [urlRespondData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [urlRespondData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Failed to connect to speech server"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *e = nil;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlRespondData options:NSJSONReadingMutableContainers error:&e];
    
//    NSLog(@"dict is %@",dict);
    
    if (array && [array count] > 0 ) {
        [array removeAllObjects];
    }
    
    if (!array) {
        array = [[NSMutableArray alloc] init];
    }
    
    
    
    if (dict && [dict count] > 0 ) {
        if ([dict objectForKey:@"businesses"] && [[dict objectForKey:@"businesses"] count] > 0) {
            for (NSDictionary *dictionary in [dict objectForKey:@"businesses"]) {
                
                NSString *name =  dictionary[@"name"];
                NSString *thumbURL = dictionary[@"image_url"];
                NSString *ratingURL = dictionary[@"rating_img_url"];
                NSString *yelpURL = dictionary[@"url"];
                
                NSString *addressString1 = [dictionary[@"location"][@"display_address"] componentsJoinedByString:@","];
                NSString *cate = [dictionary[@"categories"]componentsJoinedByString:@","];
                NSCharacterSet *deLimiters = [NSCharacterSet characterSetWithCharactersInString:@"\"()\n"];
                NSString *splitString = [cate stringByTrimmingCharactersInSet:deLimiters];
//                NSString *categoryString = [splitString objectAtIndex:1];
//                NSLog(@"String is %@",splitString);
//                NSString *joinString = [NSString stringWithFormat:@"%@,%@",addressString1,addressString2];
                
               
                finalDict = [[NSMutableDictionary alloc] init];
                [finalDict setObject:name forKey:@"name"];
                 [finalDict setObject:thumbURL forKey:@"image"];
                 [finalDict setObject:ratingURL forKey:@"rating"];
                [finalDict setObject:yelpURL forKey:@"yelp"];
                 [finalDict setObject:addressString1 forKey:@"address"];
                [finalDict setObject:splitString forKey:@"category"];
                
                [array addObject:finalDict];
                NSLog(@"Array at the yelp is %@ ",array);
                
                }
               }
           }
    
        [self.delegate loadResultWithDataArray:array];
}









































@end
