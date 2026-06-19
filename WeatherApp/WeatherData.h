#import <Foundation/Foundation.h>

@interface WeatherData : NSObject {
    NSString *_location;
    NSString *_country;
    double    _tempC;
    double    _tempF;
    double    _feelsLikeC;
    NSString *_condition;
    NSInteger _humidity;
    double    _windSpeedKmph;
    NSString *_windDir;
    NSInteger _visibility;
    NSInteger _uvIndex;
    double    _pressureMb;
}

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, assign) double tempC;
@property (nonatomic, assign) double tempF;
@property (nonatomic, assign) double feelsLikeC;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) double windSpeedKmph;
@property (nonatomic, copy) NSString *windDir;
@property (nonatomic, assign) NSInteger visibility;
@property (nonatomic, assign) NSInteger uvIndex;
@property (nonatomic, assign) double pressureMb;

- (instancetype)initWithDictionary:(NSDictionary *)dict cityName:(NSString *)name;
- (void)printSummary;

@end
