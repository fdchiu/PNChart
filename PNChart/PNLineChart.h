//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChartDelegate.h"
#import "PNGenericChart.h"

typedef NS_ENUM(NSUInteger, PNLineChartAxisEndStyle) {
    PNLineChartAxisEndStyleNone = 0,
    PNLineChartAxisEndStyleArrow = 1
};

@interface PNLineChart : PNGenericChart

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;

/**
 * Array of `LineChartData` objects, one for each line.
 */
@property (nonatomic) NSArray *chartData;

@property (nonatomic) NSMutableArray *pathPoints;
@property (nonatomic) NSMutableArray *xChartLabels;
@property (nonatomic) NSMutableArray *yChartLabels;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) UIFont *xLabelFont;
@property (nonatomic) UIColor *xLabelColor;
@property (nonatomic) CGFloat yValueMax;
@property (nonatomic) CGFloat yFixedValueMax;
@property (nonatomic) CGFloat yFixedValueMin;
@property (nonatomic) CGFloat yValueMin;
@property (nonatomic) NSInteger yLabelNum;
@property (nonatomic) CGFloat yLabelHeight;
@property (nonatomic) UIFont *yLabelFont;
@property (nonatomic) UIColor *yLabelColor;
@property (nonatomic) CGFloat chartCavanHeight;
@property (nonatomic) CGFloat chartCavanWidth;
@property (nonatomic) CGFloat chartMargin;
@property (nonatomic) BOOL showLabel;
@property (nonatomic) BOOL showGenYLabels;
@property (nonatomic) BOOL thousandsSeparator;


/**
 * Controls whether to show the coordinate axis. Default is NO.
 */
@property (nonatomic, getter = isShowCoordinateAxis) BOOL showCoordinateAxis;
@property (nonatomic) UIColor *axisColor;
@property (nonatomic) CGFloat axisWidth;
@property (nonatomic) CGFloat yAxisOffset;


@property (nonatomic, strong) NSString *xUnit;
@property (nonatomic, strong) NSString *yUnit;

/**
 * String formatter for float values in y-axis labels. If not set, defaults to @"%1.f"
 */
@property (nonatomic, strong) NSString *yLabelFormat;



@property (nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property (nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property (nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property (nonatomic) NSMutableArray *pointPath;       // Array of point path, one for each line
@property (nonatomic) NSMutableArray *endPointsOfPath;      // Array of start and end points of each line path, one for each line

/*
 *
 */

@property (nonatomic, assign ) PNLineChartAxisEndStyle chartXAxisEndStyle;
@property (nonatomic, assign ) PNLineChartAxisEndStyle chartYAxisEndStyle;


- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width;
- (NSString*) formatYLabel:(double)value;
- (void)setCustomStyleForYLabel:(UILabel *)label;
- (void)setCustomStyleForXLabel:(UILabel *)label;
- (void)drawTextInContext:(CGContextRef )ctx text:(NSString *)text inRect:(CGRect)rect font:(UIFont *)font;
/**
 * Update Chart Value
 */

- (void)updateChartData:(NSArray *)data;


/**
 *  returns the Legend View, or nil if no chart data is present. 
 *  The origin of the legend frame is 0,0 but you can set it with setFrame:(CGRect)
 *
 *  @param mWidth Maximum width of legend. Height will depend on this and font size
 *
 *  @return UIView of Legend
 */
- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth;


+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font;

- (void)setYLabels;
@end
