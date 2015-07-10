//
//  main.m
//  HappyRealmWrite
//
//  Created by Veight Zhou on 7/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>
#import "MyRlmObject.h"
#import "RLMRealm+WriteBlock.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        MyRlmObject *myRealmObject = [[MyRlmObject alloc] init];
        myRealmObject.title = @"first";
    
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm write:^{
            [realm deleteAllObjects];
        }];
        
        [realm write:^{
            [realm addObject:myRealmObject];
        } completion:^{
            RLMResults *results = [MyRlmObject allObjects];
            NSLog(@"current object counts: %@", @(results.count));
        }];
        
        [realm writeInBackground:^{
            MyRlmObject *myRealmObject = [[MyRlmObject alloc] init];
            myRealmObject.title = @"two";
            [realm addObject:myRealmObject];
        } completion:^{
            RLMResults *results = [MyRlmObject allObjects];
            NSLog(@"current object counts: %@", @(results.count));
        }];
    }
    return 0;
}
