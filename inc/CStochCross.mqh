//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"
#include "CStoch.mqh";

class CStochCross
{  
   private:
      CStoch* oStochFast; //14
      CStoch* oStochSlow; //100
      
     
   public:
      
      
      CStochCross(CStoch* _oStochFast, CStoch* _oStochSlow){
         oStochFast = _oStochFast;
         oStochSlow = _oStochSlow;
      };
      
      string GetEntrySignal();
      string GetExitSignal();
};

string CStochCross::GetEntrySignal()
{
   if(oStochFast.data[3] < oStochSlow.data[3] && oStochFast.data[2] < oStochSlow.data[2] && oStochFast.data[1] > oStochSlow.data[1]){
      if(oStochSlow.data[2] < 40 && oStochFast.LowValue(12)<11){
         return "up";
      }
   }
   
   if(oStochFast.data[3] > oStochSlow.data[3] && oStochFast.data[2] > oStochSlow.data[2] && oStochFast.data[1] < oStochSlow.data[1]){
      if(oStochSlow.data[2] >60 && oStochFast.HighValue(12) > 89){
         return "down";
      }
   }
   return "none";
}

string CStochCross::GetExitSignal()
{
   
}