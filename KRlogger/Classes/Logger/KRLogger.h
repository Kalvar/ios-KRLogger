//
//  Logger.h
//  V0.5 Beta
//
//  Created by Kalvar on 2013/11/10.
//  Copyright (c) 2013年 Kalvar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRLogger : NSObject


@property (nonatomic, strong) id observer;

+(instancetype)sharedManager;
-(void)registerReceivedLogsNotificationWithObserver:(id)_observer selector:(SEL)_selector;
-(void)removeNotifications;
-(void)fireReceivedLogsNotification;
-(void)addLogString:(NSString *)_logString;
-(void)removeLogs;
-(NSMutableArray *)fetchLogs;


@end
