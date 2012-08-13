#import "RHAccount.h"
#import "RHOrganization.h"

@implementation RHAccount

@dynamic accessToken;
@dynamic tokenType;
@dynamic organizations;

+ (RHAccount *)accountWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"access_token"]) {
        return nil;
    }
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    RHAccount *currentAccount = [self currentAccount];
    if (currentAccount) {
        // app manages only 1 account
        [context deleteObject:currentAccount];
    }
    
    RHAccount *account = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                                       inManagedObjectContext:context];
    account.accessToken = [dictionary objectForKey:@"access_token"];
    account.tokenType   = [dictionary objectForKey:@"token_type"];
    [[ISDataManager sharedManager] saveContext];
    
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

@end
