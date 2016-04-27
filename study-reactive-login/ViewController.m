//
//  ViewController.m
//  study-reactive-login
//
//  Created by 熊 春雷 on 16/4/15.
//  Copyright © 2016年 pandaxcl. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

@interface NSXMLParser(StudyReactiveNetworking)
@property NSString* studyComment;
@end

@implementation NSXMLParser (StudyReactiveNetworking)

static void*kStudyReactiveNetworkingComment = &kStudyReactiveNetworkingComment;
-(NSString*)studyComment
{
    return (NSString *)objc_getAssociatedObject(self, kStudyReactiveNetworkingComment);
}

-(void)setStudyComment:(NSString *)studyComment
{
    objc_setAssociatedObject(self, kStudyReactiveNetworkingComment, studyComment, OBJC_ASSOCIATION_COPY);
}

@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer new];
    
    NSSet*contentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    
    RACSignal*signalCSDN = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [manager.requestSerializer setTimeoutInterval:2];
        [manager GET:@"http://www.csdn.net" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [(NSXMLParser*)responseObject setStudyComment:@"http://www.csdn.net"];
            NSLog(@"responseObject = %@, studyComment = %@", responseObject, [(NSXMLParser*)responseObject studyComment]);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"         error = %@", error);
            [subscriber sendError:error];
        }];
        return nil;
    }];
    RACSignal*signalNEWS = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [manager.requestSerializer setTimeoutInterval:5];
        [manager GET:@"http://www.news.cn" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [(NSXMLParser*)responseObject setStudyComment:@"http://www.news.cn"];
            NSLog(@"responseObject = %@, studyComment = %@", responseObject, [(NSXMLParser*)responseObject studyComment]);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"         error = %@", error);
            [subscriber sendError:error];
        }];
        return nil;
    }];
    RACSignal*signal163 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [manager.requestSerializer setTimeoutInterval:60];
        [manager GET:@"http://www.163.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [(NSXMLParser*)responseObject setStudyComment:@"http://www.163.com"];
            NSLog(@"responseObject = %@, studyComment = %@", responseObject, [(NSXMLParser*)responseObject studyComment]);
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"         error = %@", error);
            [subscriber sendError:error];
        }];
        return nil;
    }];
    if(0)
    {
        RACSignal*signal = [[signalCSDN catchTo:signalNEWS] catchTo:signal163];
        
        
        
        [[signal subscribeOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id x) {
            NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
        }];
        
        NSLog(@"==========================================================================================");
        
        [[signal subscribeOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
         }];
        
        NSLog(@"==========================================================================================");
        
        [[signal subscribeOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
         }];
    }
    if(1)
    {
        RACMulticastConnection*mConnection = [[[signalCSDN catchTo:signalNEWS] catchTo:signal163] publish];
        
        //RACMulticastConnection*mConnection = [[RACSignal amb:@[signalCSDN, signalNEWS, signal163] publish];
        
        [[[mConnection.signal subscribeOn:[RACScheduler mainThreadScheduler]] logAll]
         subscribeNext:^(id x) {
             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
         }];
        
        [[mConnection.signal subscribeOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
         }];
        
        [[mConnection.signal subscribeOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id x) {
             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
         }];
        
        [mConnection connect];
        
//        [[[mConnection.signal subscribeOn:[RACScheduler mainThreadScheduler]] logAll]
//         subscribeNext:^(id x) {
//             NSLog(@"subscribeNext x = %@, studyComment = %@", x, [(NSXMLParser*)x studyComment]);
//         }];
//        
//        [mConnection connect];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
