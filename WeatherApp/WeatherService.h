#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WeatherService : NSObject

- (WeatherData *)fetchWeatherForCity:(NSString *)city error:(NSError **)outError;

@end
