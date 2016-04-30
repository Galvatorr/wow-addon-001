-- Author      : Jared
-- Create Date : 4/30/2016 16:43:47


function MaterialFrame_OnEvent(self, event, ...)
	if event == "TRADE_SKILL_SHOW" then
		MaterialFrame:Show();
	elseif event == "TRADE_SKILL_CLOSE" then
		MaterialFrame:Hide();
	end
end

function UpdateButton_OnClick()
	MaterialText:SetText(GetTradeSkillInfo(GetTradeSkillSelectionIndex()));
end

function MaterialFrame_OnLoad()
	MaterialFrame:RegisterEvent("TRADE_SKILL_SHOW");
	MaterialFrame:RegisterEvent("TRADE_SKILL_CLOSE");
end
