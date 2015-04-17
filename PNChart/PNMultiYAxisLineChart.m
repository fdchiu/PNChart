//
//  PNMutiYAxisLineChart.m
//  Asante
//
//  Created by David Chiu on 3/26/15.
//  Copyright (c) 2015 Asante. All rights reserved.
//

#import "PNMultiYAxisLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"


@implementation PNMultiYAxisLineChart


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
        if (self.isShowCoordinateAxis) {
            //CGFloat yAxisOffset = 10.f;
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            UIGraphicsPushContext(ctx);
            CGContextSetLineWidth(ctx, self.axisWidth);
            CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
            
            CGFloat xAxisWidth = CGRectGetWidth(rect) - self.chartMargin;
            CGFloat yAxisHeight = self.chartMargin + self.chartCavanHeight;
            
            // draw coordinate axis
            CGContextMoveToPoint(ctx, self.chartMargin + self.yAxisOffset, 0);
            CGContextAddLineToPoint(ctx, self.chartMargin + self.yAxisOffset, yAxisHeight);
            CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
            
            //second Y axis
            CGContextAddLineToPoint(ctx, xAxisWidth, 0);
            
            CGContextStrokePath(ctx);
            
            // draw y axis arrow
            if(self.chartYAxisEndStyle == PNLineChartAxisEndStyleArrow) {
                CGContextMoveToPoint(ctx, self.chartMargin + self.yAxisOffset - 3, 6);
                CGContextAddLineToPoint(ctx, self.chartMargin + self.yAxisOffset, 0);
                CGContextAddLineToPoint(ctx, self.chartMargin + self.yAxisOffset + 3, 6);
                CGContextStrokePath(ctx);
            }
            // draw x axis arrow
            if(self.chartXAxisEndStyle == PNLineChartAxisEndStyleArrow) {
                CGContextMoveToPoint(ctx, xAxisWidth - 6, yAxisHeight - 3);
                CGContextAddLineToPoint(ctx, xAxisWidth, yAxisHeight);
                CGContextAddLineToPoint(ctx, xAxisWidth - 6, yAxisHeight + 3);
                CGContextStrokePath(ctx);
            }
            
            if (self.showLabel) {
                
                // draw x axis separator
                CGPoint point;
                for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                    point = CGPointMake(2 * self.chartMargin +  (i * self.xLabelWidth), self.chartMargin + self.chartCavanHeight);
                    CGContextMoveToPoint(ctx, point.x, point.y - 2);
                    CGContextAddLineToPoint(ctx, point.x, point.y);
                    CGContextStrokePath(ctx);
                }
                
                // draw y axis separator
                CGFloat yStepHeight = self.chartCavanHeight / self.yLabelNum;
                for (NSUInteger i = 0; i < [self.xLabels count]; i++) {
                    point = CGPointMake(self.chartMargin + self.yAxisOffset, (self.chartCavanHeight - i * yStepHeight + self.yLabelHeight / 2));
                    CGContextMoveToPoint(ctx, point.x, point.y);
                    CGContextAddLineToPoint(ctx, point.x + 2, point.y);
                    CGContextStrokePath(ctx);
                }
            }
            
            UIFont *font = [UIFont systemFontOfSize:11];
            
            // draw y unit
            if ([self.yUnit length]) {
                CGFloat height = [PNLineChart sizeOfString:self.yUnit withWidth:30.f font:font].height;
                CGRect drawRect = CGRectMake(self.chartMargin + 10 + 5, 0, 30.f, height);
                [self drawTextInContext:ctx text:self.yUnit inRect:drawRect font:font];
            }
            
            // draw x unit
            if ([self.xUnit length]) {
                CGFloat height = [PNLineChart sizeOfString:self.xUnit withWidth:30.f font:font].height;
                CGRect drawRect = CGRectMake(CGRectGetWidth(rect) - self.chartMargin + 5, self.chartMargin + self.chartCavanHeight - height / 2, 25.f, height);
                [self drawTextInContext:ctx text:self.xUnit inRect:drawRect font:font];
            }
        }
        
        //[super drawRect:rect];
    
    
        // draw coordinate axis
    //CGContextMoveToPoint(ctx, self.chartMargin + yAxisOffset, 0);
    //CGContextAddLineToPoint(ctx, self.chartMargin + yAxisOffset, yAxisHeight);
    //CGContextMoveToPoint(ctx, xAxisWidth, yAxisHeight);
    //CGContextAddLineToPoint(ctx, xAxisWidth, 0);
    //CGContextStrokePath(ctx);

}

- (void)calculateChartPath:(NSMutableArray *)chartPath andPointsPath:(NSMutableArray *)pointsPath andPathKeyPoints:(NSMutableArray *)pathPoints andPathStartEndPoints:(NSMutableArray *)pointsOfPath
{
    
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.chartData.count; lineIndex++) {
        PNLineChartData *chartData = self.chartData[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPath];
        
        
        [chartPath insertObject:progressline atIndex:lineIndex];
        [pointsPath insertObject:pointPath atIndex:lineIndex];
        
        if (!self.showLabel) {
            self.chartCavanHeight = self.frame.size.height - 2 * self.yLabelHeight;
            self.chartCavanWidth = self.frame.size.width;
            self.chartMargin = chartData.inflexionPointWidth;
            self.xLabelWidth = (self.chartCavanWidth / ([self.xLabels count] - 1));
        }
        
        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
        NSMutableArray *lineStartEndPointsArray = [[NSMutableArray alloc] init];
        int last_x = 0;
        int last_y = 0;
        CGFloat inflexionWidth = chartData.inflexionPointWidth;
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            
            yValue = chartData.getData(i).y;
            
            if(lineIndex!=1) {
            if (!(self.yValueMax - self.yValueMin)) {
                innerGrade = 0.5;
            } else {
                innerGrade = (yValue - self.yValueMin) / (self.yValueMax - self.yValueMin);
            }
            }
            else {
                if (!(self.yValueMax2 - self.yValueMin2)) {
                    innerGrade = 0.5;
                } else {
                    innerGrade = (yValue - self.yValueMin2) / (self.yValueMax2 - self.yValueMin2);
                }
                
            }
                
            CGFloat offSetX = (self.frame.size.width - self.chartMargin) / (chartData.itemCount);
            //CGFloat offSetX = (self.chartCavanWidth) / (chartData.itemCount);
            
            int x = self.chartMargin +  (i * offSetX);
            int y = self.chartCavanHeight - (innerGrade * self.chartCavanHeight) + (self.yLabelHeight / 2);
            
            // Circular point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCircle) {
                
                CGRect circleRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) );
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
            }
            // Square point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {
                
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath closePath];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) );
                    float last_x1 = last_x + (inflexionWidth / 2);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
            }
            // Triangle point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {
                
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                
                CGPoint startPoint = CGPointMake(squareRect.origin.x,squareRect.origin.y + squareRect.size.height);
                CGPoint endPoint = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2) , squareRect.origin.y);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width) , squareRect.origin.y + squareRect.size.height);
                
                [pointPath moveToPoint:startPoint];
                [pointPath addLineToPoint:middlePoint];
                [pointPath addLineToPoint:endPoint];
                [pointPath closePath];
                
                if ( i != 0 ) {
                    // calculate the point for triangle
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) ) * 1.4 ;
                    float last_x1 = last_x + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
                
            } else {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
                if(i != chartData.itemCount - 1){
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                }
            }
            
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        
        [pathPoints addObject:[linePointsArray copy]];
        [pointsOfPath addObject:[lineStartEndPointsArray copy]];
    }
}

- (void)setXLabels:(NSArray *)xLabels
{
    CGFloat xLabelWidth;
    
    if (self.showLabel) {
        xLabelWidth = (self.frame.size.width - self.chartMargin) / [xLabels count];
    } else {
        xLabelWidth = (self.frame.size.width) / [xLabels count];
    }
    
    super.xLabels = xLabels;
    
    return [self setXLabels:xLabels withWidth:xLabelWidth];
}

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width
{
    //self.xLabels = [NSArray arrayWithArray:xLabels];
    //self.xLabels = xLabels;
    self.xLabelWidth = width;
    if (self.xChartLabels) {
        for (PNChartLabel * label in self.xChartLabels) {
            [label removeFromSuperview];
        }
    }else{
        self.xChartLabels = [NSMutableArray new];
    }
    
    NSString *labelText;
    
    if (self.showLabel) {
        for (int index = 0; index < xLabels.count; index++) {
            labelText = xLabels[index];
            
            NSInteger x = 1.0 * self.chartMargin +  (index * self.xLabelWidth) - (self.xLabelWidth / 2);
            NSInteger y = self.chartMargin + self.chartCavanHeight;
            
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(x, y, (NSInteger)self.xLabelWidth, (NSInteger)self.chartMargin)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [super setCustomStyleForXLabel:label];
            [self addSubview:label];
            [self.xChartLabels addObject:label];
        }
    }
}

-(void)prepareYLabelsWithData:(NSArray *)data
{
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    NSMutableArray *yLabelsArray = [NSMutableArray new];
    NSMutableArray *yMaxArray=[NSMutableArray new];
    NSMutableArray *yMinArray=[NSMutableArray new];
    
    for (PNLineChartData *chartData in data) {
        // create as many chart line layers as there are data-lines
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            CGFloat yValue = chartData.getData(i).y;
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
        [yMaxArray addObject:[NSNumber numberWithFloat:yMax]];
        [yMinArray addObject:[NSNumber numberWithFloat:yMin]];
    }
    
    
    // Min value for Y label
    for (int idx=0; idx<yMaxArray.count; idx++) {
        if ([yMaxArray[idx] floatValue] < 5) {
            [yMaxArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:5.0f]];
        }
        
    }
    
    for (int idx=0; idx<yMinArray.count; idx++) {
        if ([yMinArray[idx] floatValue] < 0) {
            [yMinArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithFloat:0.0f]];
        }
    }
    
//    _yValueMin = (_yFixedValueMin > -FLT_MAX) ? _yFixedValueMin : yMin ;
//    _yValueMax = (_yFixedValueMax > -FLT_MAX) ? _yFixedValueMax : yMax + yMax / 10.0;

    self.yValueMin = (self.yFixedValueMin > -FLT_MAX) ? self.yFixedValueMin : [yMinArray[0] floatValue] ;
    self.yValueMax = (self.yFixedValueMax > -FLT_MAX) ? self.yFixedValueMax : [yMaxArray[0] floatValue]+ [yMaxArray[0]floatValue] / 10.0;

    self.yValueMin2 = (self.yFixedValueMin2 > -FLT_MAX) ? self.yFixedValueMin2 : [yMinArray[1] floatValue] ;
    self.yValueMax2 = (self.yFixedValueMax2 > -FLT_MAX) ? self.yFixedValueMax2 : [yMaxArray[1] floatValue] + [yMaxArray[1] floatValue] / 10.0;

    
    
    if (self.showGenYLabels || _showGenYLabels2) {
        [self setYLabels];
    }
}

- (void)setYLabels
{
    if(self.showGenYLabels)
    [super setYLabels];
    if(_showGenYLabels2)
    [self setYLabels2];
}

- (void)setYLabels2
{
    CGFloat yStep = (_yValueMax2 - _yValueMin2) / _yLabelNum2;
    CGFloat yStepHeight = self.chartCavanHeight / _yLabelNum2;
    
    if (_yChartLabels2) {
        for (PNChartLabel * label in _yChartLabels2) {
            [label removeFromSuperview];
        }
    }else{
        _yChartLabels2 = [NSMutableArray new];
    }
    CGFloat labelX=self.frame.size.width  - self.chartMargin + 2.0;
    if (yStep == 0.0) {
        PNChartLabel *minLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(labelX, (NSInteger)self.chartCavanHeight, (NSInteger)self.chartMargin, (NSInteger)self.yLabelHeight)];
        minLabel.text = [self formatYLabel:0.0];
        [self setCustomStyleForYLabel:minLabel];
        [self addSubview:minLabel];
        [_yChartLabels2 addObject:minLabel];
        
        PNChartLabel *midLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(labelX, (NSInteger)(self.chartCavanHeight / 2), (NSInteger)self.chartMargin, (NSInteger)_yLabelHeight2)];
        midLabel.text = [self formatYLabel:_yValueMax2];
        [self setCustomStyleForYLabel:midLabel];
        [self addSubview:midLabel];
        [self.yChartLabels2 addObject:midLabel];
        
        PNChartLabel *maxLabel = [[PNChartLabel alloc] initWithFrame:CGRectMake(labelX, 0.0, (NSInteger)self.chartMargin, (NSInteger)self.yLabelHeight)];
        maxLabel.text = [self formatYLabel:self.yValueMax * 2];
        [self setCustomStyleForYLabel:maxLabel];
        [self addSubview:maxLabel];
        [_yChartLabels2 addObject:maxLabel];
        
    } else {
        NSInteger index = 0;
        NSInteger num = _yLabelNum2 + 1;
        //CGFloat labelX=self.frame.size.width  - self.chartMargin;
        
        while (num > 0)
        {
            PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(labelX, (NSInteger)(self.chartCavanHeight - index * yStepHeight), (NSInteger)self.chartMargin, (NSInteger)self.yLabelHeight)];
            [label setTextAlignment:NSTextAlignmentLeft];
            label.text = [self formatYLabel:_yValueMin2 + (yStep * index)];
            [self setCustomStyleForYLabel:label];
            [self addSubview:label];
            [_yChartLabels2 addObject:label];
            index += 1;
            num -= 1;
        }
    }

}

- (void)setYLabels2:(NSArray *)yLabels
{
        self.showGenYLabels2 = NO;
        _yLabelNum2 = yLabels.count - 1;
        
        CGFloat yLabelHeight;
        if (self.showLabel) {
            yLabelHeight = self.chartCavanHeight / [yLabels count];
        } else {
            yLabelHeight = (self.frame.size.height) / [yLabels count];
        }
        
        return [self setYLabels2:yLabels withHeight:yLabelHeight];
}

- (void)setYLabels2:(NSArray *)yLabels withHeight:(CGFloat)height
    {
        _yLabels2 = yLabels;
        _yLabelHeight2 = height;
        if (_yChartLabels2) {
            for (PNChartLabel * label in _yChartLabels2) {
                [label removeFromSuperview];
            }
        }else{
            _yChartLabels2 = [NSMutableArray new];
        }
        
        NSString *labelText;
        CGFloat labelX=self.frame.size.width  - self.chartMargin+2.0;
        if (self.showLabel) {
            CGFloat yStepHeight = self.chartCavanHeight / _yLabelNum2;
            
            for (int index = 0; index < yLabels.count; index++) {
                labelText = yLabels[index];
                
                NSInteger y = (NSInteger)(self.chartCavanHeight - index * yStepHeight);
                
                PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectMake(labelX, y, (NSInteger)self.chartMargin, (NSInteger)_yLabelHeight2)];
                [label setTextAlignment:NSTextAlignmentLeft];
                label.text = labelText;
                [self setCustomStyleForYLabel:label];
                [self addSubview:label];
                [_yChartLabels2 addObject:label];
            }
        }
    }



#pragma mark private methods

- (void)setupDefaultValues
{
    
    [super setupDefaultValues];
    _yFixedValueMax2 = -FLT_MAX;
    _yFixedValueMin2 = -FLT_MAX;
    _yLabelNum2 = 6;
    self.yAxisOffset = 0.0f;
    _chartYAxis2EndStyle = PNLineChartAxisEndStyleNone;
}



@end
