#import "RHAccount.h"
#import "RHOrganization.h"

@implementation RHAccount

@dynamic accessToken;
@dynamic tokenType;
@dynamic organizations;

+ (RHAccount *)account
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    
    return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}

+ (RHAccount *)accountWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"access_token"]) {
        return nil;
    }
    RHAccount *account = [RHAccount account];
    account.accessToken = [dictionary objectForKey:@"access_token"];
    account.tokenType   = [dictionary objectForKey:@"token_type"];
    
    return account;
    
    
    return account;
}

+ (RHAccount *)currentAccount
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    NSArray *results = [context executeFetchRequest:request error:nil];
    if (![results count]) {
        return nil;
    }
    return [results objectAtIndex:0];
}

+ (void)setCurrentAccount:(RHAccount *)account
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    RHAccount *currentAccount = [RHAccount currentAccount];
    if (currentAccount) {
        // app manages only 1 account
        [context deleteObject:currentAccount];
    }
    [context insertObject:account];
    [[ISDataManager sharedManager] saveContext];
}

- (void)loadUserInfo
{
    [RHGitHubOperation callAPI:@"/user"
                        method:ISHTTPMethodGET
                       handler:^(NSHTTPURLResponse *response, id object, NSError *error) {
                           if (error || response.statusCode !=200) {
                               return;
                           }
                           
                       }];
}

@end
