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
     double   Lots;
     int      Tp;
     int      Sl;
     
     CTrade* oCTrade;
     CMa* oCMa_fast;
     CMa* oCMa_slow;
     CStoch* oCStoch_fast;
     CStoch* oCStoch_slow;
     CTicket* oCTicket;
     CStochCross* oCStochCross;
     //CPriceAction* oCPriceAction;
     
     bool isCurrSignalOpen;
     string strSignalType;
     int intCurrSignalPass;
     
     bool isStochFastCrossOverArea;
     int intStochFastCrossOverAreaPass;
     
     void Update();
     void GetSignal();
     void SetSignal(string type);
     void Entry();
     void Exit();
   public:
      
      CStrategySmOne(int Magic){
         oCTrade      = new CTrade(Magic);
         oCMa_fast    = new CMa(PERIOD_M1,10);
         oCMa_slow    = new CMa(PERIOD_M1,30);
         oCStoch_fast = new CStoch(PERIOD_M1,14);
         oCStoch_slow = new CStoch(PERIOD_M1,100);
         oCTicket     = new CTicket(oCTrade);
         oCStochCross = new CStochCross(oCStoch_fast, oCStoch_slow);
         
         isCurrSignalOpen = false;
         strSignalType = "none";
         intCurrSignalPass = -1;
         isStochFastCrossOverArea = false;
         intStochFastCrossOverAreaPass = -1;
         
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      
};

void CStrategySmOne::Init(double _lots, int _tp, int _sl)
{
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategySmOne::Tick(void)
{  
    if(CheckTimeM1 == iTime(NULL,PERIOD_M1,0)){
      
    }else{
         CheckTimeM1 = iTime(NULL,PERIOD_M1,0);
         this.Update();
         this.Exit();
         this.GetSignal();
         this.Entry();
    }
}

void CStrategySmOne::Update()
{
   oCMa_fast.Fill();
   oCMa_slow.Fill();
   oCStoch_fast.Fill();
   oCStoch_slow.Fill();
   oCTicket.Update();
   
   intCurrSignalPass += 1;
   if(isStochFastCrossOverArea){
      intStochFastCrossOverAreaPass += 1;
   }
   
}

void CStrategySmOne::GetSignal(void)
{
   string sig = oCStochCross.GetEntrySignal();
   if(sig != "none"){
      this.SetSignal(sig);
   }
}

void CStrategySmOne::CancelSignal()
{
   this.SetSignal("none");
}

void CStrategySmOne::SetSignal(string type)
{
   strSignalType = type;
   isCurrSignalOpen = false;
   intCurrSignalPass = -1;
   
   isStochFastCrossOverArea = false;
   intStochFastCrossOverAreaPass = -1;
   
}

void CStrategySmOne::Entry()
{
   if(!oCTicket.isCanOpenOrder()){
      return ;
   }
   if(isCurrSignalOpen){
      return ;
   }
   
   if(!isStochFastCrossOverArea && intCurrSignalPass <10){
      if(strSignalType == "up" && oCStoch_fast.data[1]>21){
         isStochFastCrossOverArea = true;
         intStochFastCrossOverAreaPass = 0;
      }
      if(strSignalType == "down" && oCStoch_fast.data[1]<79){
         isStochFastCrossOverArea = true;
         intStochFastCrossOverAreaPass = 0;
      }
   }
   
   if(isStochFastCrossOverArea && strSignalType == "up"){
      if(oCStoch_fast.data[2]>oCStoch_slow.data[2] && oCStoch_fast.data[1]<oCStoch_slow.data[1])
      {
         this.CancelSignal();
         return ;
      }
      if(oCMa_fast.data[1] >oCMa_fast.data[2] && 
           Close[2]>oCMa_fast.data[2] && 
            Close[1]>Open[1] && 
            Close[1]>oCMa_fast.data[1] && 
            Ask - oCMa_slow.data[1]<1.5*oCTrade.GetPip())
      {
               
           double pips = CPriceAction::Distance(20)/oCTrade.GetPip(); 
           if(pips > 2){
               oCTicket.Buy(Lots, Tp, Sl, "SmOne");
           }
      }
     
   }
   
   if(isStochFastCrossOverArea && strSignalType == "down"){
      if(oCStoch_fast.data[2]<oCStoch_slow.data[2] && oCStoch_fast.data[1]>oCStoch_slow.data[1])
      {
         this.CancelSignal();
         return ;
      }
      if(oCMa_fast.data[1] > oCMa_fast.data[2] && 
         Close[2] < oCMa_fast.data[2] && 
         Close[1]<Open[1] && 
         Close[1]<oCMa_fast.data[1] && 
         oCMa_slow.data[1] - Bid<1.5*oCTrade.GetPip()
      )
      {
         oCTicket.Sell(Lots, Tp, Sl, "SmOne");
      }
   }
   
}

void CStrategySmOne::Exit()
{
   
}