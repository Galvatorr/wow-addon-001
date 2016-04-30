-- Author      : Jared
-- Create Date : 4/30/2016 15:52:25


function Frame1_OnLoad()
	this.RegisterEvent("PLAYER_TARGET_CHANGED"); 
end

function Frame1_OnEvent()
	if (event == "PLAYER_TARGET_CHANGED") then
		FontString1:SetText("Hello " .. UnitName("target") .. "!")
	end
end

function Button1_OnClick()
	Frame1:Hide();
end
