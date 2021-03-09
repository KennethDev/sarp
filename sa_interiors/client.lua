Citizen.CreateThread(function()
  LoadMpDlcMaps()
  EnableMpDlcMaps(true)
  RequestIpl("DT1_03_Gr_Closed")
  RequestIpl("v_tunnel_hole")
  RequestIpl("TrevorsMP")
  RequestIpl("TrevorsTrailer")
  RequestIpl("farm")
  RequestIpl("farmint")
  RequestIpl("farmint_cap")
  RequestIpl("farm_props")
  RequestIpl("CS1_02_cf_offmission")
  --[[ Aircraft Carrier ]]--
  RequestIpl("hei_carrier")
  RequestIpl("hei_carrier_DistantLights")
  RequestIpl("hei_Carrier_int1")
  RequestIpl("hei_Carrier_int2")
  RequestIpl("hei_Carrier_int3")
  RequestIpl("hei_Carrier_int4")
  RequestIpl("hei_Carrier_int5")
  RequestIpl("hei_Carrier_int6")
  RequestIpl("hei_carrier_LODLights")
  --[[ Yacht ]]--
  RequestIpl("hei_yacht_heist")
  RequestIpl("hei_yacht_heist_Bar")
  RequestIpl("hei_yacht_heist_Bedrm")
  RequestIpl("hei_yacht_heist_Bridge")
  RequestIpl("hei_yacht_heist_DistantLights")
  RequestIpl("hei_yacht_heist_enginrm")
  RequestIpl("hei_yacht_heist_LODLights")
  RequestIpl("hei_yacht_heist_Lounge")
  --[[ Cargo Ship ]]--
  RemoveIpl("cargoship")
  RequestIpl("sunkcargoship")
  --[[ Simeon ]]--
  RequestIpl("v_carshowroom")
  RequestIpl("shutter_open")
  RequestIpl("shr_int")
  RequestIpl("csr_inMission")
  --[[ FIB ]]--
  RemoveIpl("FIBlobbyfake")
  RequestIpl("FIBlobby")
  --[[ Jewelry Story ]]-- 
  RemoveIpl("jewel2fake")
  RemoveIpl("bh1_16_refurb")
  RequestIpl("post_hiest_unload")
  --[[ Cluckin Bell ]]--
  RemoveIpl("CS1_02_cf_offmission")
  RequestIpl("CS1_02_cf_onmission1")
  RequestIpl("CS1_02_cf_onmission2")
  RequestIpl("CS1_02_cf_onmission3")
  RequestIpl("CS1_02_cf_onmission4")
  --[[ Maze Bank Arena (Fame or Shame) ]]--
  RemoveIpl("sp1_10_fake_interior")
  RemoveIpl("sp1_10_fake_interior_lod")
  RequestIpl("sp1_10_real_interior")
  RequestIpl("sp1_10_real_interior_lod")
  --[[ Tequi-La-La ]]--
  RequestIpl("v_rockclub")
  --[[ Bahama Mama's ]]--
  RequestIpl("v_bahama")
  --[[ Bank Offices ]]--
  -- Arcadius Bussiness Center
  RequestIpl("ex_dt1_02_office_03c")
  -- Maze Bank Building
  RemoveIpl("ex_dt1_11_office_03c")
  RemoveIpl("ex_dt1_11_office_02b")
  RemoveIpl("ex_dt1_11_office_02c")
  RequestIpl("ex_dt1_11_office_02a")
  -- Maze Bank West
  RequestIpl("ex_sm_15_office_03c")
  --[[ Small Ones ]]--
  RequestIpl("facelobby") -- Life Invader
end)

-- http://pastebin.com/FyV5mMma for list if you want to add more