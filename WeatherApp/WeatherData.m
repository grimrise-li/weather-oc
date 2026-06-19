#import "WeatherData.h"

@implementation WeatherData

@synthesize location    = _location;
@synthesize country     = _country;
@synthesize tempC       = _tempC;
@synthesize tempF       = _tempF;
@synthesize feelsLikeC  = _feelsLikeC;
@synthesize condition   = _condition;
@synthesize humidity    = _humidity;
@synthesize windSpeedKmph = _windSpeedKmph;
@synthesize windDir     = _windDir;
@synthesize visibility  = _visibility;
@synthesize uvIndex     = _uvIndex;
@synthesize pressureMb  = _pressureMb;

- (instancetype)initWithDictionary:(NSDictionary *)dict cityName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    NSArray      *conditions = [dict objectForKey:@"current_condition"];
    NSDictionary *current    = [conditions objectAtIndex:0];

    NSArray      *nearest = [dict objectForKey:@"nearest_area"];
    NSDictionary *area    = [nearest objectAtIndex:0];

    if (name && [name length] > 0) {
        _location = [name copy];
    } else {
        NSArray *areaNames = [area objectForKey:@"areaName"];
        NSDictionary *areaEntry = [areaNames objectAtIndex:0];
        _location = [[areaEntry objectForKey:@"value"] copy];
    }

    NSArray *countries = [area objectForKey:@"country"];
    NSDictionary *countryEntry = [countries objectAtIndex:0];
    _country = [[countryEntry objectForKey:@"value"] copy];

    _tempC         = [[current objectForKey:@"temp_C"] doubleValue];
    _tempF         = [[current objectForKey:@"temp_F"] doubleValue];
    _feelsLikeC    = [[current objectForKey:@"FeelsLikeC"] doubleValue];
    _humidity      = [[current objectForKey:@"humidity"] integerValue];
    _windSpeedKmph = [[current objectForKey:@"windspeedKmph"] doubleValue];
    _windDir       = [[current objectForKey:@"winddir16Point"] copy];
    _visibility    = [[current objectForKey:@"visibility"] integerValue];
    _uvIndex       = [[current objectForKey:@"uvIndex"] integerValue];
    _pressureMb    = [[current objectForKey:@"pressure"] doubleValue];

    NSArray *descs = [current objectForKey:@"weatherDesc"];
    if ([descs count] > 0) {
        NSDictionary *descEntry = [descs objectAtIndex:0];
        _condition = [[descEntry objectForKey:@"value"] copy];
    }

    return self;
}

- (void)printSummary {
    printf("\n");
    printf("+-----------------------------------------+\n");
    printf("|          WEATHER  REPORT                |\n");
    printf("+-----------------------------------------+\n");
    printf("|  Location  : %-27s|\n", [_location UTF8String]);
    printf("|  Country   : %-27s|\n", [_country UTF8String]);
    printf("|  Condition : %-27s|\n", [_condition UTF8String]);
    printf("+-----------------------------------------+\n");
    printf("|  Temp      : %.1f C / %.1f F             \n", _tempC, _tempF);
    printf("|  Feels Like: %.1f C                      \n", _feelsLikeC);
    printf("|  Humidity  : %ld%%                        \n", (long)_humidity);
    printf("|  Wind      : %.0f km/h %s               \n", _windSpeedKmph, [_windDir UTF8String]);
    printf("|  Visibility: %ld km                      \n", (long)_visibility);
    printf("|  Pressure  : %.0f hPa                    \n", _pressureMb);
    printf("|  UV Index  : %ld                          \n", (long)_uvIndex);
    printf("+-----------------------------------------+\n");
    printf("\n");
}

- (void)dealloc {
    [_location release];
    [_country release];
    [_condition release];
    [_windDir release];
    [super dealloc];
}

@end
