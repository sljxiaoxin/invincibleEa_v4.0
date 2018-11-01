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
   public:
      
      
      CTicket(CTrade* _oCTrade){
         oCTrade = _oCTrade;
         ticket = 0;
         opType = -1;
         orderPass = 0;
      };
      
      void Update();
      void Reset();
      bool Buy(double lots, int tp, int sl, string memo);
      bool Sell(double lots, int tp, int sl, string memo);
      void Close();
      bool isCanOpenOrder();
      
      
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
