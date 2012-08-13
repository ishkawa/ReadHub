#import "RHGitHubOperation.h"
#import "RHAccount.h"
#import "NSDictionary+URLQuery.h"

@implementation RHGitHubOperation

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
        handler:(void (^)(NSHTTPURLResponse *, id, NSError *))handler
{
    [self callAPI:path
           method:method
           params:nil
          handler:handler];
}

+ (void)callAPI:(NSString *)path
         method:(ISHTTPMethod)method
         params:(NSDictionary *)params
        handler:(void (^)(NSHTTPURLResponse *, id, NSError *))handler
{
    NSLog(@"\npath: %@\nparams: %@", path, params);
    
    RHAccount *account = [RHAccount currentAccount];
    if (!account) {
        return;
    }
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [fullParams setObject:account.accessToken forKey:@"access_token"];
    
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"%@%@", API, path];
    NSString *query = [fullParams URLQuery];
    if ([query length]) {
        [URLString appendFormat:@"?%@", query];
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  
    [super sendRequest:request handler:handler];
}

@end
