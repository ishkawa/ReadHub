#import "RHOrganization.h"
#import "RHAccount.h"

@implementation RHOrganization

@dynamic identifier;
@dynamic avatarURL;
@dynamic url;
@dynamic login;
@dynamic account;

+ (RHOrganization *)organizationWithDictionary:(NSDictionary *)dictionary
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    RHOrganization *organization = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                                                 inManagedObjectContext:context];
    organization.identifier = [dictionary objectForKey:@"id"];
    organization.login      = [dictionary objectForKey:@"login"];
    organization.avatarURL  = [NSURL URLWithString:[dictionary objectForKey:@"avatar_url"]];
    organization.url        = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
    
    return organization;
}

@end
