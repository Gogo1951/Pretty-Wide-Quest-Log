local _, ns = ...

--[[
	Every client: the tooltip on the selected quest's Questie icons drawn on the map (Questie-Map.lua), the
	quest and what's around the hovered icon, as Questie's own world map groups them
]]

ns.AddWideQuestLogPart(function()
	local questMap = ns.questMap
	local canvas = questMap.canvas

	local PIN_TEMPLATE = questMap.QUESTIE_PIN_TEMPLATE
	local CLUSTER_DISTANCE = 0.015 -- Icons this close, as a share of the map, share one tooltip

	-- One space a row, as every list under a heading in the add-on's tooltips is indented
	local ROW_INDENT = " "

	-- An icon's objective: its description, its progress where it counts something, and whether it's done
	local function ObjectiveRow(data)
		local objective = data.ObjectiveData
		if not (objective and objective.Description) then
			return nil
		end
		local have, need = objective.Collected or 0, objective.Needed
		return {
			description = objective.Description,
			count = need and string.format("%s / %s", tostring(have), tostring(need)) or nil,
			done = objective.Completed or (need ~= nil and have >= need) or false,
		}
	end

	local function HasObjective(objectives, row)
		for _, other in ipairs(objectives) do
			if other.description == row.description then
				return true
			end
		end
		return false
	end

	--[[
		The quest, then every NPC or object around the hovered icon with its objectives, as Questie's world
		map groups them. An area's marker stands for every NPC or object in the area
	]]
	function questMap.ShowPinTooltip(pin)
		local x, y = pin:GetPosition()
		local entries, byName = {}, {}
		for other in canvas:EnumeratePinsByTemplate(PIN_TEMPLATE) do
			local otherX, otherY = other:GetPosition()
			if math.abs(otherX - x) < CLUSTER_DISTANCE and math.abs(otherY - y) < CLUSTER_DISTANCE then
				local objective = ObjectiveRow(other.data)
				for _, name in ipairs(other.area and other.area.names or { other.data.Name or "" }) do
					local entry = byName[name]
					if not entry then
						entry = { name = name, objectives = {} }
						byName[name] = entry
						entries[#entries + 1] = entry
					end
					if objective and not HasObjective(entry.objectives, objective) then
						entry.objectives[#entry.objectives + 1] = objective
					end
				end
			end
		end

		GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
		local quest = pin.data.QuestData
		if quest and quest.name then
			GameTooltip:AddLine(quest.name)
		end
		for _, entry in ipairs(entries) do
			GameTooltip:AddLine(ROW_INDENT .. entry.name, ns.GetColorRGB("TEXT"))
			-- Each objective leads with the quest log's check once it's done, and its count sits on the right
			for _, objective in ipairs(entry.objectives) do
				local left = ROW_INDENT .. ns.CheckIcon(GameTooltipText, objective.done) .. " " .. objective.description
				local red, green, blue = ns.GetColorRGB(objective.done and "HELP" or "TEXT")
				if objective.count then
					GameTooltip:AddDoubleLine(left, objective.count, red, green, blue, red, green, blue)
				else
					GameTooltip:AddLine(left, red, green, blue)
				end
			end
		end
		GameTooltip:Show()
	end
end)
