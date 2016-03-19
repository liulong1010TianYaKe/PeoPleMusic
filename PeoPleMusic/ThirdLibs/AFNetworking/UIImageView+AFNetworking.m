// UIImageView+AFNetworking.m
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIImageView+AFNetworking.h"

#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import "AFHTTPRequestOperation.h"

#import <ImageIO/ImageIO.h>

#import <CommonCrypto/CommonDigest.h>

@interface AFImageCache : NSCache

@property (strong, nonatomic) dispatch_queue_t backgroundCacheQueue;

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;

-(void) saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey;

@end

#pragma mark -

static char kAFImageRequestOperationKey;
static char kAFResponseSerializerKey;

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;

@end

@implementation UIImageView (_AFNetworking)

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_sharedImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_sharedImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        _af_sharedImageRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });

    return _af_sharedImageRequestOperationQueue;
}

+ (AFImageCache *)af_sharedImageCache {
    static AFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFImageCache alloc] init];

        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [_af_imageCache removeAllObjects];
        }];
    });

    return _af_imageCache;
}

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationKey);
}

- (void)af_setImageRequestOperation:(AFHTTPRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIImageView (AFNetworking)
@dynamic imageResponseSerializer;

- (id <AFURLResponseSerialization>)imageResponseSerializer {
    static id <AFURLResponseSerialization> _af_defaultImageResponseSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_defaultImageResponseSerializer = [AFImageResponseSerializer serializer];
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, &kAFResponseSerializerKey) ?: _af_defaultImageResponseSerializer;
#pragma clang diagnostic pop
}

- (void)setImageResponseSerializer:(id <AFURLResponseSerialization>)serializer {
    objc_setAssociatedObject(self, &kAFResponseSerializerKey, serializer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    //看看是否图片再内存中
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage)
    {
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }

        self.af_imageRequestOperation = nil;
        return;
    }
    
    //看看是否图片在本地
    NSString *imageUrl = [[urlRequest URL] absoluteString];
    NSString *uniqueId = [UIImageView mkNetworkOperationUniqueIdentifier:imageUrl];
    NSString *filePath = [[UIImageView cacheMKNetworkImageDirectoryName] stringByAppendingPathComponent:uniqueId];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSData *cachedData = [NSData dataWithContentsOfFile:filePath];
        cachedImage = [UIImage imageWithData:cachedData];
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
        
        [[[self class] af_sharedImageCache] cacheImage:cachedImage forRequest:urlRequest]; //缓存图片到内存
        
        self.af_imageRequestOperation = nil;
        return;
    }
    
    
    self.image = placeholderImage;
    
    __weak __typeof(self)weakSelf = self;
    self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
    [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[operation.request URL]]) {
            if (success) {
                success(urlRequest, operation.response, responseObject);
            } else if (responseObject) {
                strongSelf.image = responseObject;
            }
        } else {
            
        }
        
        [[[strongSelf class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest]; //缓存图片到内存
        
        //缓存到本地
        if (![[strongSelf class] af_sharedImageCache].backgroundCacheQueue) {
            [[strongSelf class] af_sharedImageCache].backgroundCacheQueue = dispatch_queue_create("com.mknetworkkit.cachequeue", DISPATCH_QUEUE_SERIAL);
        }
        [[[strongSelf class] af_sharedImageCache] saveCacheData:[operation responseData]
                         forKey:uniqueId];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([[urlRequest URL] isEqual:[operation.response URL]]) {
            if (failure) {
                failure(urlRequest, operation.response, error);
            }
        }
    }];
    
    [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

//根据图片url得到mknetwork的下载操作的identifier
+ (NSString *)mkNetworkOperationUniqueIdentifier:(NSString *)imgUrl
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"GET %@", imgUrl];
    return [self md5:str];
}

//md5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获得mknetwork的image缓存路径
+ (NSString*)cacheMKNetworkImageDirectoryName
{
    static NSString *cacheDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"MKNetworkKitCache"];
    });
    
    return cacheDirectoryName;
}

@end

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }

	return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFImageCacheKeyFromURLRequest(request)];
    }
}

- (void)saveCacheData:(NSData*) data forKey:(NSString*) cacheDataKey
{
    dispatch_async(self.backgroundCacheQueue, ^{
        
        NSString *cacheDirectory = [self cacheDirectoryName];
        BOOL isDirectory = YES;
        BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
        
        if (!folderExists)
        {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        //如果image符合保存到本地的条件，则保存到本地FlickrImages
        NSString *filePath = [cacheDirectory stringByAppendingPathComponent:cacheDataKey];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            KyoLog(@"%@",error);
        }
        [data writeToFile:filePath atomically:YES];
    });
}

-(NSString*) cacheDirectoryName {
    
    static NSString *cacheDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"MKNetworkKitCache"];
    });
    
    return cacheDirectoryName;
}

@end

#endif
