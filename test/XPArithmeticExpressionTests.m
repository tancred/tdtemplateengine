//
//  XPArithmeticExpressionTests.m
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "TDTestScaffold.h"
#import "XPExpression.h"
#import "XPParser.h"
#import <TDTemplateEngine/TDTemplateContext.h>

@interface XPArithmeticExpressionTests : XCTestCase
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, retain) PKTokenizer *t;
@end

@implementation XPArithmeticExpressionTests

- (void)setUp {
    [super setUp];
    
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    
    [super tearDown];
}

- (NSArray *)tokenize:(NSString *)input {
    PKTokenizer *t = [XPParser tokenizer];
    t.string = input;
    
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    
    NSMutableArray *toks = [NSMutableArray array];
    
    while (eof != (tok = [t nextToken])) {
        [toks addObject:tok];
    }
    return toks;
}

- (void)test1SpacePlusSpace2 {
    NSString *input = @"1 + 2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Plus2 {
    NSString *input = @"1+2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(3.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1SpaceMinusSpace1 {
    NSString *input = @"1 - 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testTruePlus1 {
    NSString *input = @"true + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testYesPlus1 {
    NSString *input = @"YES + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testFalsePlus1 {
    NSString *input = @"false + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNoPlus1 {
    NSString *input = @"NO + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Times2 {
    NSString *input = @"2*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Div2 {
    NSString *input = @"2/2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Plus2Times2 {
    NSString *input = @"3+2*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(7.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testOpen3Plus2CloseTimes2 {
    NSString *input = @"(3+2)*2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg2Mod2 {
    NSString *input = @"-2%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNeg1Mod2 {
    NSString *input = @"-1%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test0Mod2 {
    NSString *input = @"0%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1Mod2 {
    NSString *input = @"1%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test2Mod2 {
    NSString *input = @"2%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test3Mod2 {
    NSString *input = @"3%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test4Mod2 {
    NSString *input = @"4%2";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinus1 {
    NSString *input = @"-1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1 {
    NSString *input = @"--1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1PlusMinusMinus1 {
    NSString *input = @"1 + --1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)test1MinusMinusMinus1 {
    NSString *input = @"1 - --1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Plus1 {
    NSString *input = @"--1 + 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(2.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinus1Minus1 {
    NSString *input = @"--1 - 1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(0.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinus1 {
    NSString *input = @"---1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testMinusMinusMinusMinus4 {
    NSString *input = @"----4";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(4.0, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testPathFooBar8Plus2 {
    NSString *input = @"foo.bar+2";
    NSArray *toks = [self tokenize:input];
    
    id vars = @{@"foo": @{@"bar": @(8)}};
    id ctx = [[[TDTemplateContext alloc] initWithVariables:vars output:nil] autorelease];
    
    NSError *err = nil;
    XPExpression *expr = [XPExpression expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(10.0, [[expr simplify] evaluateAsNumberInContext:ctx]);
}

@end