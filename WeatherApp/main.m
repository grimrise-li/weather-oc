#import <Foundation/Foundation.h>
#import "WeatherService.h"
#import "WeatherData.h"

static WeatherData *makeDemoData(NSString *city) {
    NSDictionary *descEntry    = [NSDictionary dictionaryWithObject:@"Partly Cloudy" forKey:@"value"];
    NSArray      *descs        = [NSArray arrayWithObject:descEntry];

    NSDictionary *current = [NSDictionary dictionaryWithObjectsAndKeys:
        @"18",           @"temp_C",
        @"64",           @"temp_F",
        @"16",           @"FeelsLikeC",
        @"72",           @"humidity",
        @"20",           @"windspeedKmph",
        @"WSW",          @"winddir16Point",
        @"10",           @"visibility",
        @"3",            @"uvIndex",
        @"1013",         @"pressure",
        descs,           @"weatherDesc",
        nil];

    NSDictionary *areaEntry    = [NSDictionary dictionaryWithObject:city forKey:@"value"];
    NSDictionary *countryEntry = [NSDictionary dictionaryWithObject:@"Demo Country" forKey:@"value"];
    NSDictionary *area = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObject:areaEntry],   @"areaName",
        [NSArray arrayWithObject:countryEntry], @"country",
        nil];

    NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObject:current], @"current_condition",
        [NSArray arrayWithObject:area],    @"nearest_area",
        nil];

    return [[[WeatherData alloc] initWithDictionary:json cityName:city] autorelease];
}

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSArray *args = [[NSProcessInfo processInfo] arguments];

    if ([args count] < 2) {
        printf("Usage: weather <city> [city words...]\n");
        printf("       weather --demo <city>   (offline demo with sample data)\n");
        printf("Examples:\n");
        printf("  weather London\n");
        printf("  weather New York\n");
        printf("  weather --demo Tokyo\n");
        [pool drain];
        return 1;
    }

    BOOL demoMode = NO;
    NSUInteger startIndex = 1;

    if ([[args objectAtIndex:1] isEqualToString:@"--demo"]) {
        demoMode = YES;
        startIndex = 2;
        if ([args count] < 3) {
            printf("Usage: weather --demo <city>\n");
            [pool drain];
            return 1;
        }
    }

    NSMutableArray *cityParts = [NSMutableArray array];
    for (NSUInteger i = startIndex; i < [args count]; i++) {
        [cityParts addObject:[args objectAtIndex:i]];
    }
    NSString *city = [cityParts componentsJoinedByString:@" "];

    WeatherData *data = nil;
    NSError     *error = nil;

    if (demoMode) {
        printf("Running in demo mode (offline sample data)\n");
        data = makeDemoData(city);
    } else {
        printf("Fetching weather for \"%s\"...\n", [city UTF8String]);
        WeatherService *service = [[[WeatherService alloc] init] autorelease];
        data = [service fetchWeatherForCity:city error:&error];
    }

    int exitCode = 0;
    if (!data) {
        fprintf(stderr, "Error: %s\n", error ? [[error localizedDescription] UTF8String] : "Unknown error");
        exitCode = 1;
    } else {
        [data printSummary];
    }

    [pool drain];
    return exitCode;
}
