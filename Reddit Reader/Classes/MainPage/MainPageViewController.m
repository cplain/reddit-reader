//
//  ViewController.m
//  Reddit Reader
//
//  Created by Coby Plain on 20/06/13.
//  Copyright (c) 2013 seaplain. All rights reserved.
//

#define REDDIT_URL_START @"http://www.reddit.com/r/"
#define REDDIT_URL_END @"/top.json"
#import "MainPageViewController.h"
#import "SBJson.h"

@interface MainPageViewController ()
@property (nonatomic, strong)NSMutableData *responseData;
@end

@implementation MainPageViewController

NSMutableArray *mainDataArray;
NSMutableArray *linkNamesArray;
NSString *subreddit = @"shityaskscience";
UIAlertView *myAlertView;

@synthesize responseData;
@synthesize tableView;
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpLoadingIndicator];}

- (void)viewWillAppear:(BOOL)animated
{
    [self recieveJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpLoadingIndicator
{
    myAlertView = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"\n"
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil, nil];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loading.center = CGPointMake(139.5, 75.5);
    [myAlertView addSubview:loading];
    [loading startAnimating];
}

-(void)recieveJSON
{
    [myAlertView show];
    NSString *url = [NSString stringWithFormat:@"%@%@%@" , REDDIT_URL_START, subreddit, REDDIT_URL_END];
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
    mainDataArray = [[NSMutableArray alloc]init];
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    SBJsonParser *objJson = [[SBJsonParser alloc] init];//
    NSDictionary *data = (NSDictionary*)[objJson objectWithData:self.responseData];
    NSDictionary *secondData = [data valueForKey:@"data"];
    mainDataArray = [secondData valueForKey:@"children"];
    
    NSLog(@"Data: %@", data);
    NSLog(@"Second Data: %@", secondData);
    NSLog(@"Array: %@", mainDataArray);
    
    [self populateList];
}

-(void)populateList
{
    NSDictionary *tempDict;
    linkNamesArray = [NSMutableArray array];
    
    for(int i = 0; i < [mainDataArray count]; i++)
    {
        tempDict = [[mainDataArray objectAtIndex:i]valueForKey:@"data"];
        NSString *title = [tempDict valueForKey:@"title"];
        [linkNamesArray addObject:title];
    }
    
    NSLog(@"linkNamesArray: %@", linkNamesArray);
    [self.tableView reloadData];
    self.title = [NSString stringWithFormat:@"/r/%@", subreddit];
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([linkNamesArray count] == 0)
        [self showRefreshDialog];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [linkNamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    cell.textLabel.text = [linkNamesArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{

}

-(void)showRefreshDialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Looks like we didn't recieve anything from that subreddit"
                                                   delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Retry", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            [self recieveJSON];
            break;
            
        default:
            break;
    }

}

-(IBAction)goToSubreddit:(id)sender
{
    subreddit = self.textView.text;
    [self recieveJSON];
    self.textView.text = @"";
    [self.textView endEditing:YES];
}

@end
