//
//  Logger.m
//  V0.5 Beta
//
//  Created by Kalvar on 2013/11/10.
//  Copyright (c) 2013年 Kalvar. All rights reserved.
//

#import "KRLogger.h"

static NSString *_kKRLoggerReceivedLogsNotification = @"_kKRLoggerReceivedLogsNotification";

@implementation KRLogger (fixNSNotifications)

-(void)_registerNotificationWithObserver:(id)_observer selector:(SEL)_selector forKey:(NSString *)_key withObject:(id)_object
{
    [[NSNotificationCenter defaultCenter] addObserver:_observer
                                             selector:_selector
                                                 name:_key
                                               object:_object];
}

-(void)_unregisterNotificationWithObserver:(id)_observer forKey:(NSString *)_key
{
    [[NSNotificationCenter defaultCenter] removeObserver:_observer name:_key object:nil];
}


@end

@implementation KRLogger (fixNSUserDefaults)

/*
 * @ 取出萬用型態
 */
-(id)_defaultValueForKey:(NSString *)_key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:_key];
}

/*
 * @ 儲存萬用型態
 */
-(void)_saveDefaultValue:(id)_value forKey:(NSString *)_forKey
{
    [[NSUserDefaults standardUserDefaults] setObject:_value forKey:_forKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)_removeDefaultValueForKey:(NSString *)_key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation KRLogger

@synthesize observer;

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static KRLogger *_object = nil;
    dispatch_once(&pred, ^{
        _object = [[KRLogger alloc] init];
    });
    return _object;
}

-(void)registerReceivedLogsNotificationWithObserver:(id)_observer selector:(SEL)_selector
{
    self.observer = _observer;
    [self _registerNotificationWithObserver:_observer selector:_selector forKey:_kKRLoggerReceivedLogsNotification withObject:nil];
}

-(void)removeNotifications
{
    [self _unregisterNotificationWithObserver:self.observer forKey:_kKRLoggerReceivedLogsNotification];
}

-(void)fireReceivedLogsNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:_kKRLoggerReceivedLogsNotification object:[self fetchLogs]];
}

-(void)addLogString:(NSString *)_logString
{
    //使用陣列儲存 Log String
    NSMutableArray *_logs = [self fetchLogs];
    if( !_logs )
    {
        _logs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_logs addObject:_logString];
    [self _saveDefaultValue:_logs forKey:_kKRLoggerReceivedLogsNotification];
}

-(void)removeLogs
{
    [self _removeDefaultValueForKey:_kKRLoggerReceivedLogsNotification];
}

-(NSMutableArray *)fetchLogs
{
    NSMutableArray *_logs = [self _defaultValueForKey:_kKRLoggerReceivedLogsNotification];
    if( ![_logs isKindOfClass:[NSMutableArray class]] || !_logs )
    {
        return nil;
    }
    return [NSMutableArray arrayWithArray:_logs];
}

@end
