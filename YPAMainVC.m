//
//  YPAMainVC.m
//  YelpApp
//
//  Created by Savitha Reddy on 8/26/14.
//  Copyright (c) 2014 Savitha. All rights reserved.
//

#import "YPAMainVC.h"
#import  <SpeechKit/SpeechKit.h>
#import "YPAAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import  <AVFoundation/AVFoundation.h>
//#import "YPATableCustomVC.h"
#import <QuartzCore/QuartzCore.h>
#import "YPAYelpRequest.h"
#import "YPATableViewCell.h"


@interface YPAMainVC () <SpeechKitDelegate,SKRecognizerDelegate,CLLocationManagerDelegate,YPAYelpRequestDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic) SKRecognizer *SpeechRecognizer;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end

const unsigned char SpeechKitApplicationKey[] = {0x99, 0x0a, 0x08, 0xc4, 0xbb, 0xed, 0x3b, 0xa9, 0x13, 0xae, 0x9d, 0xa8, 0x48, 0x19, 0x00, 0xe8, 0x27, 0x6c, 0x3e, 0x0d, 0x4a, 0x64, 0x1e, 0x15, 0xc3, 0xfe, 0xc8, 0x87, 0x91, 0xdb, 0x0d, 0x2b, 0xe6, 0x15, 0xef, 0xa1, 0x02, 0x2b, 0x4a, 0x15, 0xd9, 0xe8, 0xbd, 0x21, 0x01, 0xbe, 0x0a, 0x28, 0x2a, 0x48, 0x36, 0x74, 0xad, 0x54, 0x89, 0x70, 0x52, 0x51, 0xf8, 0xe4, 0x2d, 0x05, 0x0f, 0x13};

@implementation YPAMainVC
{
      UITextField *textConvert;
    UIButton *micButton;
    UILabel *recordText;
    CLLocationManager *lManager;
       CLLocation *currentLocation;
//    YPATableCustomVC *customTable;
    YPAYelpRequest *yelpRequest;
    UITableView *customTableView;
    NSArray *tableArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
//        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:0.2];
        self.view.backgroundColor = [UIColor clearColor];
        self.navigationItem.title = @"Nearby Restaurants";
        textConvert = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 240, 40)];
        textConvert.borderStyle = UIBarButtonItemStyleDone;
//        textConvert.layer.borderColor = [UIColor redColor].CGColor;
        textConvert.layer.cornerRadius = 3;
        textConvert.backgroundColor = [UIColor clearColor];
//        textConvert.backgroundColor = [UIColor lightGrayColor];
//        textConvert.alpha = 0.5;
        textConvert.delegate = self;
        [self.view addSubview:textConvert];
        
        micButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 80, 40, 40)];
//        micButton.layer.cornerRadius = 20;
//        micButton.backgroundColor = [UIColor lightGrayColor];
//        [micButton setBackgroundImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        [micButton setImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        [micButton addTarget:self action:@selector(startRecording:) forControlEvents:UIControlEventTouchUpInside];
//        [micButton sizeToFit];
        [self.view addSubview:micButton];
        
        recordText = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH-20, 30)];
        recordText.text = @"Tap mic to start recording";
        [recordText setFont: [UIFont fontWithName:@"Arial" size:12]];
        recordText.textColor = [UIColor darkGrayColor];
        recordText.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:recordText];
        
            lManager = [[CLLocationManager alloc] init];
        lManager.delegate = self;
        [lManager startUpdatingLocation];
        
           customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 320, SCREEN_HEIGHT-160) style:UITableViewStylePlain];
//        customTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Yelp_Background.jpg"]];
        customTableView.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.0];
//        customTableView.alpha = 0.2;
        customTableView.delegate = self;
        customTableView.dataSource = self;
        customTableView.rowHeight = 65;
        
        
        customTableView.separatorColor = [UIColor clearColor];
        customTableView.sectionFooterHeight = 22;
        customTableView.sectionHeaderHeight = 22;
        customTableView.scrollEnabled = YES;
        customTableView.showsVerticalScrollIndicator = YES;
        //        customTableView.userInteractionEnabled = YES;
        customTableView.bounces = YES;
        [self.view addSubview:customTableView];

       
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       YPATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[YPATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    //    cell.textLabel.text = tableArray[indexPath.row];
    cell.info = tableArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewCtrl = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] init];
    viewCtrl.view = webView;
    [self.navigationController pushViewController:viewCtrl animated:YES];
//    NSLog(@"url in mainVC is %@",[tableArray valueForKey:@"yelp"]);
    NSDictionary *mainDict = tableArray[indexPath.row];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mainDict[@"yelp"]]]];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation= [locations firstObject];
//    NSLog(@"current location is %@",currentLocation);
    [lManager stopUpdatingLocation];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   self.activityIndicator.hidden = YES;
    YPAAppDelegate *appDel  = [UIApplication sharedApplication].delegate;
    [appDel setupSpeechKitConnection];
    textConvert.returnKeyType = UIReturnKeySearch;
    
//    customTable = [[YPATableCustomVC alloc] init];
//    customTable.view.frame = CGRectMake(0, 160, SCREEN_WIDTH, SCREEN_HEIGHT-160);
//    [self.view addSubview:customTable.view];
}

-(void) startRecording : (UIButton *) sender
{
    
    NSLog(@" Recording started ");
    sender.selected = !sender.selected;
    textConvert.text = @"";
    if ([sender isSelected]) {
        self.SpeechRecognizer = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType detection:SKShortEndOfSpeechDetection language:@"en_US" delegate:self];
    }else if (self.SpeechRecognizer)
    {
        [self.SpeechRecognizer stopRecording];
        [self.SpeechRecognizer cancel];
    }
    
}

-(void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    recordText.text = @"Listening ..";
}

-(void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    recordText.text = @"Done Listening ..";
}

-(void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    long numberOfResults = [results.results count];
    if (numberOfResults > 0) {
        textConvert.text = [results firstResult];
    }
    micButton.selected = !micButton.selected;
    NSString *yelpSearchString = [self getYelpCategoryFromSearchText];
    [self findNearbyRestaurantsWithYelp:yelpSearchString];
    
    if (self.SpeechRecognizer) {
        [self.SpeechRecognizer cancel];
    }
    recordText.text = @"Tap mic to start recording";
    
}

-(void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    micButton.selected = NO;
    self.activityIndicator.hidden = YES;
    recordText.text = @"Connection Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(NSString *) getYelpCategoryFromSearchText
{
    NSString *categoryFilter;
    if ([[textConvert.text componentsSeparatedByString:@"restaurant"] count] > 1) {
        NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSArray *trimmedWordArray =  [[[textConvert.text componentsSeparatedByString:@"restaurant"] firstObject] componentsSeparatedByCharactersInSet:separator];
        if ([trimmedWordArray count] > 2) {
            int objectIndex = (int) [trimmedWordArray count] -2;
            categoryFilter = [trimmedWordArray objectAtIndex:objectIndex];
        }else{
            categoryFilter = [trimmedWordArray objectAtIndex:0];
        }
    }else if (([[textConvert.text componentsSeparatedByString:@"restaurant"] count] <=1)  && textConvert.text && textConvert.text.length > 0)
    {
        categoryFilter = textConvert.text;
    }
    return categoryFilter;
}

-(void) findNearbyRestaurantsWithYelp : (NSString *) categoryFilter
{
    if (categoryFilter && categoryFilter.length > 0) {
        if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) && currentLocation && currentLocation.coordinate.latitude)
    {
        recordText.text = @" Fetching results..";
        self.activityIndicator.hidden = NO;
        
        yelpRequest = [[YPAYelpRequest alloc] init];
        yelpRequest.delegate = self;
        [yelpRequest searchYelpNearbyPlaces:[categoryFilter lowercaseString]  atLatitude:currentLocation.coordinate.latitude atLongitude:currentLocation.coordinate.longitude];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is Disabled"
                                                            message:@"Enable it in settings and try again"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

-(void)loadResultWithDataArray:(NSArray *)dataArray
{
     recordText.text = @" Tap on the mic";
    self.activityIndicator.hidden = YES;
    
    tableArray = [dataArray mutableCopy];
    [customTableView reloadData];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
