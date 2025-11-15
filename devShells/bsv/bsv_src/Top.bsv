package Top;

import FIFO::*;

// 简单的 FIFO 测试模块
// 展示 BSV 的 FIFO 和状态机用法
(* synthesize *)
module mkTop (Empty);
  // FIFO 用于存储数据
  FIFO#(UInt#(8)) dataFifo <- mkFIFO;
  
  // 状态寄存器
  Reg#(UInt#(8)) produceCount <- mkReg(0);
  Reg#(UInt#(8)) consumeCount <- mkReg(0);
  Reg#(Bool) producing <- mkReg(True);
  
  // 生产者规则：向 FIFO 中写入数据
  rule producer (producing && produceCount < 10);
    dataFifo.enq(produceCount);
    $display("[%0d] Producer: enqueued %0d", $time, produceCount);
    produceCount <= produceCount + 1;
    
    if (produceCount == 9) begin
      producing <= False;
      $display("[%0d] Producer: finished", $time);
    end
  endrule
  
  // 消费者规则：从 FIFO 中读取数据
  rule consumer (!producing || dataFifo.notEmpty);
    let data = dataFifo.first;
    dataFifo.deq;
    $display("[%0d] Consumer: dequeued %0d", $time, data);
    consumeCount <= consumeCount + 1;
    
    if (consumeCount == 9) begin
      $display("[%0d] Consumer: finished", $time);
      $finish(0);
    end
  endrule
  
endmodule

endpackage
