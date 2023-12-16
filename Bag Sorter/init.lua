require('ImGui')
--local Write = require('Scriber.Write')
local mq = require('mq') 
local Open, ShowUI = true, true -- GUI Control variables
local type = {"None", "Tradeskill", "Collectible", "No trade", "Attuneable","Quest", "Magic", "Food", "Drink"} --Flags for item types
local bools = {} -- Dummy storage
local TopInvSlot = 22 + mq.TLO.Me.NumBagSlots() --Top Inventory Slot
local inv_bag_types = {"Selection"}



local function TableCheck(value, tbl)
	for _, item in ipairs(tbl) do
		if item == value then
			return true
		end
	end
	return false
end

for pack = 23, TopInvSlot do
	local item = mq.TLO.Me.Inventory(pack).Type()
	local storage = {"BackPack", "Small Bag", "Large Chest"}
	if TableCheck(item, storage) then
		inv_bag_types[pack] = table.insert(inv_bag_types, "Bag")
	elseif item == "Collectible Bag" then
		inv_bag_types[pack] = table.insert(inv_bag_types, "Col Bag")
	elseif item == "Tradeskill Bag" then
		inv_bag_types[pack] = table.insert(inv_bag_types, "TS Bag")
	elseif item == "Quiver" then
		inv_bag_types[pack] = table.insert(inv_bag_types, "Quiver")
	else
		inv_bag_types[pack] = table.insert(inv_bag_types, "None")
	end
end

local function BagSortGUI()
	if Open then
		ImGui.SetWindowSize("MainWindow", 800, 500, ImGuiCond.Once)
		Open, ShowUI = ImGui.Begin('Bag Sorter', Open)
		if ShowUI then
			local column_names = inv_bag_types
			local columns_count = #column_names
			local rows_count = #type
			local table_flags = bit32.bor(ImGuiTableFlags.SizingFixedFit, ImGuiTableFlags.ScrollX, ImGuiTableFlags.ScrollY, ImGuiTableFlags.Resizable, ImGuiTableFlags.RowBg, ImGuiTableFlags.BordersOuter, ImGuiTableFlags.BordersV, ImGuiTableFlags.BordersH)
			local frozen_cols = 1
			local frozen_rows = 1
			local row_bg_type = 1
			local row_bg_target = 1
			

			if ImGui.BeginTable("Item Type Selection", columns_count, table_flags) then
				ImGui.TableSetupColumn(column_names[1])
				for n = 2, columns_count do
					ImGui.TableSetupColumn(column_names[n], ImGuiTableColumnFlags.WidthFixed)
				end
					ImGui.TableSetupScrollFreeze(frozen_cols, frozen_rows)
						-- Add Later, Draw angled headers for all columns with the ImGuiTableColumnFlags_AngledHeader flag.
					ImGui.TableHeadersRow()
				for row = 1, rows_count do
					ImGui.PushID(row)
					ImGui.TableNextRow()
					if row_bg_type ~= 0 then
						if row_bg_type == 1 then
							ImGui.TableSetBgColor(ImGuiTableBgTarget.RowBg0 + row_bg_target, 0.7, 0.3, 0.3, 0.65)
						else
							ImGui.TableSetBgColor(ImGuiTableBgTarget.RowBg0 + row_bg_target, 0.2 + row * .1, 0.2, 0.2, 0.65)
						end
					end
					ImGui.TableSetColumnIndex(0)
					ImGui.AlignTextToFramePadding()
					ImGui.Text(type[row])
					for column = 1, columns_count do
						if (ImGui.TableSetColumnIndex(column)) then
					
							ImGui.PushID(column)
							bools[row * columns_count + column] = ImGui.Checkbox("", bools[row * columns_count + column])
							ImGui.PopID()
						end
					end
					ImGui.PopID()
				end
			ImGui.EndTable()
			end
            
		end
		ImGui.End()
	end
end
mq.imgui.init('ScriberGUI', BagSortGUI)

while true do
	mq.delay(100)
end