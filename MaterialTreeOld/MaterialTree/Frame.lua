-- Author      : Jared
-- Create Date : 4/30/2016 16:43:47


function Frame1_OnEvent(self, event, ...)
	if (event == "TRADE_SKILL_SHOW")then
		Frame1:Show();
	elseif (event == "TRADE_SKILL_CLOSE")then
		Frame1:Hide();
	end
end

function Frame1_OnLoad()
	Frame1:RegisterEvent("TRADE_SKILL_SHOW");
	Frame1:RegisterEvent("TRADE_SKILL_CLOSE");
end

function Update_OnClick()
	Frame1Text:SetText("Trade Skill: " .. GetTradeSkillInfo(GetTradeSkillSelectionIndex()));
end
