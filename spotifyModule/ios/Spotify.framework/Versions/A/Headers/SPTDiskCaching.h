/*
 Copyright 2015 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>

/**
 * @brief Size of blocks of data handled by the disk cache.
 */
FOUNDATION_EXPORT const NSUInteger SPTDiskCacheBlockSize;

/**
 * @brief The `SPTCacheData` protocol is implemented by classes representing Spotify data that are to be cached to persistent storage.
 */
@protocol SPTCacheData <NSObject>

/**
 * @brief The unique identifier for the cached object.
 */
@property (nonatomic, copy) NSString *itemID;

/**
 * @brief The offset of the cached object.
 * @note This is always a multiple of `SPTDiskCacheBlockSize`.
 */
@property (nonatomic) NSUInteger offset;

/**
 * @brief The data of the cached object.
 */
@property (nonatomic, copy) NSData *data;

/**
 * @brief The total size of the cached object.
 */
@property (nonatomic) NSUInteger totalSize;

@end




/**
 * @brief The `SPTDiskCaching` protocol is implemented by classes that handle caching of Spotify data to persistent storage.
 */
@protocol SPTDiskCaching <NSObject>


- (id <SPTCacheData>)readCacheDataWithKey:(NSString*)key
                                   length:(NSUInteger)length
                                   offset:(NSUInteger)offset;

- (BOOL)writeCacheData:(id <SPTCacheData>)cacheData;

@end



