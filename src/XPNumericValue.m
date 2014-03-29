// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XPNumericValue.h"

@implementation XPNumericValue{
    double _value;
}

+ (XPNumericValue *)numericValueWithString:(NSString *)s {
    return [[[self alloc] initWithString:s] autorelease];
}


+ (XPNumericValue *)numericValueWithNumber:(double)n {
    return [[[self alloc] initWithNumber:n] autorelease];
}


- (id)initWithString:(NSString *)s {
    return [self initWithNumber:XPNumberFromString(s)];
}


- (id)initWithNumber:(double)n {
    if (self = [super init]) {
        _value = n;
    }
    return self;
}


- (NSString *)asString {
    // TODO
    return [[NSNumber numberWithDouble:_value] stringValue];
}


- (double)asNumber {
    return _value;
}


- (BOOL)asBoolean {
    return (_value != 0.0 && !isnan(_value));
}


- (XPDataType)dataType {
    return XPDataTypeNumber;
}


- (void)display:(NSInteger)level {
    //NSLog(@"%@number (%@)", [self indent:level], [self asString]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<XPNumericValue %p %@>", self, [self asString]];
}

@end
