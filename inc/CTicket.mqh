//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"
#include "CTrade.mqh";


class CTicket
{  
   private:
      int ticket;
      int opType;
      int orderPass;
      CTrade* oCTrade;  
      double firstSrValue; //first support resistance value 
      
      bool isCurrInOverArea;
      int  intInOverAreaCount;
      
      bool isTwoStochHavedInOverArea;  //两个stoch是否进过over
      
      bool isAfterFirstSrValueInOverArea; //设置firstValue后第一次进入超买超卖区域
   public:
      
      
      CTicket(CTrade* _oCTrade){
         oCTrade = _oCTrade;
         ticket = 0;
         opType = -1;
         orderPass = 0;
         firstSrValue = -1;
         isCurrInOverArea = false;
         intInOverAreaCount = 0;
         isTwoStochHavedInOverArea =false;
         isAfterFirstSrValueInOverArea = false;
      };
      
      void Update();
      void Reset();
      bool Buy(double lots, int tp, int sl, string memo);
      bool Sell(double lots, int tp, int sl, string memo);
      void Close();
      bool isCanOpenOrder();
      int  GetOrderPass();
      int  GetOpType();
      void SetFirstSrValue(double val);
      double GetFirstSrValue();
      int GetTicket();
      void CheckOverArea(double stochFast, double stochSlow);
      int GetOverAreaCount();
     // void CheckTwoStochOverArea(double stochFast, double stochSlow);
      bool GetIsTwoStochHavedInOverArea();
      bool GetIsAfterFirstSrValueInOverArea();
      
};

void CTicket::Update()
{
   if(ticket != 0){
      if(oCTrade.isOrderClosed(ticket)){
         this.Reset();
      }else{
         orderPass += 1;
      }
   }
}

void CTicket::Reset(){
   ticket = 0;
   opType = -1;
   orderPass = 0;
   firstSrValue = -1;
   isCurrInOverArea = false;
   intInOverAreaCount = 0;
   isTwoStochHavedInOverArea =false;
   isAfterFirstSrValueInOverArea = false;
}

bool CTicket::Buy(double lots, int tp, int sl, string memo){
   int t = oCTrade.Buy(lots, sl, tp, memo);
   if(t > 0){
      ticket = t;
      opType = OP_BUY;
      return true;
   }
   return false;
   
}

bool CTicket::Sell(double lots, int tp, int sl, string memo){
   int t = oCTrade.Sell(lots, sl, tp, memo);
   if(t > 0){
      ticket = t;
      opType = OP_SELL;
      return true;
   }
   return false;
   
}

void CTicket::Close(){
   oCTrade.Close(ticket);
   this.Reset();
}

bool CTicket::isCanOpenOrder()
{
   if(ticket == 0){
      return true;
   }
   return false;
}

int  CTicket::GetOrderPass()
{
   return this.orderPass;
}

int  CTicket::GetOpType()
{
   return this.opType;
}

void CTicket::SetFirstSrValue(double val)
{
   this.firstSrValue = val;
}

double CTicket::GetFirstSrValue()
{
   return this.firstSrValue;
}

int CTicket::GetTicket()
{
   return this.ticket;
}

void CTicket::CheckOverArea(double stochFast, double stochSlow)
{
   //isCurrInOverArea = false;
   //intInOverAreaCount = 0;
   if(ticket<=0){
      return ;
   }
   if(opType == OP_BUY)
   {
      if(!isCurrInOverArea && stochFast>80){
         isCurrInOverArea = true;
         intInOverAreaCount += 1;
      }
      if(isCurrInOverArea && stochFast<80){
         isCurrInOverArea = false;
      }
      if(!isTwoStochHavedInOverArea && stochFast>80 && stochSlow>80){
         isTwoStochHavedInOverArea = true;
      }
      
      if(firstSrValue != -1 && !isAfterFirstSrValueInOverArea && stochFast>80){
         isAfterFirstSrValueInOverArea = true;
      }
   }
   if(opType == OP_SELL)
   {
      if(!isCurrInOverArea && stochFast<20){
         isCurrInOverArea = true;
         intInOverAreaCount += 1;
      }
      if(isCurrInOverArea && stochFast>20){
         isCurrInOverArea = false;
      }
      if(!isTwoStochHavedInOverArea && stochFast<20 && stochSlow<20){
         isTwoStochHavedInOverArea = true;
      }
      
      if(firstSrValue != -1 && !isAfterFirstSrValueInOverArea && stochFast<20){
         isAfterFirstSrValueInOverArea = true;
      }
   }
}

int CTicket::GetOverAreaCount()
{
   return intInOverAreaCount;
}

bool CTicket::GetIsTwoStochHavedInOverArea()
{
   return isTwoStochHavedInOverArea;
}

bool CTicket::GetIsAfterFirstSrValueInOverArea()
{
   return isAfterFirstSrValueInOverArea;
}