package Top;

(* synthesize *)
module mkTop (Empty);
  Reg#(UInt#(8)) count <- mkReg(0);
  
  rule tick;
    count <= count + 1;
    $display("Cycle %d: count = %d", $time, count);
    if (count == 20) $finish(0);
  endrule
endmodule

endpackage
