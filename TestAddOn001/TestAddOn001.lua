function TestAddOn001_OnLoad()
    SLASH_TESTADDON001 = "/test";
	SlashCmdList["TESTADDON001"] = TestAddOn001_SlashCommand;
    this:RegisterEvent("VARIABLES_LOADED")
end

function TestAddOn001_SlashCommand()
	print("TestAddOn001");
end