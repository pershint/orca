//--------------------------------------------------------
// ORRGA300Controller
// Created by Mark  A. Howe on Tues Jan 4, 2012
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2012 CENPA, University of Washington. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of 
//Washington at the Center for Experimental Nuclear Physics and 
//Astrophysics (CENPA) sponsored in part by the United States 
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020. 
//The University has certain rights in the program pursuant to 
//the contract and the program should not be copied or distributed 
//outside your organization.  The DOE and the University of 
//Washington reserve all rights in the program. Neither the authors,
//University of Washington, or U.S. Government make any warranty, 
//express or implied, or assume any liability or responsibility 
//for the use of this software.
//-------------------------------------------------------------

#pragma mark •••Imported Files

#import "ORRGA300Controller.h"
#import "ORRGA300Model.h"
#import "OR1DHistoPlot.h"
#import "ORCompositePlotView.h"
#import "ORSerialPort.h"
#import "ORSerialPortController.h"
#import "ORAxis.h"
#import "ORPlot.h"

@implementation ORRGA300Controller

#pragma mark •••Initialization

- (id) init
{
	self = [super initWithWindowNibName:@"RGA300"];
	return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) awakeFromNib
{	
    [[plotter yAxis] setRngLow:0.0 withHigh:1000.];
	[[plotter yAxis] setRngLimitsLow:0.0 withHigh:1000000000 withMinRng:10];
	[plotter setUseGradient:YES];
	
    [[plotter xAxis] setRngLow:0.0 withHigh:300];
	[[plotter xAxis] setRngLimitsLow:0.0 withHigh:300 withMinRng:10];
	
	[detailsButton setTitle:@"Show Details"];
	
	[super awakeFromNib];	
	//[model getPressure];
}

#pragma mark •••Notifications

- (void) registerNotificationObservers
{
	NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    [super registerNotificationObservers];
	

    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORRunStatusChangedNotification
                       object : nil];
    
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORRGA300Lock
                        object: nil];

    [notifyCenter addObserver : self
					 selector : @selector(scaleAction:)
						 name : ORAxisRangeChangedNotification
					   object : nil];
	
    [notifyCenter addObserver : self
					 selector : @selector(miscAttributesChanged:)
						 name : ORMiscAttributesChanged
					   object : model];
	
    [notifyCenter addObserver : self
                     selector : @selector(modelNumberChanged:)
                         name : ORRGA300ModelModelNumberChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(firmwareVersionChanged:)
                         name : ORRGA300ModelFirmwareVersionChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(serialNumberChanged:)
                         name : ORRGA300ModelSerialNumberChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(statusWordChanged:)
                         name : ORRGA300ModelStatusWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(psErrWordChanged:)
                         name : ORRGA300ModelPsErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(detErrWordChanged:)
                         name : ORRGA300ModelDetErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(qmfErrWordChanged:)
                         name : ORRGA300ModelQmfErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(cemErrWordChanged:)
                         name : ORRGA300ModelCemErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(filErrWordChanged:)
                         name : ORRGA300ModelFilErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(rs232ErrWordChanged:)
                         name : ORRGA300ModelRs232ErrWordChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerDegassTimeChanged:)
                         name : ORRGA300ModelIonizerDegassTimeChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerElectronEnergyChanged:)
                         name : ORRGA300ModelIonizerElectronEnergyChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerEmissionCurrentChanged:)
                         name : ORRGA300ModelIonizerEmissionCurrentChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerIonEnergyChanged:)
                         name : ORRGA300ModelIonizerIonEnergyChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerFocusPlateVoltageChanged:)
                         name : ORRGA300ModelIonizerFocusPlateVoltageChanged
						object: model];
    [notifyCenter addObserver : self
                     selector : @selector(elecMultHVBiasChanged:)
                         name : ORRGA300ModelElecMultHVBiasChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(noiseFloorSettingChanged:)
                         name : ORRGA300ModelNoiseFloorSettingChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(analogScanPointsChanged:)
                         name : ORRGA300ModelAnalogScanPointsChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(histoScanPointsChanged:)
                         name : ORRGA300ModelHistoScanPointsChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(finalMassChanged:)
                         name : ORRGA300ModelFinalMassChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(initialMassChanged:)
                         name : ORRGA300ModelInitialMassChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(stepsPerAmuChanged:)
                         name : ORRGA300ModelStepsPerAmuChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(numberScansChanged:)
                         name : ORRGA300ModelNumberScansChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(measuredIonCurrentChanged:)
                         name : ORRGA300ModelMeasuredIonCurrentChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(electronMultiOptionChanged:)
                         name : ORRGA300ModelElectronMultiOptionChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(elecMultGainChanged:)
                         name : ORRGA300ModelElecMultGainChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerFilamentCurrentRBChanged:)
                         name : ORRGA300ModelIonizerFilamentCurrentRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerElectronEnergyRBChanged:)
                         name : ORRGA300ModelIonizerElectronEnergyRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerIonEnergyRBChanged:)
                         name : ORRGA300ModelIonizerIonEnergyRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(ionizerFocusPlateVoltageRBChanged:)
                         name : ORRGA300ModelIonizerFocusPlateVoltageRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(noiseFloorSettingRBChanged:)
                         name : ORRGA300ModelNoiseFloorSettingRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(elecMultHVBiasRBChanged:)
                         name : ORRGA300ModelElecMultHVBiasRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(elecMultGainRBChanged:)
                         name : ORRGA300ModelElecMultGainRBChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(opModeChanged:)
                         name : ORRGA300ModelOpModeChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(currentActivityChanged:)
                         name : ORRGA300ModelCurrentActivityChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(scanProgressChanged:)
                         name : ORRGA300ModelScanProgressChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(scanNumberChanged:)
                         name : ORRGA300ModelScanNumberChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(scanDataChanged:)
                         name : ORRGA300ModelScanDataChanged
						object: model];

	[notifyCenter addObserver : self
                     selector : @selector(drawDidClose:)
                         name : NSDrawerDidCloseNotification
                       object : errorDrawer];
	
	[notifyCenter addObserver : self
                     selector : @selector(drawDidOpen:)
                         name : NSDrawerDidOpenNotification
                       object : errorDrawer];
	
	[notifyCenter addObserver : self
                     selector : @selector(amuCountChanged:)
                         name : ORRGA300ModelAmuRemoved
                       object : model];	

	[notifyCenter addObserver : self
                     selector : @selector(amuCountChanged:)
                         name : ORRGA300ModelAmuAdded
                       object : model];	

	[notifyCenter addObserver : self
                     selector : @selector(currentAmuIndexChanged:)
                         name : ORRGA300ModelCurrentAmuIndexChanged
                       object : model];	
	
}
- (void) amuCountChanged:(NSNotification*)aNote
{
	[amuTable reloadData];
}

- (void) drawDidOpen:(NSNotification*)aNote
{
	[detailsButton setTitle:@"Hide Details"];
}

- (void) drawDidClose:(NSNotification*)aNote
{
	[detailsButton setTitle:@"Show Details"];
}

- (void) setModel:(id)aModel
{
	[super setModel:aModel];
	[[self window] setTitle:[NSString stringWithFormat:@"DCU (%d)",[model uniqueIdNumber]]];
}

- (void) updateWindow
{
    [super updateWindow];
    [self lockChanged:nil];

    [self miscAttributesChanged:nil];

	[self modelNumberChanged:nil];
	[self firmwareVersionChanged:nil];
	[self serialNumberChanged:nil];
	[self statusWordChanged:nil];
	[self psErrWordChanged:nil];
	[self detErrWordChanged:nil];
	[self qmfErrWordChanged:nil];
	[self cemErrWordChanged:nil];
	[self filErrWordChanged:nil];
	[self rs232ErrWordChanged:nil];
	[self ionizerDegassTimeChanged:nil];
	[self ionizerElectronEnergyChanged:nil];
	[self ionizerEmissionCurrentChanged:nil];
	[self ionizerIonEnergyChanged:nil];
	[self ionizerFocusPlateVoltageChanged:nil];
	[self elecMultHVBiasChanged:nil];
	[self noiseFloorSettingChanged:nil];
	[self analogScanPointsChanged:nil];
	[self histoScanPointsChanged:nil];
	[self finalMassChanged:nil];
	[self initialMassChanged:nil];
	[self stepsPerAmuChanged:nil];
	[self numberScansChanged:nil];
	[self measuredIonCurrentChanged:nil];
	[self electronMultiOptionChanged:nil];
	[self elecMultGainChanged:nil];
	
	[self ionizerFilamentCurrentRBChanged:nil];
	[self ionizerElectronEnergyRBChanged:nil];
	[self ionizerIonEnergyRBChanged:nil];
	[self ionizerFocusPlateVoltageRBChanged:nil];
	[self noiseFloorSettingRBChanged:nil];
	[self elecMultHVBiasRBChanged:nil];
	[self elecMultGainRBChanged:nil];
	[self opModeChanged:nil];
	[self currentActivityChanged:nil];
	[self scanProgressChanged:nil];
	[self scanNumberChanged:nil];
	[self scanDataChanged:nil];
	[self amuCountChanged:nil];
	[self currentAmuIndexChanged:nil];
}

- (void) scanDataChanged:(NSNotification*)aNote
{
	[plotter setNeedsDisplay:YES];;
}

- (void) currentAmuIndexChanged:(NSNotification*)aNote
{
	if([model currentActivity]==kRGAIdle)[currentAmuIndexField setStringValue:@""];
	else {
		[currentAmuIndexField setStringValue: [NSString stringWithFormat:@"Index: %d/%d",[model currentAmuIndex],[model amuCount]]];
	}
}

- (void) scanNumberChanged:(NSNotification*)aNote
{
	if([model currentActivity]==kRGAIdle)[scanNumberField setStringValue:@"Idle"];
	else [scanNumberField setStringValue: [NSString stringWithFormat:@"Scan %d/%d",[model scanNumber],[model numberScans]]];
}

- (void) scanProgressChanged:(NSNotification*)aNote
{
	[scanProgressBar setDoubleValue: [model scanProgress]];
}

- (void) currentActivityChanged:(NSNotification*)aNote
{
}

- (void) opModeChanged:(NSNotification*)aNote
{
	[opModePU selectItemAtIndex: [model opMode]];
	[self updateButtons];
}

- (void) elecMultGainRBChanged:(NSNotification*)aNote
{
	[elecMultGainRBField setFloatValue: [model elecMultGainRB]];
}

- (void) elecMultHVBiasRBChanged:(NSNotification*)aNote
{
	float hvBias = [model elecMultHVBiasRB];
	if(hvBias==0){
		[elecMultHVBiasRBField setStringValue:@"OFF"];
	}
	else [elecMultHVBiasRBField setFloatValue: [model elecMultHVBiasRB]];
	[self updateButtons];
}

- (void) noiseFloorSettingRBChanged:(NSNotification*)aNote
{
	[noiseFloorSettingRBField setIntValue: [model noiseFloorSettingRB]];
}

- (void) ionizerFocusPlateVoltageRBChanged:(NSNotification*)aNote
{
	[ionizerFocusPlateVoltageRBField setIntValue: [model ionizerFocusPlateVoltageRB]];
}

- (void) ionizerIonEnergyRBChanged:(NSNotification*)aNote
{
	[ionizerIonEnergyRBField setStringValue: ([model ionizerIonEnergyRB] == 0)?@"8":@"12"];
}

- (void) ionizerElectronEnergyRBChanged:(NSNotification*)aNote
{
	[ionizerElectronEnergyRBField setIntValue: [model ionizerElectronEnergyRB]];
}

- (void) ionizerFilamentCurrentRBChanged:(NSNotification*)aNote
{
	float filamentCurrent = [model ionizerFilamentCurrentRB];
	if(filamentCurrent==0){
		[ionizerFilamentCurrentRBField setStringValue:@"OFF"];
	}
	else [ionizerFilamentCurrentRBField setFloatValue: [model ionizerFilamentCurrentRB]];
	[self updateButtons];
}

- (void) elecMultGainChanged:(NSNotification*)aNote
{
	[elecMultGainField setFloatValue: [model elecMultGain]];
}

- (void) electronMultiOptionChanged:(NSNotification*)aNote
{
	[electronMultiOptionField setStringValue: [model electronMultiOption]?@"":@"NO CDEM Option"];
	[self updateButtons];
}

- (void) measuredIonCurrentChanged:(NSNotification*)aNote
{
	[measuredIonCurrentField setIntValue: [model measuredIonCurrent]];
}

- (void) numberScansChanged:(NSNotification*)aNote
{
	[numberScansField setIntValue: [model numberScans]];
}

- (void) stepsPerAmuChanged:(NSNotification*)aNote
{
	[stepsPerAmuField setIntValue: [model stepsPerAmu]];
}

- (void) initialMassChanged:(NSNotification*)aNote
{
	[initialMassField setIntValue: [model initialMass]];
}

- (void) finalMassChanged:(NSNotification*)aNote
{
	[finalMassField setIntValue: [model finalMass]];
}

- (void) histoScanPointsChanged:(NSNotification*)aNote
{
	[histoScanPointsField setIntValue: [model histoScanPoints]];
}

- (void) analogScanPointsChanged:(NSNotification*)aNote
{
	[analogScanPointsField setIntValue: [model analogScanPoints]];
}

- (void) noiseFloorSettingChanged:(NSNotification*)aNote
{
	[noiseFloorSettingField setIntValue: [model noiseFloorSetting]];
}

- (void) elecMultHVBiasChanged:(NSNotification*)aNote
{
	[elecMultHVBiasField setIntValue: [model elecMultHVBias]];
}

- (void) ionizerFocusPlateVoltageChanged:(NSNotification*)aNote
{
	[ionizerFocusPlateVoltageField setIntValue: [model ionizerFocusPlateVoltage]];
}

- (void) ionizerIonEnergyChanged:(NSNotification*)aNote
{
	[ionizerIonEnergyPU selectItemAtIndex: [model ionizerIonEnergy]];
}

- (void) ionizerEmissionCurrentChanged:(NSNotification*)aNote
{
	[ionizerEmissionCurrentField setFloatValue: [model ionizerEmissionCurrent]];
}

- (void) ionizerElectronEnergyChanged:(NSNotification*)aNote
{
	[ionizerElectronEnergyField setIntValue: [model ionizerElectronEnergy]];
}

- (void) ionizerDegassTimeChanged:(NSNotification*)aNote
{
	[ionizerDegassTimeField setIntValue: [model ionizerDegassTime]];
}

- (void) rs232ErrWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
		
	int mask = [model rs232ErrWord];
	[[rs232ErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGABadCmd)			? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGABadParam)			? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:2 column:0] setStringValue:(mask & kRGACmdTooLong)		? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:3 column:0] setStringValue:(mask & kRGAOverWrite)		? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:4 column:0] setStringValue:(mask & kRGATransOverWrite)	? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:5 column:0] setStringValue:(mask & kRGAJumper)			? @"YES":@"NO"];
	[[rs232ErrWordMatrix cellAtRow:6 column:0] setStringValue:(mask & kRGAParamConflict)	? @"YES":@"NO"];
	
	[[rs232ErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGABadCmd)			? bad:good];
	[[rs232ErrWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGABadParam)		? bad:good];
	[[rs232ErrWordMatrix cellAtRow:2 column:0] setTextColor:(mask & kRGACmdTooLong)		? bad:good];
	[[rs232ErrWordMatrix cellAtRow:3 column:0] setTextColor:(mask & kRGAOverWrite)		? bad:good];
	[[rs232ErrWordMatrix cellAtRow:4 column:0] setTextColor:(mask & kRGATransOverWrite)	? bad:good];
	[[rs232ErrWordMatrix cellAtRow:5 column:0] setTextColor:(mask & kRGAJumper)			? bad:good];
	[[rs232ErrWordMatrix cellAtRow:6 column:0] setTextColor:(mask & kRGAParamConflict)	? bad:good];
}


- (void) filErrWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model filErrWord];
	[[filErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGAFILSingleFilament)		? @"YES":@"NO"];
	[[filErrWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGAFILPressureTooHigh)		? @"YES":@"NO"];
	[[filErrWordMatrix cellAtRow:2 column:0] setStringValue:(mask & kRGAFILCannotSetCurrent)	? @"YES":@"NO"];
	[[filErrWordMatrix cellAtRow:3 column:0] setStringValue:(mask & kRGAFILNoFilament)			? @"YES":@"NO"];
	
	[[filErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGAFILSingleFilament)		? bad:good];
	[[filErrWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGAFILPressureTooHigh)		? bad:good];
	[[filErrWordMatrix cellAtRow:2 column:0] setTextColor:(mask & kRGAFILCannotSetCurrent)		? bad:good];
	[[filErrWordMatrix cellAtRow:3 column:0] setTextColor:(mask & kRGAFILNoFilament)			? bad:good];
}



- (void) cemErrWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model cemErrWord];
	[[cemErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGACEMNoElecMultiOption)	? @"YES":@"NO"];
	
	[[cemErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGACEMNoElecMultiOption)		? bad:good];
}


- (void) qmfErrWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model qmfErrWord];
	[[qmfErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGAQMFCurrentLimited)	? @"YES":@"NO"];
	[[qmfErrWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGAQMFCurrentTooHigh)	? @"YES":@"NO"];
	[[qmfErrWordMatrix cellAtRow:2 column:0] setStringValue:(mask & kRGAQMFRF_CTTooHigh)	? @"YES":@"NO"];
	
	[[qmfErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGAQMFCurrentLimited)	? bad:good];
	[[qmfErrWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGAQMFCurrentTooHigh)	? bad:good];
	[[qmfErrWordMatrix cellAtRow:2 column:0] setTextColor:(mask & kRGAQMFRF_CTTooHigh)		? bad:good];	
}

- (void) detErrWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model detErrWord];
	[[detErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGADetOpAmpOffset)		? @"Failed":@"Passed"];
	[[detErrWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGADetCompNegInput)	? @"BAD":@"OK"];
	[[detErrWordMatrix cellAtRow:2 column:0] setStringValue:(mask & kRGADetCompPosInput)	? @"BAD":@"OK"];
	[[detErrWordMatrix cellAtRow:3 column:0] setStringValue:(mask & kRGADetDetNegInput)		? @"BAD":@"OK"];
	[[detErrWordMatrix cellAtRow:4 column:0] setStringValue:(mask & kRGADetDetPosInput)		? @"BAD":@"OK"];
	[[detErrWordMatrix cellAtRow:5 column:0] setStringValue:(mask & kRGADetAdcFailure)		? @"BAD":@"OK"];
	
	[[detErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGADetOpAmpOffset)		? bad:good];
	[[detErrWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGADetCompNegInput)		? bad:good];
	[[detErrWordMatrix cellAtRow:2 column:0] setTextColor:(mask & kRGADetCompPosInput)		? bad:good];
	[[detErrWordMatrix cellAtRow:3 column:0] setTextColor:(mask & kRGADetDetNegInput)		? bad:good];
	[[detErrWordMatrix cellAtRow:4 column:0] setTextColor:(mask & kRGADetDetPosInput)		? bad:good];
	[[detErrWordMatrix cellAtRow:5 column:0] setTextColor:(mask & kRGADetAdcFailure)		? bad:good];
}

- (void) psErrWordChanged:(NSNotification*)aNote
{
	
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model qmfErrWord];
	[[psErrWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGAPSExtPowerTooLow)	? @"YES":@"NO"];
	[[psErrWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGAPSExtPowerTooHigh)	? @"YES":@"NO"];
	
	[[psErrWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGAPSExtPowerTooLow)	? bad:good];
	[[psErrWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGAPSExtPowerTooHigh)	? bad:good];
}


- (void) statusWordChanged:(NSNotification*)aNote
{
	NSColor* bad  = [NSColor colorWithDeviceRed:.75 green:0 blue:0 alpha:1];
	NSColor* good = [NSColor colorWithDeviceRed:0 green:.75 blue:0 alpha:1];
	
	int mask = [model statusWord];
	[[statusWordMatrix cellAtRow:0 column:0] setStringValue:(mask & kRGACommStatusMask)			 ? @"BAD":@"OK"];
	[[statusWordMatrix cellAtRow:1 column:0] setStringValue:(mask & kRGAFilamentStatusMask)		 ? @"BAD":@"OK"];
	[[statusWordMatrix cellAtRow:2 column:0] setStringValue:(mask & kRGAElectronMultiStatusMask) ? @"BAD":@"OK"];
	[[statusWordMatrix cellAtRow:3 column:0] setStringValue:(mask & kRGAQMFStatusMask)			 ? @"BAD":@"OK"];
	[[statusWordMatrix cellAtRow:4 column:0] setStringValue:(mask & kRGAElectrometerStatusMask)	 ? @"BAD":@"OK"];
	[[statusWordMatrix cellAtRow:5 column:0] setStringValue:(mask & kRGA24VStatusMask)			 ? @"BAD":@"OK"];

	[[statusWordMatrix cellAtRow:0 column:0] setTextColor:(mask & kRGACommStatusMask)			? bad:good];
	[[statusWordMatrix cellAtRow:1 column:0] setTextColor:(mask & kRGAFilamentStatusMask)		? bad:good];
	[[statusWordMatrix cellAtRow:2 column:0] setTextColor:(mask & kRGAElectronMultiStatusMask)	? bad:good];
	[[statusWordMatrix cellAtRow:3 column:0] setTextColor:(mask & kRGAQMFStatusMask)			? bad:good];
	[[statusWordMatrix cellAtRow:4 column:0] setTextColor:(mask & kRGAElectrometerStatusMask)	? bad:good];
	[[statusWordMatrix cellAtRow:5 column:0] setTextColor:(mask & kRGA24VStatusMask)			? bad:good];
	
}

- (void) serialNumberChanged:(NSNotification*)aNote
{
	[serialNumberField setIntValue: [model serialNumber]];
}

- (void) firmwareVersionChanged:(NSNotification*)aNote
{
	[firmwareVersionField setFloatValue: [model firmwareVersion]];
}

- (void) modelNumberChanged:(NSNotification*)aNote
{
	[modelNumberField setIntValue: [model modelNumber]];
}

- (void) scaleAction:(NSNotification*)aNotification
{
	if(aNotification == nil || [aNotification object] == [plotter xAxis]){
		[model setMiscAttributes:[(ORAxis*)[plotter xAxis]attributes] forKey:@"XAttributes0"];
	}
	
	if(aNotification == nil || [aNotification object] == [plotter yAxis]){
		[model setMiscAttributes:[(ORAxis*)[plotter yAxis]attributes] forKey:@"YAttributes0"];
	}
}

- (void) miscAttributesChanged:(NSNotification*)aNote
{
	
	NSString*				key = [[aNote userInfo] objectForKey:ORMiscAttributeKey];
	NSMutableDictionary* attrib = [model miscAttributesForKey:key];
	
	if(aNote == nil || [key isEqualToString:@"XAttributes0"]){
		if(aNote==nil)attrib = [model miscAttributesForKey:@"XAttributes0"];
		if(attrib){
			[(ORAxis*)[plotter xAxis] setAttributes:attrib];
			[plotter setNeedsDisplay:YES];
			[[plotter xAxis] setNeedsDisplay:YES];
		}
	}
	if(aNote == nil || [key isEqualToString:@"YAttributes0"]){
		if(aNote==nil)attrib = [model miscAttributesForKey:@"YAttributes0"];
		if(attrib){
			[(ORAxis*)[plotter yAxis] setAttributes:attrib];
			[plotter setNeedsDisplay:YES];
			[[plotter yAxis] setNeedsDisplay:YES];
		}
	}
	
}

- (void) checkGlobalSecurity
{
    BOOL secure = [[[NSUserDefaults standardUserDefaults] objectForKey:OROrcaSecurityEnabled] boolValue];
    [gSecurity setLock:ORRGA300Lock to:secure];
    [lockButton setEnabled:secure];
}

- (void) lockChanged:(NSNotification*)aNotification
{
	[self updateButtons];
}

- (BOOL) portLocked
{
	return [gSecurity isLocked:ORRGA300Lock];;
}

- (void) updateButtons
{
    BOOL locked = [gSecurity isLocked:ORRGA300Lock];
	//BOOL portOpen = [[model serialPort] isOpen];
	BOOL opIsRunning = [model currentActivity] != kRGAIdle;
    [lockButton setState: locked];
	[serialPortController updateButtons:locked];
	[elecMultHVBiasField		setEnabled: [model electronMultiOption] && !locked];
	[elecMultGainField			setEnabled: [model electronMultiOption] && !locked];
	[elecMultHVBiasOnOffButton	setEnabled: [model electronMultiOption] && !locked];
	
	[ionizerIonEnergyPU				setEnabled:!locked];
	[ionizerElectronEnergyField		setEnabled:!locked];
	[ionizerFocusPlateVoltageField	setEnabled:!locked];
	[ionizerEmissionCurrentField	setEnabled:!locked];

	[noiseFloorSettingField			setEnabled:!locked];
	[filamentOnOffButton			setEnabled:!locked];

	[filamentOnOffButton		setTitle:[model ionizerFilamentCurrentRB] ? @"Turn OFF" : @"Turn ON"];
	[elecMultHVBiasOnOffButton	setTitle:[model elecMultHVBiasRB]		  ? @"Turn OFF" : @"Turn ON"];

	[initialMassField setEnabled:	[model opMode] != kRGATableMode];
	[finalMassField setEnabled:		[model opMode] != kRGATableMode];
	[stepsPerAmuField setEnabled:	[model opMode] != kRGATableMode];
	
	[addAmuButton    setEnabled:!locked && !opIsRunning];
	[removeAmuButton setEnabled:!locked && !opIsRunning];
}

#pragma mark •••Actions
- (IBAction) queryAllAction:(id)sender					{ [model queryAll]; }
- (IBAction) opModeAction:(id)sender					{ [model setOpMode:						[sender indexOfSelectedItem]];	}
- (IBAction) ionizerIonEnergyAction:(id)sender			{ [model setIonizerIonEnergy:			[sender indexOfSelectedItem]]; }
- (IBAction) elecMultGainAction:(id)sender				{ [model setElecMultGain:				[sender floatValue]];	}
- (IBAction) numberScansAction:(id)sender				{ [model setNumberScans:				[sender intValue]]; }
- (IBAction) stepsPerAmuAction:(id)sender				{ [model setStepsPerAmu:				[sender intValue]]; }
- (IBAction) initialMassAction:(id)sender				{ [model setInitialMass:				[sender intValue]]; }
- (IBAction) finalMassAction:(id)sender					{ [model setFinalMass:					[sender intValue]]; }
- (IBAction) noiseFloorSettingAction:(id)sender			{ [model setNoiseFloorSetting:			[sender intValue]]; }
- (IBAction) elecMultHVBiasAction:(id)sender			{ [model setElecMultHVBias:				[sender intValue]]; }
- (IBAction) ionizerDegassTimeAction:(id)sender			{ [model setIonizerDegassTime:			[sender intValue]]; }
- (IBAction) ionizerFocusPlateVoltageAction:(id)sender	{ [model setIonizerFocusPlateVoltage:	[sender intValue]]; }
- (IBAction) ionizerEmissionCurrentAction:(id)sender	{ [model setIonizerEmissionCurrent:		[sender floatValue]]; }
- (IBAction) ionizerElectronEnergyAction:(id)sender		{ [model setIonizerElectronEnergy:		[sender intValue]]; }

- (IBAction) toggleHVBias:(id)sender		
{ 
	if([model elecMultHVBiasRB]>0) [model turnHVBiasOFF];
	else [model sendHVBias];
}

- (IBAction) lockAction:(id) sender						
{ 
	[gSecurity tryToSetLock:ORRGA300Lock to:[sender intValue] forWindow:[self window]]; 
}

- (IBAction) resetAction:(id)sender
{
	[model sendReset];
}

- (IBAction) standByAction:(id)sender
{
	[model sendStandBy];
}

- (IBAction) degassAction:(id)sender
{
//	int activity = [model activityInProgress];
//	if(activity){
//		if(activity == kRGADegassInProgress)[model startDegassing];
//		[model stopDegassing];
//	}
}

- (IBAction) syncDialogAction:(id)sender
{ 
	[self endEditing];
    NSBeginAlertSheet(@"Sync Dialog",
					  @"YES/Do it",
					  @"Cancel",
					  nil,[self window],
					  self,
					  @selector(_syncSheetDidEnd:returnCode:contextInfo:),
					  nil,
					  nil,
					  @"Really transfer the actual HW values to the input fields of this dialog?");
	
}

- (void) _syncSheetDidEnd:(id)sheet returnCode:(int)returnCode contextInfo:(id)userInfo
{
	if(returnCode == NSAlertDefaultReturn){
		[model syncWithHW]; 
	}
}

- (IBAction) startMeasurementAction:(id)sender
{ 
	[model startMeasurement];
	[self setupPlotter];
}

- (IBAction) stopMeasurementAction:(id)sender
{ 
	[model stopMeasurement];
}

- (IBAction) addAmuAction:(id)sender
{
	[model addAmu];
}

- (IBAction) removeAmuAction:(id)sender
{
	NSIndexSet* theSet = [amuTable selectedRowIndexes];
	NSUInteger current_index = [theSet firstIndex];
    if(current_index != NSNotFound){
		[model removeAmuAtIndex:current_index];
	}
	[self updateButtons];
}

#pragma mark •••Data Source
- (int) numberPointsInPlot:(id)aPlot
{
	if([model opMode] == kRGATableMode){
		int tag = [aPlot tag];
		if(tag>=0 && tag<[model amuCount]){
			return [model countsInAmuTableData:tag];
		}
		else return 0;
	}
	else {
		return [model numberPointsInScan];
	}
}

- (void) plotter:(id)aPlot index:(int)i x:(double*)xValue y:(double*)yValue
{
	if([model opMode] == kRGATableMode){
		*xValue = i;
		*yValue = [model amuTable:[aPlot tag] valueAtIndex:i];
	}
	else {
		*xValue = i;
		*yValue = [model scanValueAtIndex:i];
	}

	
}

- (int) numberOfRowsInTableView:(NSTableView *)tableView
{
	return [model amuCount];
}

- (id) tableView:(NSTableView*)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	return [model amuAtIndex:row];
}

- (void) tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{
	[model replaceAmuAtIndex:rowIndex withAmu:anObject];
}

- (void) setupPlotter
{
	[plotter removeAllPlots];
	if([model opMode] == kRGATableMode){
		[plotter setXLabel:@"Scan"];
		int i;
		for(i=0;i<[model amuCount];i++){
			NSColor* theColor;
			switch (i%10){
				case 0: theColor = [NSColor redColor]; break;
				case 1: theColor = [NSColor blueColor]; break;
				case 2: theColor = [NSColor purpleColor]; break;
				case 3: theColor = [NSColor brownColor]; break;
				case 4: theColor = [NSColor greenColor]; break;
				case 5: theColor = [NSColor blackColor]; break;
				case 6: theColor = [NSColor cyanColor]; break;
				case 7: theColor = [NSColor orangeColor]; break;
				case 8: theColor = [NSColor magentaColor]; break;
				case 9: theColor = [NSColor yellowColor]; break;
				default: theColor = [NSColor redColor]; break;
			}
			
			OR1DHistoPlot* aPlot = [[OR1DHistoPlot alloc] initWithTag:i andDataSource:self];
			[plotter addPlot: aPlot];
			[aPlot setLineColor:theColor];
			[plotter setPlot:i name:[NSString stringWithFormat:@"%d",[[model amuAtIndex:i]intValue]]];
			[aPlot release];
		}
		[plotter setShowLegend:YES];
	}
	else {
		OR1DHistoPlot* aPlot = [[OR1DHistoPlot alloc] initWithTag:0 andDataSource:self];
		[plotter addPlot: aPlot];
		[aPlot release];
		[plotter setShowLegend:NO];
		[plotter setXLabel:@"AMU"];
	}	
}

@end
