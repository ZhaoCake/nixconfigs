module Hello where

import Clash.Prelude

-- | A simple counter that increments by 1 on every clock cycle
-- It uses 'HiddenClockResetEnable' to implicitly pass system clock, reset, and enable signals
counter :: HiddenClockResetEnable dom
        => Signal dom (Signed 9)
counter = register 0 (counter + 1)

-- | 'topEntity' describes the interface of the hardware module
-- We expose the invisible clock, reset, and enable lines so they become physical ports in Verilog/VHDL
topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (Signed 9)
topEntity = exposeClockResetEnable counter

-- | Annotation to control the name of the top entity and ports in the generated HDL
{-# ANN topEntity
  (Synthesize
    { t_name   = "hello_counter"
    , t_inputs = [ PortName "CLK"
                 , PortName "RST"
                 , PortName "EN"
                 ]
    , t_output = PortName "COUNT"
    }) #-}
