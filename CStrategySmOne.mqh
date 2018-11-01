//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

#include "inc\CTrade.mqh";
#include "inc\CMa.mqh";
#include "inc\CStoch.mqh";
#include "inc\CTicket.mqh";
#include "inc\CPriceAction.mqh";
#include "inc\CStochCross.mqh";


class CStrategySmOne
{  
   private:
   
     datetime CheckTimeM1; 
     
     CTrade* oCTrade;
     CMa* oCMa_fast;
     CMa* oCMa_slow;
     CStoch* oCStoch_fast;
     CStoch* oCStoch_slow;
     CTicket* oCTicket;
     CStochCross* oCStochCross;
     //CPriceAction* oCPriceAction;
     
     void Update();
     
   public:
      
      CStrategySmOne(int Magic){
         oCTrade      = new CTrade(Magic);
         oCMa_fast    = new CMa(PERIOD_M1,10);
         oCMa_slow    = new CMa(PERIOD_M1,30);
         oCStoch_fast = new CStoch(PERIOD_M1,14);
         oCStoch_slow = new CStoch(PERIOD_M1,100);
         oCTicket     = new CTicket(oCTrade);
         oCStochCross = new CStochCross(oCStoch_fast, oCStoch_slow);
         
      };
      
      void Tick();
};

void CStrategySmOne::Tick(void)
{  
    if(CheckTimeM1 == iTime(NULL,PERIOD_M1,0)){
      
    }else{
         CheckTimeM1 = iTime(NULL,PERIOD_M1,0);
         this.Update();
         
    }
}

void CStrategySmOne::Update()
{
   oCMa_fast.Fill();
   oCMa_slow.Fill();
   oCStoch_fast.Fill();
   oCStoch_slow.Fill();
   oCTicket.Update();
}