//
//  RLMRealm+WriteBlock.h
//  HappyRealmWrite
//
//  Created by Veight Zhou on 7/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "RLMRealm.h"

typedef void(^RLMRealmWriteBlock)(void);
typedef void(^RLMRealmCompletionBlock)(void);
@interface RLMRealm (WriteBlock)

- (void)write:(RLMRealmWriteBlock)writeBlock;

- (void)writeInBackground:(RLMRealmCompletionBlock)writeBlock;

- (void)write:(RLMRealmWriteBlock)writeBlock
   completion:(RLMRealmCompletionBlock)completionBlock;

- (void)writeInBackground:(RLMRealmWriteBlock)writeBlock
               completion:(RLMRealmCompletionBlock)completionBlock;

- (void)write:(RLMRealmWriteBlock)writeBlock
      onQueue:(dispatch_queue_t)writeQueue
   completion:(RLMRealmCompletionBlock)completionBlock
      onQueue:(dispatch_queue_t)completionQueue;

@end
