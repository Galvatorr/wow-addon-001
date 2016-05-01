-- Author      : Jared
-- Create Date : 4/30/2016 16:43:47
-- ChatFrame1:AddMessage
-- BuildListString

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

	-- Set text
	MaterialText:SetText("Remaining Materials for " .. numberToMake .. " " .. GetTradeSkillItemLink(skillIndex) .. "\n\nnum stuff remaining\n\n\nTree View of Total Materials\n" .. GetMaterialTreeText(skillIndex, numberToMake, ""));
end

function ExpandAllHeaders()
	while true do
		local breakOut = true;
		for curSkillIndex = 1,GetNumTradeSkills() do 
			local _, skillType, _, isExpanded = GetTradeSkillInfo(curSkillIndex)
			if ((skillType == "header") or (skillType == "subheader")) and (not isExpanded) then
				ExpandTradeSkillSubClass(curSkillIndex);
				breakOut = false;
				break;
			end
		end
		if breakOut then
			break;
		end
	end
end

function GetMaterialTreeText(skillIndex, numberToMake, spaces)
	-- Initialize materialTreeText
	if spaces == "" then
		materialTreeText = "";
	end

	-- Go through each reagent
	for reagentIndex = 1,GetTradeSkillNumReagents(skillIndex) do
		-- Get some properties and multiply the reagentCount by how many to make
		local link = GetTradeSkillReagentItemLink(skillIndex, reagentIndex);
		local reagentName, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(skillIndex, reagentIndex);
		local reagentCount = reagentCount * numberToMake;
		
		-- FIX THIS
		--local reagentDiff = reagentCount - playerReagentCount < 0 and 0 or reagentCount - playerReagentCount;
		
		-- Set text
		materialTreeText = materialTreeText .. "\n" .. spaces .. reagentCount .. " " .. link;

		-- Recurse only if we can make this item
		for curSkillIndex = 1,GetNumTradeSkills() do 
			if GetTradeSkillInfo(curSkillIndex) == reagentName then
				GetMaterialTreeText(curSkillIndex, reagentCount, spaces .. "        ");
				break;
			end
		end
	end

	return materialTreeText;
end

function MaterialFrame_OnLoad()
	MaterialText:SetText("1) Select recipe\n2) Enter number for Make X\n3) Click Update button");
	MaterialFrame:RegisterEvent("TRADE_SKILL_SHOW");
	MaterialFrame:RegisterEvent("TRADE_SKILL_CLOSE");
end
