require('ImGui')
--local Write = require('Scriber.Write')
local mq = require('mq') 
local Open, ShowUI = true, true -- GUI Control variables
local type = {"None", "Tradeskill", "Collectible", "No trade", "Attuneable","Quest", "Magic", "Food", "Drink", "Arrow"} --Flags for item types
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
	local storage = {"BackPack", "Small Bag", "Large Chest", "Merchant", "Mixing", "Tinkering", "Backpack"}
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
			local TEXT_BASE_Height = ImGui.GetTextLineHeightWithSpacing()
			local column_names = inv_bag_types
			local columns_count = #column_names
			local rows_count = #type
			local table_flags = bit32.bor(ImGuiTableFlags.SizingFixedFit, ImGuiTableFlags.ScrollX, ImGuiTableFlags.ScrollY, ImGuiTableFlags.Resizable, ImGuiTableFlags.RowBg, ImGuiTableFlags.BordersOuter, ImGuiTableFlags.BordersV, ImGuiTableFlags.BordersH)
			local frozen_cols = 1
			local frozen_rows = 1
			local buttton_disabled = false
			
			

			if ImGui.BeginTable("Item Type Selection", columns_count, table_flags, 0.0, TEXT_BASE_Height * 12) then
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
					--ImGui.TableSetColumnIndex(0)  Column index messed up table flags. may be applicable later
					ImGui.TableNextColumn()
					ImGui.AlignTextToFramePadding()
					ImGui.Text(type[row])
					for column = 2, columns_count do
						--if (ImGui.TableSetColumnIndex(column)) then
						local index = row * columns_count + column
						ImGui.TableNextColumn()
						ImGui.PushID(column)
						if column_names[column] == "TS Bag" then
							if type[row] == "Tradeskill" then
								buttton_disabled = false
							else
								buttton_disabled = true
							end
							ImGui.BeginDisabled(buttton_disabled)
							bools[index] = ImGui.Checkbox("", bools[index])
							ImGui.EndDisabled()
						elseif column_names[column] == "Col Bag" then
							if type[row] == "Collectible" then
								buttton_disabled = false
							else
								buttton_disabled = true
							end
							ImGui.BeginDisabled(buttton_disabled)
							bools[index] = ImGui.Checkbox("", bools[index])
							ImGui.EndDisabled()
						elseif column_names[column] == "Quiver" then
							if type[row] == "Arrow" then
								buttton_disabled = false
							else
								buttton_disabled = true
							end
						elseif column_names[column] == "None" then
							buttton_disabled = true
							ImGui.BeginDisabled(buttton_disabled)
							bools[index] = ImGui.Checkbox("", bools[index])
							ImGui.EndDisabled()
						else
							buttton_disabled = false
							bools[index] = ImGui.Checkbox("", bools[index])
						end
						ImGui.PopID()
						
						--end
					end
					ImGui.PopID()
				end
			ImGui.EndTable()
			end
			--Add button to start sorting function
            
		end
		ImGui.End()
	end
end
mq.imgui.init('BagSortGUI', BagSortGUI)

while true do
	mq.delay(100)
end