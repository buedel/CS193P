//
//  CalculatorBrain.m
//  Calculator
//
//  Created by DOUGLAS BUEDEL on 10/13/12.
//  Copyright (c) 2012 buedel. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()

// contains all operations and operands ever sent to this instance
// operands are NSNumbers, operations are NSStrings
@property (nonatomic, strong) NSMutableArray *programStack;

@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *) programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

// we must return some object (of any class) that represents
//  all the operands and operations performed on this instance
//  so that it can be played back via runProgram:
// we'll simply return an immutable copy of our internal data structure

- (id)program
{
    return [self.programStack copy];
}


- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

- (void) clear
{
    [self.programStack removeAllObjects];
}



// 0 is a constant like pi
// -1 is a variable
+ (int) numberOfRequiredArguments:(NSString *)operation
{
    NSSet * binaryOperators = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    NSSet * unitaryOperators = [NSSet setWithObjects:@"sin",@"cos",@"sqrt", nil];
    NSSet * constants = [NSSet setWithObjects:@"pi", nil];
    
    if ([binaryOperators containsObject:operation]) {
        return 2;
    } else if ([unitaryOperators containsObject:operation]) {
        return 1;
    } else if ([constants containsObject:operation]) {
        return 0;
    } else {
        return -1;
    }
}

// if the top thing on the passed stack is an operand, return it
// if the top thing on the passed stack is an operation, evaluate it (recursively)
// does not crash (but returns 0) if stack contains objects other than NSNumber or NSString

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = 3.14;
        }

    }
    
    return result;
}

// checks to be sure passed program is actually an array
//  then evaluates it by calling popOperandOffProgramStack:
// assumes popOperandOffProgramStack: protects against junk array contents

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        for (int i=0; i< stack.count; i++) {
            id item = [stack objectAtIndex:i];
            id value = [variableValues objectForKey:item];
            if (value   ) {
                [stack replaceObjectAtIndex:i withObject:value];
            }
        }
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *) variablesUsedInProgram:(id)program
{
    NSSet * retval = [NSSet set];
    
    for (id item in program) {
        if ([item isKindOfClass:[NSString class]]) {
            if (-1 == [self numberOfRequiredArguments:item]) {
                // assume variable
                retval = [retval setByAddingObject:item];
            }
        }
    }
    return retval;
}

+ (NSString *)popDescriptionOffProgramStack:(NSMutableArray *)stack
{
    NSString * result = nil;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack stringValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if (2 == [self numberOfRequiredArguments:operation]) {
            NSString * arg2 = [self popDescriptionOffProgramStack:stack];
            NSString * arg1 = [self popDescriptionOffProgramStack:stack];
            if ([stack lastObject] &&
                ([operation isEqualToString:@"+"] ||
                 [operation isEqualToString:@"-"])) {
                result = [NSString stringWithFormat:@"(%@ %@ %@)", arg1, operation, arg2];
            } else {
                result = [NSString stringWithFormat:@"%@ %@ %@", arg1, operation, arg2];
            }
        } else if (1 == [self numberOfRequiredArguments:operation]) {
            NSString * arg1 = [self popDescriptionOffProgramStack:stack];
                result = [NSString stringWithFormat:@"%@(%@)", operation, arg1];
        } else { // assume it's a constant or a variable name
            result = [NSString stringWithFormat:@"%@",operation];
        }
    }

    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString * result = @"";
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        
        result = [self popDescriptionOffProgramStack:stack];
        
        // Add any other parts
        NSString * part;
        while ((part = [self popDescriptionOffProgramStack:stack])) {
            result = [NSString stringWithFormat:@"%@, %@", result, part];
        };
    }
    if (result) {
        return result;
    } else {
        return @"";
    }
}

- (BOOL)canPerformOperation:(NSString *)operation
{
    int requiredArgs = [CalculatorBrain numberOfRequiredArguments:operation];
    if (requiredArgs > 0) {
        NSMutableArray *stack;
        if ([self.program isKindOfClass:[NSArray class]]) {
            stack = [self.program mutableCopy];
        }
        NSString * arg1 = [CalculatorBrain popDescriptionOffProgramStack:stack];
        NSString * arg2 = [CalculatorBrain popDescriptionOffProgramStack:stack];
        if ((requiredArgs == 1) && (arg1 == nil)) {
            return NO;
        } else if ((requiredArgs == 2) && (arg2 == nil)) {
            return NO;
        }
    }
    return YES;
}

// just pushes the operation onto our stack internal data structure
- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}
@end
