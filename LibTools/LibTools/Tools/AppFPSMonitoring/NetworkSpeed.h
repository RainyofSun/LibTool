//
//  NetworkSpeed.h
//  OpenCVDemo
//
//  Created by 刘冉 on 2017/8/23.
//  Copyright © 2017年 刘冉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger,NetWorkingType) {
    NetWorkingType_WIFI,
    NetWorkingType_WWAN,
    NetWorkingType_NotKnown
};

@interface NetworkSpeed : NSObject

/**
*  @{@"received":@"100kB/s"}
*/
FOUNDATION_EXTERN NSString *const kNetworkReceivedSpeedNotification;

/**
*  @{@"send":@"100kB/s"}
*/
FOUNDATION_EXTERN NSString *const kNetworkSendSpeedNotification;

@property (nonatomic, copy, readonly) NSString * receivedNetworkSpeed;

@property (nonatomic, copy, readonly) NSString * sendNetworkSpeed;

+ (instancetype)shareNetworkSpeed;

- (void)startMonitoringNetworkSpeed;

- (void)stopMonitoringNetworkSpeed;

- (NetWorkingType)getInterfaceType;

@end
