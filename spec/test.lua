package.path = package.path .. ';./luaunit/?.lua;'
luaunit = require("luaunit")

UnitTest = {}
  function UnitTest:AttachToGUI()
    while (true) do
      gui.text(50,50,"Hello world!");
      luaunit.assertEquals(true,false);
      emu.frameadvance();
    end;

  end
-- class UnitTest

UnitTest:AttachToGUI()
