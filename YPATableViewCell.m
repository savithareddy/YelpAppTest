//
//  YPATableViewCell.m
//  YelpApp
//
//  Created by Savitha Reddy on 8/27/14.
//  Copyright (c) 2014 Savitha. All rights reserved.
//

#import "YPATableViewCell.h"

@implementation YPATableViewCell
{
    UIImageView *restaurantImage;
    UILabel *restaurantName;
    UILabel *restaurantCategory;
    UIImageView *restaurantRating;
    UILabel *restaurantAddress;
    UIImageView *frontArrow;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 60)];
//        viewCell.backgroundColor = [UIColor lightGrayColor];
//        viewCell.alpha = 0.5;
        viewCell.layer.cornerRadius = 5;
        [self.contentView addSubview:viewCell];
        
        restaurantImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
//        restaurantImage.layer.cornerRadius = 27.5;
//        restaurantImage.image = [UIImage imageNamed:@"mic"];
        restaurantImage.clipsToBounds = YES;
        [viewCell addSubview:restaurantImage];
        
        restaurantName = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 200, 15)];
        [restaurantName setFont:[UIFont fontWithName:@"Arial" size:15.0f]];
        restaurantName.textColor = [UIColor blueColor];
//        restaurantName.text = @"Restaurant";
        [viewCell addSubview:restaurantName];
        
        restaurantAddress = [[UILabel alloc] initWithFrame:CGRectMake(65, 21, 200, 12)];
        [restaurantAddress setFont:[UIFont fontWithName:@"Arial" size:9]];
        restaurantAddress.textColor = [UIColor blackColor];
        //        restaurantAddress.text = @"100 Ashwood";
        //        venuePlace.adjustsFontSizeToFitWidth=YES;
        [viewCell addSubview:restaurantAddress];

        
        restaurantCategory = [[UILabel alloc] initWithFrame:CGRectMake(60, 34, 200, 12)];
        [restaurantCategory setFont:[UIFont fontWithName:@"Arial" size:9]];
        restaurantCategory.textColor = [UIColor orangeColor];
        //        restaurantName.text = @"Restaurant";
        [viewCell addSubview:restaurantCategory];
        
        restaurantRating = [[UIImageView alloc] initWithFrame:CGRectMake(65, 47, 50, 12)];
//        [restaurantRating setFont:[UIFont fontWithName:@"Arial" size:9]];
        //        venuePlace.adjustsFontSizeToFitWidth=YES;
//        restaurantRating.text = @"5 star";
//        restaurantRating.clipsToBounds = YES;
        [viewCell addSubview:restaurantRating];
        
        
        frontArrow = [[UIImageView alloc] initWithFrame:CGRectMake(270, 25, 20, 20)];
        frontArrow.clipsToBounds = YES;
        frontArrow.image = [UIImage imageNamed:@"arrow"];
//        [viewCell addSubview:frontArrow];
        
    }
    return self;
}

-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    NSLog(@"dictionary in the cell is %@",info);
    
    NSURL *url = [NSURL URLWithString:info[@"image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    restaurantImage.image = image;
    
    restaurantName.text = info[@"name"];
    
   NSString *stringAddress = info[@"category"];
    NSString *stringAddressOne = [stringAddress stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    restaurantCategory.text = stringAddressOne;
    
    NSURL *url1 = [NSURL URLWithString:info[@"rating"]];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    UIImage *image1 = [UIImage imageWithData:data1];
    restaurantRating.image= image1;
    
    NSString *string = info[@"address"];
    NSLog(@"address string in the cell is %@",string);
//     NSString *resultString = [[string stringByReplacingOccurrencesOfString:@"(" withString:@"" ] stringByReplacingOccurrencesOfString:@")" withString:@""];
//    NSLog(@"address result string is %@",resultString);
    restaurantAddress.text = string;

    
}
                                 
  
- (void)awakeFromNib
{
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
