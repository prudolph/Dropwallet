//
//  RootHelpViewController.m
//  DropWallet
//
//  Created by Paul Rudolph on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootHelpViewController.h"



@implementation RootHelpViewController
@synthesize helpDetail;
@synthesize helpTableView;
@synthesize helpStrings;
@synthesize helpQsArray,helpAnsDict;
@synthesize headerLabelTitle;
@synthesize appDel;

static const CGFloat fontSize = 16.0f;
static const NSString * bodyfont=@"ArialMT";
static const NSString *titlefont =@"Arial-BoldMT";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view = helpTableView;
       helpDetail=-1;
        
        self.title=@"Help";
     
        self.appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // load Strings from file
  helpStrings= [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Help" ofType:@"plist"]]; 

    helpQsArray = [[NSArray alloc]initWithObjects:[helpStrings objectForKey:@"*Gen_Q"],
                                                [helpStrings objectForKey:@"*Acct_Q"],
                                                [helpStrings objectForKey:@"*Order_Q"],
                                                [helpStrings objectForKey:@"*Ship_Q"],
                                                [helpStrings objectForKey:@"*Bill_Q"],
                                                [helpStrings objectForKey:@"*Return_Q"],
                                                [helpStrings objectForKey:@"*Support"], nil ];

    helpAnsDict = [[NSMutableDictionary alloc]init];
    for( int i=0; i<[helpStrings count];i++){
        if([((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"*"].location == NSNotFound) {
            switch (helpDetail) {
                case 0:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"GEN-"].location != NSNotFound ){
                            [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                            forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                
                case 1:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"ACT-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                case 2:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"ORD-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                case 3:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"SHI-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                case 4:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"BIL-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                case 5:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"RET-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                case 6:{
                    if( [((NSString*)[[helpStrings allKeys]objectAtIndex:i])  rangeOfString:@"SUP-"].location != NSNotFound ){
                        [helpAnsDict setObject:[[helpStrings allValues]objectAtIndex:i] 
                                        forKey:[[helpStrings allKeys]objectAtIndex:i]];
                    }break;
                }
                    
                default:
                    break;
                }
            
                   }
    }
    

}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar addSubview:appDel.logoImgView];
    if(helpDetail>=0){
        [appDel.logoImgView setHidden:YES];
    }
    else
    [appDel.logoImgView setHidden:NO];
    self.navigationController.navigationBar.topItem.title=@"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma Mark - UItableview Delegate
//header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

if(section==0){
    UILabel *headerLabel=[[UILabel alloc]init];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
    [headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
    headerLabel.frame=CGRectMake(60, 7.0, 200, 40);
    if([headerLabelTitle length]==0)
        [headerLabel setText:@"Help"]; 
    else
    [headerLabel setText:headerLabelTitle];  
      
    UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HeaderImage.png"]];
    headerView.frame=CGRectMake(0, 0, 320.00, 34.0);
    [headerView addSubview:headerLabel ];
    
    return headerView;
}
else return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(helpDetail>=0){
        CGSize titleNBody= [self findCellHeightFromTitle:[((NSString *)[[helpAnsDict allKeys] objectAtIndex:[indexPath row]]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] 
                                                 andBody:[((NSString *)[[helpAnsDict allValues] objectAtIndex:[indexPath row]]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        
        
        NSArray *heightOverride=  [[((NSString*)[[helpAnsDict allKeys]objectAtIndex:[indexPath row]])substringWithRange:NSMakeRange(5, 7)] componentsSeparatedByString:@"," ];
        
        
        if([[heightOverride objectAtIndex:0] intValue]!=0)
            titleNBody.width=[[heightOverride objectAtIndex:0] intValue];
        
        if([[heightOverride objectAtIndex:1] intValue]!=0)
            titleNBody.height=[[heightOverride objectAtIndex:1] intValue];
        
        return  titleNBody.width+titleNBody.height+30;
                
    }
    else
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(helpDetail<0)
    return [helpQsArray count];
    else 
    return [helpAnsDict count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(helpDetail<0){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        NSUInteger row = [indexPath row];

        cell.textLabel.backgroundColor=[UIColor clearColor];
        UIImageView *accountSettingBG = [[UIImageView alloc]initWithImage:
                                         [UIImage imageNamed:@"AccountButtonsBG.png"]];
        [accountSettingBG setBackgroundColor:[UIColor redColor]];
        cell.backgroundView=accountSettingBG;

        cell.textLabel.text = [helpQsArray objectAtIndex:row];
        [cell.textLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:0/255 green:170.0/255 blue:235.0/255 alpha:1.0]];

        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSUInteger row = [indexPath row];
      

     
        [[cell viewWithTag:0]removeFromSuperview];
        [[cell viewWithTag:1]removeFromSuperview];
        [[cell viewWithTag:2]removeFromSuperview];
        
        CGSize titleBodyHeight=[self findCellHeightFromTitle:[((NSString *)[[helpAnsDict allKeys] objectAtIndex:[indexPath row]]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] 
                                                     andBody:[((NSString *)[[helpAnsDict allValues] objectAtIndex:[indexPath row]]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
      
        NSArray *heightOverride=  [[((NSString*)[[helpAnsDict allKeys]objectAtIndex:row])substringWithRange:NSMakeRange(5, 7)] componentsSeparatedByString:@"," ];
        
        if([[heightOverride objectAtIndex:0] intValue]!=0)
          titleBodyHeight.width=[[heightOverride objectAtIndex:0] intValue];
        
        if([[heightOverride objectAtIndex:1] intValue]!=0)
            titleBodyHeight.height=[[heightOverride objectAtIndex:1] intValue];
      
      UIView *FAQcell = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, 300, titleBodyHeight.width+titleBodyHeight.height+10)];
        FAQcell.backgroundColor = [UIColor clearColor];
        FAQcell.userInteractionEnabled=NO;
        FAQcell.tag=0;
        UITextView *title=[[UITextView alloc]initWithFrame:CGRectMake(5, 0, 300.0f, titleBodyHeight.width+10)];
              title.textColor =[UIColor colorWithRed:0/255 green:170.0/255 blue:235.0/255 alpha:1.0];
        title.font = [UIFont fontWithName:titlefont size:fontSize];
        title.text=[((NSString*)[[helpAnsDict allKeys]objectAtIndex:row])substringFromIndex:13];
        title.backgroundColor = [UIColor clearColor];
        title.tag=1;
      
         
        UITextView *body = [[UITextView alloc]initWithFrame:CGRectMake(5, titleBodyHeight.width, 300.0f, titleBodyHeight.height+50)];
        [body setDelegate:self];
        [body setEditable:NO];
        [body setDataDetectorTypes:UIDataDetectorTypeAll];
              [body setUserInteractionEnabled:YES];
        [body setContentInset:UIEdgeInsetsMake(0, 0, 5, 0)];
        body.font = [UIFont fontWithName:bodyfont size:fontSize];
        body.text = [[helpAnsDict allValues]objectAtIndex:row];
        body.backgroundColor = [UIColor clearColor];    
        body.tag=2;
        [FAQcell insertSubview:title atIndex:0];
        [FAQcell insertSubview:body atIndex:0];
        [cell addSubview:FAQcell];
    
         
        cell.selectionStyle=UITableViewCellAccessoryNone;
             return cell;

        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(helpDetail<0){
        RootHelpViewController *rootHelpViewController = [[RootHelpViewController alloc]init];
        rootHelpViewController.helpDetail=[indexPath row];
        rootHelpViewController.headerLabelTitle=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self.navigationController action: @selector(popViewControllerAnimated:)];
        [newBackButton setTintColor:[UIColor darkGrayColor]];
        self.navigationItem.backBarButtonItem= newBackButton;
        
        [self.navigationController pushViewController:rootHelpViewController animated:YES];
        [tableView cellForRowAtIndexPath:indexPath].selected=NO;
    }
}


-(CGSize)findCellHeightFromTitle:(NSString*)title andBody:(NSString*)body{
    
  CGFloat titleHeight=  [title sizeWithFont:[UIFont fontWithName:titlefont size:fontSize] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;

    CGFloat bodyHeight=  [body sizeWithFont:[UIFont fontWithName:titlefont size:fontSize] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;

    return  CGSizeMake(titleHeight, bodyHeight);
 }

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"HELLo");
}

@end
