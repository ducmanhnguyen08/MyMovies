////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class RLMArray, RLMObjectBase, RLMResults, RLMProperty;

NS_ASSUME_NONNULL_BEGIN

// A base class for Swift generic Lists to make it possible to interact with
// them from obj-c
@interface RLMListBase : NSObject <NSFastEnumeration>
@property (nonatomic, strong) RLMArray *_rlmArray;

- (instancetype)init;
- (instancetype)initWithArray:(RLMArray *)array;
@end

@interface RLMLinkingObjectsHandle : NSObject
- (instancetype)initWithObject:(RLMObjectBase *)object property:(RLMProperty *)property;

@property (nonatomic, readonly) RLMResults *results;
@property (nonatomic, readonly) RLMObjectBase *parent;
@property (nonatomic, readonly) RLMProperty *property;
@end

NS_ASSUME_NONNULL_END
