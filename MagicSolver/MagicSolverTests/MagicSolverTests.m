//
//  MagicSolverTests.m
//  MagicSolverTests
//
//  Created by Adam Lovastyik on 2013.06.10..
//  Copyright (c) 2013 Lovastyik. All rights reserved.
//

#import "MagicSolverTests.h"
#import "MSCalculator.h"

@interface MagicSolverTests () {
    MSCalculator *calculator;
}

@end

@implementation MagicSolverTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    calculator = [[MSCalculator alloc] init];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
    
    calculator = nil;
}

#pragma mark Basic test for existence

- (void)testCalculatorExists {
    STAssertNotNil(calculator, @"Calculator instance not nil");
}

- (void)formatterNotNil {
    STAssertNotNil([calculator formatter], @"Formatter not nil");
}

#pragma mark Test operator interpretation

- (void)testOperatorNil {
    int ret = [calculator PriorityIfOperator:nil];
    
    STAssertTrue(ret==0, @"Nil is not an operator");
}

- (void)testOperatorAdd {
    int ret = [calculator PriorityIfOperator:@"+"];
    
    STAssertTrue(ret==1, @"+ is an operator");
}

- (void)testOperatorSub {
    int ret = [calculator PriorityIfOperator:@"-"];
    
    STAssertTrue(ret==1, @"- is an operator");
}

- (void)testOperatorMult {
    int ret = [calculator PriorityIfOperator:@"*"];
    
    STAssertTrue(ret==2, @"* is an operator");
}

- (void)testOperatorDiv {
    int ret = [calculator PriorityIfOperator:@"/"];
    
    STAssertTrue(ret==2, @"/ is an operator");
}

#pragma mark Test line split

- (void)testInterpretReturnsNotNil {
    NSString *line = @"1+1";
    
    STAssertNotNil([calculator interpretLineOfString:line], @"Interpreted line not nil");
}

- (void)testInterpretReturnsThreeItems {
    NSString *line = @"1+1";
    
    NSMutableArray *ret = [calculator interpretLineOfString:line];
    
    STAssertTrue([ret count] == 3, @"1+1 has 3 items");
}

- (void)testInterpretReturnsNil {
    STAssertNil([calculator interpretLineOfString:nil], @"Interpreted line nil");
}

- (void)testInterpretReturnsCorrectValues {
    NSString *line = @"1+2";
    
    NSMutableArray *ret = [calculator interpretLineOfString:line];
    
    STAssertEquals([ret objectAtIndex:0], @1, @"1 is 1");
    STAssertTrue([[ret objectAtIndex:1] isEqualToString:@"+"], @"+ is +");
    STAssertEquals([ret objectAtIndex:2], @2, @"2 is 2");
}

#pragma mark Test Operation calculation

- (void)testCalcOperatorNil {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:nil withNumber:nil andNumber:nil Error:&error];
    
    STAssertNil(ret, @"Ret should be nil");
    STAssertNotNil(error, @"error should be not nil");
    STAssertTrue([error code] == 1, @"Error code 1");
}

- (void)testCalcOperatorShort {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"" withNumber:nil andNumber:nil Error:&error];
    
    STAssertNil(ret, @"Ret should be nil");
    STAssertNotNil(error, @"error should be not nil");
    STAssertTrue([error code] == 1, @"Error code 1");
}

- (void)testCalcArg1Nil {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"+" withNumber:nil andNumber:nil Error:&error];
    
    STAssertNil(ret, @"Ret should be nil");
    STAssertNotNil(error, @"error should be not nil");
    STAssertTrue([error code] == 2, @"Error code 1");
}

- (void)testCalcArg2Nil {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"+" withNumber:@1 andNumber:nil Error:&error];
    
    STAssertNil(ret, @"Ret should be nil");
    STAssertNotNil(error, @"error should be not nil");
    STAssertTrue([error code] == 3, @"Error code 3");
}

- (void)testOperationAdd {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"+" withNumber:@1 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@3], @"1+2=3");
}

- (void)testOperationSubPositive {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"-" withNumber:@2 andNumber:@1 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@1], @"2-1=1");
}

- (void)testOperationSubNegative {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"-" withNumber:@1 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@-1], @"1-2=-1");
}

- (void)testOperationMultPositive1 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"*" withNumber:@1 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@2], @"1*2=2");
}

- (void)testOperationMultNegative {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"*" withNumber:@-1 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@-2], @"-1*2=-2");
}

- (void)testOperationMultPositive2 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"*" withNumber:@-1 andNumber:@-1 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@1], @"-1*-1=1");
}

- (void)testOperationMultZero1 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"*" withNumber:@1 andNumber:@0 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@0], @"1*0=0");
}

- (void)testOperationDivPositive1 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@2 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@1], @"2/2=1");
}

- (void)testOperationDivNegative1 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@-2 andNumber:@2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@-1], @"-2/2=-1");
}

- (void)testOperationDivNegative2 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@2 andNumber:@-2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@-1], @"2/-2=-1");
}

- (void)testOperationMultNegaive2 {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@-2 andNumber:@-2 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@1], @"-2/-2=1");
}

- (void)testOperationDivZero {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@0 andNumber:@1 Error:&error];
    
    STAssertNil(error, @"error should be nil");
    STAssertNotNil(ret, @"Return should be not nil");
    STAssertTrue([ret isEqualToNumber:@0], @"0/1=0");
}

- (void)testOperationDivZeroError {
    NSError *error = nil;
    NSNumber *ret = [calculator calculateOperation:@"/" withNumber:@1 andNumber:@0 Error:&error];
    
    STAssertNotNil(error, @"error should not be nil");
    STAssertNil(ret, @"Return should not nil");
    STAssertTrue([error code]==4, @"Error code 4");
}

#pragma mark Maximal priority

- (void)testMaxPriority0 {
    NSString *line = @"1";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 0, @"Max 0");
    
}

- (void)testMaxPriority1_1 {
    NSString *line = @"1+1";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 1, @"Max 1");
    
}

- (void)testMaxPriority1_2 {
    NSString *line = @"1-1";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 1, @"Max 1");
    
}

- (void)testMaxPriority2_1 {
    NSString *line = @"1*1";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 2, @"Max 2");
    
}

- (void)testMaxPriority2_2 {
    NSString *line = @"1/1";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 2, @"Max 2");
    
}

- (void)testMaxPriority2_3 {
    NSString *line = @"4+5*2";
    NSMutableArray *interpreted = [calculator interpretLineOfString:line];
    int max = [calculator maxPriorityOfInterpretedLine:interpreted];
    
    STAssertNotNil(interpreted, @"Interpreted not nil");
    STAssertTrue(max == 2, @"Max 2");
    
}

#pragma mark Test results

- (void)testTooFewArgs1 {
    NSString *line = @"1";
    NSError *error = nil;
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNil(result, @"Result should be nil");
    STAssertNotNil(error, @"Error should be not nil");
    STAssertTrue([error code] == 100, @"Error 100");
    
}

- (void)testTooFewArgs2 {
    NSString *line = @"1+";
    NSError *error = nil;
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNil(result, @"Result should be nil");
    STAssertNotNil(error, @"Error should be not nil");
    STAssertTrue([error code] == 100, @"Error 100");
    
}

- (void)testResultNotNilWithValid {
    NSString *line = @"1+1";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@2], @"1+1=2");
}

- (void)testResultDivisionZero {
    NSString *line = @"1/0+2";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNil(result, @"Result should be nil");
    STAssertNotNil(error, @"Error should be not nil");
    STAssertTrue([error code] == 4, @"Error 4");
}

- (void)testResultWithFloats1 {
    NSString *line = @"2.5*4*1.5";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@15], @"2.5*4=10");
}

- (void)testResultWithFloats2 {
    NSString *line = @"2.5/5+1";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@1.5], @"2.5/5+1=1.5");
}

- (void)testResultWithFloats3 {
    NSString *line = @"2.5/5+7/3.5";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@2.5], @"2.5/5+7/3.5=2.5");
}

- (void)testResultWithOperatorsOnly {
    NSString *line = @"+-+";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNil(result, @"Result should be nil");    
}

- (void)testResultWithIgnoredStartingAndEndingOp {
    NSString *line = @"+1-";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, @"Result should be not be nil");
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@1], @"1");
}

#pragma mark -
#pragma mark Tests with provided samples

- (void)testResultWithSample1 {
    NSString *line = @"4+5*2";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@14], @"4+5*2=14");
}

- (void)testResultWithSample2 {
    NSString *line = @"4+5/2";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@6.5], @"4+5/2=6.5");
}

- (void)testResultWithSample3 {
    NSString *line = @"4+5/2-1";
    NSError *error = nil;
    
    NSNumber *result = [calculator calculateLineOfString:line Error:&error];
    
    STAssertNotNil(result, [NSString stringWithFormat:@"Result should not be nil for %@", line]);
    STAssertNil(error, @"Error should be nil");
    STAssertTrue([result isEqualToNumber:@5.5], @"4+5/2-1=5.5");
}

@end
