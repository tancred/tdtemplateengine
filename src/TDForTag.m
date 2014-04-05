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

#import "TDForTag.h"
#import "TDForLoop.h"
#import <TDTemplateEngine/TDTemplateContext.h>

#import "XPLoopExpression.h"
#import "XPEnumeration.h"

@interface TDForTag ()
@property (nonatomic, retain) TDForLoop *forloop;
@end

@implementation TDForTag

- (void)dealloc {
    self.forloop = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%p for %@", self, self.expression];
}


- (void)doTagInContext:(TDTemplateContext *)ctx {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
    TDAssert(ctx);
    
    XPLoopExpression *expr = (id)self.expression;
    TDAssert([expr isKindOfClass:[XPLoopExpression class]]);
    
    [self setUpForLoop:ctx];
    
    while ([expr evaluateInContext:ctx]) {
        _forloop.last = ![expr.enumeration hasMore];
        //NSLog(@"rendering body of %@", self);
        [ctx renderBody:self];
        
        _forloop.counter++;
        _forloop.counter0++;
        _forloop.first = NO;
    }

    [self tearDownForLoop:ctx];
}


- (void)setUpForLoop:(TDTemplateContext *)ctx {
    self.forloop = [[[TDForLoop alloc] init] autorelease];
    
//    TDForTag *enclosingForTag = (id)[self firstAncestorOfTagName:@"for"];
//    _forloop.parentLoop = enclosingForTag.forloop;

    [ctx defineVariable:@"forloop" withValue:_forloop];
}


- (void)tearDownForLoop:(TDTemplateContext *)ctx {
    [ctx defineVariable:@"forloop" withValue:nil];
    _forloop.parentLoop = nil;
    self.forloop = nil;
}

@end
