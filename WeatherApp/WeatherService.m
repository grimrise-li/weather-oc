#import "WeatherService.h"

@implementation WeatherService

- (WeatherData *)fetchWeatherForCity:(NSString *)city error:(NSError **)outError {
    NSString *encoded = [city stringByAddingPercentEncodingWithAllowedCharacters:
                         [NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *urlStr = [NSString stringWithFormat:@"https://wttr.in/%@?format=j1", encoded];
    NSURL *url = [NSURL URLWithString:urlStr];

    if (!url) {
        if (outError) {
            *outError = [NSError errorWithDomain:@"WeatherApp"
                                           code:1
                                       userInfo:[NSDictionary dictionaryWithObject:@"Invalid city name"
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"curl/7.0" forHTTPHeaderField:@"User-Agent"];
    [request setTimeoutInterval:15.0];

    NSHTTPURLResponse *httpResponse = nil;
    NSError *connError = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:(NSURLResponse **)&httpResponse
                                                     error:&connError];
#pragma clang diagnostic pop

    if (connError) {
        if (outError) *outError = connError;
        return nil;
    }

    if (!data || [httpResponse statusCode] != 200) {
        NSInteger code = httpResponse ? [httpResponse statusCode] : -1;
        NSString *msg  = [NSString stringWithFormat:
                          @"Server returned %ld — city not found or network error", (long)code];
        if (outError) {
            *outError = [NSError errorWithDomain:@"WeatherApp"
                                           code:code
                                       userInfo:[NSDictionary dictionaryWithObject:msg
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }

    NSError *jsonErr = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:&jsonErr];
    if (!json || jsonErr) {
        if (outError) {
            *outError = jsonErr ? jsonErr :
                        [NSError errorWithDomain:@"WeatherApp"
                                           code:2
                                       userInfo:[NSDictionary dictionaryWithObject:@"Failed to parse JSON"
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return nil;
    }

    return [[[WeatherData alloc] initWithDictionary:json cityName:city] autorelease];
}

@end
