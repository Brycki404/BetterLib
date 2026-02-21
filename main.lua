if _G.BetterLib == nil then
    _G.BetterLib = {
        FirstRun = nil;
        --// Hook Storage
        LoadstringCaching = {};
        GetCaching = {};
        OldLoadstring = loadstring;
    }
end
local BetterLib = _G.BetterLib

--// First Run
if BetterLib.FirstRun == nil then
    BetterLib.FirstRun = true
elseif BetterLib.FirstRun == true then
    BetterLib.FirstRun = false
end

if BetterLib.FirstRun then
    --// Better Loadstring
    function BetterLib.loadstring(string)
        assert(type(string) == "string", "[Error] loadstring: First Argument needs to be a string!")

        if BetterLib.LoadstringCaching[string] == nil then
            BetterLib.LoadstringCaching[string] = BetterLib.OldLoadstring(string)
        else
            return BetterLib.LoadstringCaching[string]
        end
    end
    _G.loadstring = BetterLib.loadstring

    --// Better Get
    function BetterLib.Get(url: string): any
        assert(type(string) == "string", "[Error] Get: First Argument needs to be a string!")

        if BetterLib.GetCaching[string] == nil then
            local success, result = pcall(function()
                return request and request({
                    Url = url;
                    Method = "GET";
                }) or game.HttpGet and game:HttpGet(url) or game.HttpGetAsync and game:HttpGetAsync(url) or nil
            end)

            if success then
                BetterLib.GetCaching[string] = result
                return result
            else
                error("[Error] httpGet: Failed to get content from URL: " .. url .. "\n" .. tostring(result))
            end
        else
            return BetterLib.GetCaching[string]
        end
        return nil
    end
    _G.Get = BetterLib.Get

    local reprUrl = "https://raw.githubusercontent.com/Ozzypig/repr/refs/heads/master/repr.lua"
    local repr = loadstring(BetterLib.Get(reprUrl))()
    local reprSettings = {
    	pretty = false;              -- print with \n and indentation?
    	semicolons = false;          -- when printing tables, use semicolons (;) instead of commas (,)?
    	sortKeys = true;             -- when printing dictionary tables, sort keys alphabetically?
    	spaces = 3;                  -- when pretty printing, use how many spaces to indent?
    	tabs = false;                -- when pretty printing, use tabs instead of spaces?
    	robloxFullName = false;      -- when printing Roblox objects, print full name or just name? 
    	robloxProperFullName = true; -- when printing Roblox objects, print a proper* full name?
    	robloxClassName = true;      -- when printing Roblox objects, also print class name in parens?
    }
    _G.reprUrl = reprUrl
    _G.repr = repr
    _G.reprSettings = reprSettings
    -- Example usage: local str = repr(table, reprSettings)
end

return BetterLib
