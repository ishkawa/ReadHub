#import "RHOrganization.h"
#import "RHAccount.h"

@implementation RHOrganization

@dynamic identifier;
@dynamic avatarURL;
@dynamic url;
@dynamic login;
@dynamic account;

+ (RHOrganization *)organization
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    
    return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}

+ (RHOrganization *)organizationWithDictionary:(NSDictionary *)dictionary
{
    RHOrganization *organization = [self organization];
    organization.identifier = [dictionary objectForKey:@"id"];
    organization.login      = [dictionary objectForKey:@"login"];
    organization.avatarURL  = [NSURL URLWithString:[dictionary objectForKey:@"avatar_url"]];
    organization.url        = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
    
    return organization;
}

+ (RHOrganization *)organizationForID:(NSNumber *)identifier
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier=%@", identifier];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    if (![result count]) {
        return nil;
    }
    return [result objectAtIndex:0];
}

+ (NSArray *)allOrganizations
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    
    return [context executeFetchRequest:request error:nil];
}


@end
