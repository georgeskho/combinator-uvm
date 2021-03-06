/*-------------------------------------------------------------------------
File name   : reg_to_ahb_adapter.sv
Title       : Register Operations to AHB Transactions Adapter Sequence
Project     :
Created     :
Description : UVM_REG - Adapter Sequence converts UVM register operations
            : to AHB bus transactions
Notes       : This example does not provide any random transfer delay
            : for the transaction.  This could be added if desired. 
------------------------------------------------------------------------*/
//   Copyright 1999-2011 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

class reg_to_ahb_adapter extends uvm_reg_adapter;

`uvm_object_utils(reg_to_ahb_adapter)

  function new(string name="reg_to_ahb_adapter");
    super.new(name);
  endfunction : new

  function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    ahb_transfer transfer;
    transfer = ahb_transfer::type_id::create("transfer");
    transfer.address = rw.addr;
    transfer.data = rw.data;
    transfer.direction = (rw.kind == UVM_READ) ? READ : WRITE;
    return (transfer);
  endfunction : reg2bus

  function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    ahb_transfer transfer;
    if (!$cast(transfer, bus_item)) begin
      `uvm_fatal("NOT_REG_TYPE",
       "Provided bus_item is not of the correct type. Expecting ahb_transfer")
       return;
    end
    rw.kind =  (transfer.direction == READ) ? UVM_READ : UVM_WRITE;
    rw.addr = transfer.address;
    rw.data = transfer.data;
    rw.status = UVM_IS_OK;
  endfunction  : bus2reg

endclass : reg_to_ahb_adapter
