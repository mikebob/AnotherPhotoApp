//
//  FrameChooserViewController.m
//  SmartyPix
//
//  Created by Mike Bobiney on 8/15/11.
//  Copyright 2011 Tap Through Apps LLC. All rights reserved.
//

#import "FrameChooserViewController.h"
#import "FramingViewController.h"

//@synthesize  image, spxframe, tableView;

@implementation FrameChooserViewController {    

}

@synthesize image, spxframe, tableView;
    
- (id)init {
    self = [super init];
    if (self) {
        appDelegate = (SmartyPixAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *tmpArray = [NSArray arrayWithObjects:
       [appDelegate.frameData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isFeatured == YES"]],
       [appDelegate.frameData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(isFeatured == NO) || (isFeatured = nil)"]],
           nil];
    
    sortedFrameList = [[NSArray alloc] initWithArray:tmpArray];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, (480-44)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source

-(void)viewDidAppear:(BOOL)animated
{
    [tableView flashScrollIndicators];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [sortedFrameList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [[sortedFrameList objectAtIndex:section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"New Frames";
    } else {
        return @"Other Frames";    
    }
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    } else {
        [[[cell subviews] objectAtIndex:0] removeFromSuperview];
    }
        
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
//    cell.textLabel.text = [[appDelegate.frameData objectAtIndex:indexPath.row] objectForKey:@"Title"];
//    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];

    NSDictionary *dict = [[sortedFrameList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    NSString *filename = [NSString stringWithFormat:@"%@.png", [dict objectForKey:@"Image"]];
    
    UIImageView *cellBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    cellBackground.frame = CGRectMake(0, 0, 320, 75);
    [cellBackground setContentMode:UIViewContentModeScaleAspectFill];
    [cell insertSubview:cellBackground atIndex:0];
    [cellBackground release];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSDictionary *dict = [[sortedFrameList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSString *filename = [NSString stringWithFormat:@"%@.png", [dict objectForKey:@"Image"]];
    //UIImage *frameImage = [UIImage imageNamed: filename];
    
    spxframe = [[SPXFrame alloc] initWithDictionary:dict andFrame:appDelegate.window.bounds];
    //spxframe = [[SPXFrame alloc] initWithFrame:appDelegate.window.bounds];
//    [spxframe retain];

    FramingViewController *framing = [[FramingViewController alloc] init];
    [framing initWithSPXFrame:spxframe andSelectedImage:image];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Select Again" style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
    
    [self.navigationController pushViewController:framing animated:YES];
    [framing release];
    [spxframe release];
    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:spxframe.imageURL];
//    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
//    [request setDelegate:self];
//    [request startAsynchronous];
	
    //hud.delegate = self;
//    [hud showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    [request setDownloadCache:[ASIDownloadCache sharedCache]];
//	//[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
//    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
//    
//    NSData *responseData = [request responseData];
//    //self.image = [UIImage imageWithData: responseData];
//    UIImage *remoteImg = [UIImage imageWithData: responseData];
//    
//    spxframe.image = remoteImg;
//    
//    
//    //CGSize size = [remoteImg valueForKey:@"size"];
//    
////    if(size.width > size.height){
////        spxframe.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
////    }
//    
//    FramingViewController *framing = [[FramingViewController alloc] init];
//    [framing initWithSPXFrame:spxframe andSelectedImage:image];
//    [self.navigationController pushViewController:framing animated:YES];
//    [framing release];
//}

//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//    NSLog(@"%@", [error description]);
//}


-(void)viewWillAppear:(BOOL)animated
{   
    if ([self.tableView indexPathForSelectedRow] != nil){
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
    self.title = @"Choose a border";
}

//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    spxframe = nil;
//    sortedFrameList = nil;
//}

-(void)dealloc
{
    [sortedFrameList release];
    [tableView release];
    [spxframe release];
    [super dealloc];
}

@end
