-- Author      : Jared
-- Create Date : 4/30/2016 16:43:47
-- ChatFrame1:AddMessage

function MaterialFrame_OnLoad()
	MaterialText:SetText("1) Select recipe\n2) Enter number for Make X\n3) Click Update button");
	MaterialFrame:RegisterEvent("TRADE_SKILL_SHOW");
	MaterialFrame:RegisterEvent("TRADE_SKILL_CLOSE");
end

function MaterialFrame_OnEvent(self, event, ...)
	if event == "TRADE_SKILL_SHOW" then
		MaterialFrame:Show();
	elseif event == "TRADE_SKILL_CLOSE" then
		MaterialFrame:Hide();
	end
end

function UpdateButton_OnClick()
	-- Validate input
	local skillIndex = GetTradeSkillSelectionIndex();
	local numberToMake = NumberToMakeInput:GetNumber() < 1 and 1 or (NumberToMakeInput:GetNumber() > 99 and 99 or NumberToMakeInput:GetNumber());
	NumberToMakeInput:SetText(numberToMake);

	-- Keep skill name for later
	local skillName = GetTradeSkillInfo(skillIndex);

	-- Clear the filter and expand everything
	SetTradeSkillItemNameFilter();
	ExpandAllHeaders();

	-- Select the item that was previously selected and get its new skill index
	for curSkillIndex = 1,GetNumTradeSkills() do 
		if GetTradeSkillInfo(curSkillIndex) == skillName then
			SelectTradeSkill(curSkillIndex);
			skillIndex = curSkillIndex;
			break;
		end
	end

	-- Get material tree
	local materialTreeText, materialNeeded, materialOwned, materialLink, materialLowest = GetMaterialTree(skillIndex, numberToMake, "");

	-- Create material diff text
	local materialDiffText = "";
	for reagentName, materialNeededAmount in pairs(materialNeeded) do
		-- Only add it if it is lowest-level
		if materialLowest[reagentName] then
			local materialDiff = materialNeededAmount - materialOwned[reagentName] < 0 and 0 or materialNeededAmount - materialOwned[reagentName];
			materialDiffText = materialDiffText .. materialDiff .. " " .. materialLink[reagentName] .. "\n";
		end
	end

	-- Set text
	MaterialText:SetText(numberToMake .. " " .. GetTradeSkillItemLink(skillIndex) .. "\n\n\nList of Remaining Lowest-Level Materials" .. "\n\n" .. materialDiffText .. "\n\nTree of All Materials\n" .. materialTreeText);
end

function ExpandAllHeaders()
	while true do
		-- Assume we will break out unless we have to expand
		local breakOut = true;
		for curSkillIndex = 1,GetNumTradeSkills() do 
			local _, skillType, _, isExpanded = GetTradeSkillInfo(curSkillIndex)

			-- If we found a non expanded header, expand it and start over
			if ((skillType == "header") or (skillType == "subheader")) and (not isExpanded) then
				ExpandTradeSkillSubClass(curSkillIndex);
				breakOut = false;
				break;
			end
		end

		-- No more expansions were performed, so break out
		if breakOut then
			break;
		end
	end
end

function GetMaterialTree(skillIndex, numberToMake, spaces)
	-- Initialize variables
	if spaces == "" then
		materialTreeText = "";
		materialNeeded = {};
		materialOwned = {};
		materialLink = {};
		materialLowest = {};
	end

	for reagentIndex = 1,GetTradeSkillNumReagents(skillIndex) do
		-- Get some properties
		local reagentLink = GetTradeSkillReagentItemLink(skillIndex, reagentIndex);
		local reagentName, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(skillIndex, reagentIndex);

		-- Multiply the reagentCount by how many to make
		local reagentCount = reagentCount * numberToMake;

		-- Initialize this material
		if materialNeeded[reagentName] == nil then 
			materialNeeded[reagentName] = 0;
		end

		-- Update global material lists
		materialNeeded[reagentName] = materialNeeded[reagentName] + reagentCount;
		materialOwned[reagentName] = playerReagentCount;
		materialLink[reagentName] = reagentLink;
		
		-- Set text
		materialTreeText = materialTreeText .. "\n" .. spaces .. reagentCount .. " " .. reagentLink;

		-- Recurse only if we can make this item
		local isLowestLevel = true;
		for curSkillIndex = 1,GetNumTradeSkills() do 
			if GetTradeSkillInfo(curSkillIndex) == reagentName then
				GetMaterialTree(curSkillIndex, reagentCount, spaces .. "        ");
				isLowestLevel = false;
				break;
			end
		end

		-- Set whether this is a lowest-level material
		materialLowest[reagentName] = isLowestLevel;
	end

	-- Return variables
	if spaces == "" then
		return materialTreeText, materialNeeded, materialOwned, materialLink, materialLowest;
	end
end
