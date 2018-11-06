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
      bool SignalUpCheck(int nums, int level);
      bool SignalDownCheck(int nums, int level);
};

string CStochCross::GetEntrySignal()
{
   if(oStochFast.data[3] < oStochSlow.data[3] && oStochFast.data[2] < oStochSlow.data[2] && oStochFast.data[1] > oStochSlow.data[1]){
      if(oStochSlow.data[2] < 40 && this.SignalUpCheck(12,11)){
         return "up";
      }
   }
   
   if(oStochFast.data[3] > oStochSlow.data[3] && oStochFast.data[2] > oStochSlow.data[2] && oStochFast.data[1] < oStochSlow.data[1]){
      if(oStochSlow.data[2] >60 && this.SignalDownCheck(12,89)){
         return "down";
      }
   }
   return "none";
}

bool CStochCross::SignalUpCheck(int nums, int level)
{
   double low = oStochFast.data[1];
   for(int i=2;i<nums;i++)
   {
      if(oStochFast.data[i] <oStochSlow.data[i]){
         if(oStochFast.data[i]<low){
            low = oStochFast.data[i];
         }
      }
      if(oStochFast.data[i] >oStochSlow.data[i])
      {
         break;
      }
   }
   if(low <level){
      return true;
   }
   return false;
}

bool CStochCross::SignalDownCheck(int nums, int level)
{
   double high = oStochFast.data[1];
   for(int i=2;i<nums;i++)
   {
      if(oStochFast.data[i] >oStochSlow.data[i]){
         if(oStochFast.data[i]>high){
            high = oStochFast.data[i];
         }
      }
      if(oStochFast.data[i] <oStochSlow.data[i])
      {
         break;
      }
   }
   if(high >level){
      return true;
   }
   return false;
}

string CStochCross::GetExitSignal()
{
   //TODO
   return "none";
}