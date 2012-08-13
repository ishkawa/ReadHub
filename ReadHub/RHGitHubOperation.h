#import "ISJSONNetworkOperation.h"

@interface RHGitHubOperation : ISJSONNetworkOperation

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
        handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
         params:(NSDictionary *)params
        handler:(void (^)(NSHTTPURLResponse *response, id object, NSError *error))handler;

@end
