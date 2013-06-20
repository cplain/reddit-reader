//
//  ViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#define REDDIT_URL @"http://www.reddit.com"
#define SPECIFIC_SUBREDDIT_URL @"/r/shittyaskscience/top.json"
#import "MainPageViewController.h"

@interface MainPageViewController ()
@property (nonatomic, strong)NSMutableData *responseData;
@end

@implementation MainPageViewController

NSMutableArray *mainDataArray;
@synthesize responseData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self recieveJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)recieveJSON
{
    NSString *url = [NSString stringWithFormat:@"%@%@" , REDDIT_URL, SPECIFIC_SUBREDDIT_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData: %@", data);
    self.responseData = [[NSMutableData alloc] initWithData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    mainDataArray = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSLog(@"Array: %@",mainDataArray);
}

@end
