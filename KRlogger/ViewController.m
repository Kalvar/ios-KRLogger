//
//  ViewController.m
//  KRlogger
//
//  Created by Kalvar on 2014/1/10.
//  Copyright (c) 2014年 Kalvar. All rights reserved.
//

#import "ViewController.h"
#import "KRLogger.h"

@interface ViewController ()

@property (nonatomic, strong) KRLogger *_krLogger;

@end

@implementation ViewController

@synthesize outTextView = _outTextView;
@synthesize _krLogger;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_outTextView setEditable:NO];
    _krLogger = [KRLogger sharedManager];
    [_krLogger registerReceivedLogsNotificationWithObserver:self selector:@selector(receivedChanges:)];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_krLogger removeNotifications];
}

#pragma --mark Logger Usage
-(IBAction)clean:(id)sender
{
    [_outTextView setText:@""];
    if ([_outTextView isFirstResponder])
    {
        [_outTextView resignFirstResponder];
    }
    [_krLogger removeLogs];
}

-(IBAction)reload:(id)sender
{
    [_krLogger fireReceivedLogsNotification];
}

-(IBAction)addNew:(id)sender
{
    [_krLogger addLogString:@"Hello World !"];
    [_krLogger fireReceivedLogsNotification];
}

-(void)receivedChanges:(NSNotification *)_notification
{
    NSMutableArray *_logs = [_notification object];
    if( [_logs isKindOfClass:[NSMutableArray class]] )
    {
        NSMutableString *_strings = [[NSMutableString alloc] initWithString:@""];
        [_logs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            NSString *_logString = (NSString *)obj;
            [_strings appendFormat:@"%i) %@ \n", (idx + 1), _logString];
        }];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [_outTextView setText:_strings];
        });
        _strings = nil;
    }
}

@end
