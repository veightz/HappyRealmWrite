//
//  RLMRealm+WriteBlock.m
//  HappyRealmWrite
//
//  Created by Veight Zhou on 7/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "RLMRealm+WriteBlock.h"

static dispatch_queue_t kDefaultBackgroundWriteQueue;
static dispatch_queue_t fetchDefaultBackgroundWriteQueue() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDefaultBackgroundWriteQueue =
        dispatch_queue_create("com.realm.background.write", DISPATCH_QUEUE_SERIAL);
    });
    return kDefaultBackgroundWriteQueue;
}

@implementation RLMRealm (WriteBlock)

- (void)write:(RLMRealmWriteBlock)writeBlock {
    if (writeBlock) {
        [self beginWriteTransaction];
        writeBlock();
        [self commitWriteTransaction];
    }
}

- (void)writeInBackground:(RLMRealmCompletionBlock)writeBlock {
    if (writeBlock) {
        dispatch_async(fetchDefaultBackgroundWriteQueue(), ^{
            [self beginWriteTransaction];
            writeBlock();
            [self commitWriteTransaction];
        });
    }
}

- (void)write:(RLMRealmWriteBlock)writeBlock completion:(RLMRealmCompletionBlock)completionBlock {
    if (writeBlock) {
        [self beginWriteTransaction];
        writeBlock();
        [self commitWriteTransaction];
    }
    if (completionBlock) {
        completionBlock();
    }
}

- (void)writeInBackground:(RLMRealmWriteBlock)writeBlock completion:(RLMRealmCompletionBlock)completionBlock {
    dispatch_apply(1, fetchDefaultBackgroundWriteQueue(), ^(size_t index) {
        if (writeBlock) {
            [self beginWriteTransaction];
            writeBlock();
            [self commitWriteTransaction];
        }
    });
    if (completionBlock) {
        completionBlock();
    }
}

- (void)write:(RLMRealmWriteBlock)writeBlock
      onQueue:(dispatch_queue_t)writeQueue
   completion:(RLMRealmCompletionBlock)completionBlock
      onQueue:(dispatch_queue_t)completionQueue {
    if (writeBlock) {
        dispatch_async(writeQueue, ^{
            [self beginWriteTransaction];
            writeBlock();
            [self commitWriteTransaction];
            
            dispatch_async(completionQueue, ^{
                if (completionBlock) {
                    completionBlock();
                }
            });
        });

    }

}

@end
