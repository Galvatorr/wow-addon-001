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
	local skillIndex = GetTradeSkillSelectionIndex();
	local numberToMake = NumberToMakeInput:GetNumber() < 1 and 1 or (NumberToMakeInput:GetNumber() > 99 and 99 or NumberToMakeInput:GetNumber());
	NumberToMakeInput:SetText(numberToMake);
	MaterialText:SetText("Remaining reagents for " .. numberToMake .. " " .. GetTradeSkillItemLink(skillIndex) .. "\n");

	for reagentIndex = 1,GetTradeSkillNumReagents(skillIndex) do 
		local link = GetTradeSkillReagentItemLink(skillIndex, reagentIndex);
		local _, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(skillIndex, reagentIndex);
		reagentCount = reagentCount * numberToMake;
		local reagentDiff = reagentCount - playerReagentCount < 0 and 0 or reagentCount - playerReagentCount;
		MaterialText:SetText(MaterialText:GetText() .. "\n" .. reagentDiff .. " " .. link);
	end
end

--function PrintReagentInfo(reagentName, reagentNumber, numTabs)

--end

function MaterialFrame_OnLoad()
	MaterialText:SetText("1) Select recipe\n2) Enter number for Make X\n3) Click Update button");
	MaterialFrame:RegisterEvent("TRADE_SKILL_SHOW");
	MaterialFrame:RegisterEvent("TRADE_SKILL_CLOSE");
end
