#import "ISJSONNetworkOperation.h"

@interface RHGitHubOperation : ISJSONNetworkOperation

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
        handler:(void (^)(NSURLResponse *response, id object, NSError *error))handler;

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
         params:(NSDictionary *)params
        handler:(void (^)(NSURLResponse *response, id object, NSError *error))handler;

@end
