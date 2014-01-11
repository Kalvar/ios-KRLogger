## Screen Shot

<img src="https://dl.dropbox.com/u/83663874/GitHubs/KRLogger-1.png" alt="KRLogger" title="KRLogger" style="margin: 20px;" class="center" /> &nbsp;

## How To Get Started

KRLogger can fast save and log the string, try to think one, if you wanna async-logging some message in log when you're processing another working that you can use KRLogger to easy async-logging.

``` objective-c
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
```

## Version

KRLogger now is V0.5 beta.

## License

KRLogger is available under the MIT license ( or Whatever you wanna do ). See the LICENSE file for more info.
