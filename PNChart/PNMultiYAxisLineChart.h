//
//  PNMutiYAxisLineChart.h
//  Asante
//
//  Created by David Chiu on 3/26/15.
//  Copyright (c) 2015 Asante. All rights reserved.
//

#import "PNLineChart.h"

@interface PNMultiYAxisLineChart : PNLineChart

// second set of y labels
@property (nonatomic) NSMutableArray *yChartLabels2;

@property (nonatomic) NSArray *yLabels2;


// configuration for second y axis
@property (nonatomic) CGFloat yValueMax2;
@property (nonatomic) CGFloat yFixedValueMax2;
@property (nonatomic) CGFloat yFixedValueMin2;
@property (nonatomic) CGFloat yValueMin2;
@property (nonatomic) NSInteger yLabelNum2;
@property (nonatomic) CGFloat yLabelHeight2;
@property (nonatomic) UIFont *yLabelFont2;
@property (nonatomic) UIColor *yLabelColor2;
@property (nonatomic, strong) NSString *yUnit2;
@property (nonatomic) BOOL showGenYLabels2;

@property (nonatomic, assign ) PNLineChartAxisEndStyle chartYAxis2EndStyle;

@end
