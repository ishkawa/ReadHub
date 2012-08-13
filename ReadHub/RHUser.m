#import "RHUser.h"

@implementation RHUser

@dynamic login;
@dynamic identifier;
@dynamic avatarURL;
@dynamic name;
@dynamic bio;
@dynamic blogURL;
@dynamic location;
@dynamic publicRepositoriesCount;
@dynamic followersCount;
@dynamic followingCount;

+ (RHUser *)user
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    
    return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}

+ (RHUser *)userWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"]) {
        return nil;
    }
    RHUser *user = [RHUser user];
    @try {
        user.login          = [dictionary objectForKey:@"login"];
        user.identifier     = [dictionary objectForKey:@"id"];
        user.avatarURL      = [NSURL URLWithString:[dictionary objectForKey:@"avatar_url"]];
        user.name           = [dictionary objectForKey:@"name"];
        user.bio            = [dictionary objectForKey:@"bio"];
        user.blogURL        = [NSURL URLWithString:[dictionary objectForKey:@"blog"]];
        user.location       = [dictionary objectForKey:@"location"];
        user.followersCount = [dictionary objectForKey:@"followers"];
        user.followersCount = [dictionary objectForKey:@"following"];
        user.publicRepositoriesCount = [dictionary objectForKey:@"public_repos"];
    }
    @catch (NSException *exception) {
    }
    
    return user;
}

@end
