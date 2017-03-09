//
//  FMKNaviStruct.h
//  FMMapKit
//
//  Created by fengmap on 16/8/19.
//  Copyright © 2016年 Fengmap. All rights reserved.
//

#ifndef FMKNaviStruct_h
#define FMKNaviStruct_h


typedef NS_ENUM(NSInteger, FMKConstraintType)
{
	FMKCONSTRAINT_SUCCESS = 1,
	FMKCONSTRAINT_FAILED_NO_NAVIDATAS,
	FMKCONSTRAINT_FAILED_NO_CONSTRAINT,
	FMKCONSTRAINT_ERROR
};

typedef struct FMKNaviContraintResult
{
	FMKConstraintType type;
	FMKMapPoint mapPoint;
	int index;
	float distance;
	
}FMKNaviContraintResult;

typedef struct FMKNaviRoad
{
	int indentifier;//标识ID
	int startID;//起点节点ID
	int endID;//终点节点ID
	double length;//路径长度
	int type;//权重
	FMKMapPoint start;//起点
	FMKMapPoint end;//终点
	
}FMKNaviRoad;

typedef struct FMKConstraintRoadInfo
{
	FMKNaviRoad naviRoad;
	float distance;
	
}FMKConstraintRoadInfo;

typedef struct FMKNaviContraintPara
{
	FMKNaviRoad naviRoad;
	float distance;
	FMKMapPoint mapPoint;
	char valid;
	FMKConstraintType resultType;
	
}FMKNaviContraintPara;

typedef  struct FMKNaviConstraintRoadResult
{
	FMKNaviContraintResult result;
	FMKConstraintRoadInfo roadInfo;
	
}FMKNaviConstraintRoadResult;

#endif /* FMKNaviStruct_h */
