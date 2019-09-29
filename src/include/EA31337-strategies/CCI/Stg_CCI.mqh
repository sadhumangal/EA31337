//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements CCI strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_CCI.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_CCI : public Strategy {

  public:

  void Stg_CCI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_CCI *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams cci_iparams(10, INDI_CCI);
    CCI_Params cci1_iparams(CCI_Period_M1, CCI_Applied_Price);
    StgParams cci1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_CCI(cci1_iparams, cci_iparams, cparams1), NULL, NULL);
    cci1_sparams.SetSignals(CCI1_SignalMethod, CCI1_OpenCondition1, CCI1_OpenCondition2, CCI1_CloseCondition, NULL, CCI_SignalLevel, NULL);
    cci1_sparams.SetStops(CCI_TrailingProfitMethod, CCI_TrailingStopMethod);
    cci1_sparams.SetMaxSpread(CCI1_MaxSpread);
    cci1_sparams.SetId(CCI1);
    return (new Stg_CCI(cci1_sparams, "CCI1"));
  }
  static Stg_CCI *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams cci_iparams(10, INDI_CCI);
    CCI_Params cci5_iparams(CCI_Period_M5, CCI_Applied_Price);
    StgParams cci5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_CCI(cci5_iparams, cci_iparams, cparams5), NULL, NULL);
    cci5_sparams.SetSignals(CCI5_SignalMethod, CCI5_OpenCondition1, CCI5_OpenCondition2, CCI5_CloseCondition, NULL, CCI_SignalLevel, NULL);
    cci5_sparams.SetStops(CCI_TrailingProfitMethod, CCI_TrailingStopMethod);
    cci5_sparams.SetMaxSpread(CCI5_MaxSpread);
    cci5_sparams.SetId(CCI5);
    return (new Stg_CCI(cci5_sparams, "CCI5"));
  }
  static Stg_CCI *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams cci_iparams(10, INDI_CCI);
    CCI_Params cci15_iparams(CCI_Period_M15, CCI_Applied_Price);
    StgParams cci15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_CCI(cci15_iparams, cci_iparams, cparams15), NULL, NULL);
    cci15_sparams.SetSignals(CCI15_SignalMethod, CCI15_OpenCondition1, CCI15_OpenCondition2, CCI15_CloseCondition, NULL, CCI_SignalLevel, NULL);
    cci15_sparams.SetStops(CCI_TrailingProfitMethod, CCI_TrailingStopMethod);
    cci15_sparams.SetMaxSpread(CCI15_MaxSpread);
    cci15_sparams.SetId(CCI15);
    return (new Stg_CCI(cci15_sparams, "CCI15"));
  }
  static Stg_CCI *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams cci_iparams(10, INDI_CCI);
    CCI_Params cci30_iparams(CCI_Period_M30, CCI_Applied_Price);
    StgParams cci30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_CCI(cci30_iparams, cci_iparams, cparams30), NULL, NULL);
    cci30_sparams.SetSignals(CCI30_SignalMethod, CCI30_OpenCondition1, CCI30_OpenCondition2, CCI30_CloseCondition, NULL, CCI_SignalLevel, NULL);
    cci30_sparams.SetStops(CCI_TrailingProfitMethod, CCI_TrailingStopMethod);
    cci30_sparams.SetMaxSpread(CCI30_MaxSpread);
    cci30_sparams.SetId(CCI30);
    return (new Stg_CCI(cci30_sparams, "CCI30"));
  }
  static Stg_CCI *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if CCI indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double cci_0 = ((Indi_CCI *) this.Data()).GetValue(0);
    double cci_1 = ((Indi_CCI *) this.Data()).GetValue(1);
    double cci_2 = ((Indi_CCI *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = cci_0 > 0 && cci_0 < -_signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= cci_0 > cci_1;
          if (METHOD(_signal_method, 1)) _result &= cci_1 > cci_2;
          if (METHOD(_signal_method, 2)) _result &= cci_1 < -_signal_level1;
          if (METHOD(_signal_method, 3)) _result &= cci_2  < -_signal_level1;
          if (METHOD(_signal_method, 4)) _result &= cci_0 - cci_1 > cci_1 - cci_2;
          if (METHOD(_signal_method, 5)) _result &= cci_2 > 0;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = cci_0 > 0 && cci_0 > _signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= cci_0 < cci_1;
          if (METHOD(_signal_method, 1)) _result &= cci_1 < cci_2;
          if (METHOD(_signal_method, 2)) _result &= cci_1 > _signal_level1;
          if (METHOD(_signal_method, 3)) _result &= cci_2  > _signal_level1;
          if (METHOD(_signal_method, 4)) _result &= cci_1 - cci_0 > cci_2 - cci_1;
          if (METHOD(_signal_method, 5)) _result &= cci_2 < 0;
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};