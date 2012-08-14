#import "RHRepository.h"
#import "RHOrganization.h"

@implementation RHRepository

@dynamic url;
@dynamic cloneURL;
@dynamic identifier;
@dynamic name;
@dynamic fullName;
@dynamic isPrivate;
@dynamic forksCount;
@dynamic watchersCount;
@dynamic pushedAt;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic masterBranchName;
@dynamic openIssuesCount;
@dynamic descriptor;

+ (RHRepository *)repository
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    
    return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}

+ (RHRepository *)repositoryWithDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *temp = [dictionary mutableCopy];
    for (id key in [temp allKeys]) {
        if ([[temp objectForKey:key] isKindOfClass:[NSNull class]]) {
            [temp setValue:nil forKey:key];
        }
    }
    dictionary = [NSDictionary dictionaryWithDictionary:temp];
    
    if (![dictionary objectForKey:@"id"]) {
        return nil;
    }
    RHRepository *repository = [RHRepository repository];
    @try {
        repository.url          = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        repository.cloneURL     = [NSURL URLWithString:[dictionary objectForKey:@"clone_url"]];
        repository.identifier   = [dictionary objectForKey:@"id"];
        repository.name         = [dictionary objectForKey:@"name"];
        repository.fullName     = [dictionary objectForKey:@"full_name"];
        repository.isPrivate    = [dictionary objectForKey:@"private"];
        repository.forksCount   = [dictionary objectForKey:@"forks"];
        repository.watchersCount = [dictionary objectForKey:@"watchers"];
        repository.pushedAt     = nil;
        repository.createdAt    = nil;
        repository.updatedAt    = nil;
        repository.masterBranchName = [dictionary objectForKey:@"master_branch"];
        repository.openIssuesCount  = [dictionary objectForKey:@"open_issues"];
        repository.descriptor   = [dictionary objectForKey:@"description"];
    }
    @catch (NSException *exception) {
        NSLog(@"exc: %@", exception);
    }
    return repository;
}

+ (RHRepository *)repositoryForID:(NSNumber *)identifier
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

+ (NSArray *)allRepositories
{
    NSManagedObjectContext *context = [ISDataManager sharedManager].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    
    return [context executeFetchRequest:request error:nil];
}

@end
