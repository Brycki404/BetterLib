if _G.Lib == nil then
    _G.Lib = {
        FirstRun = nil;
        --// Hook Storage
        LoadstringCaching = {};
        GetCaching = {};
        OldLoadstring = loadstring;
    }
end
local Lib = _G.Lib

--// First Run
if Lib.FirstRun == nil then
    Lib.FirstRun = true
elseif Lib.FirstRun == true then
    Lib.FirstRun = false
end

if Lib.FirstRun then
    --// Better Loadstring
    function Lib.loadstring(string)
        assert(type(string) == "string", "[Error] loadstring: First Argument needs to be a string!")

        if Lib.LoadstringCaching[string] == nil then
            Lib.LoadstringCaching[string] = Lib.OldLoadstring(string)
        else
            return Lib.LoadstringCaching[string]
        end
    end
    _G.loadstring = Lib.loadstring

    --// Better Get
    function Lib.Get(url: string): any
        assert(type(string) == "string", "[Error] Get: First Argument needs to be a string!")

        if Lib.GetCaching[string] == nil then
            local success, result = pcall(function()
                return request and request({
                    Url = url;
                    Method = "GET";
                }) or game.HttpGet and game:HttpGet(url) or game.HttpGetAsync and game:HttpGetAsync(url) or nil
            end)

            if success then
                Lib.GetCaching[string] = result
                return result
            else
                error("[Error] httpGet: Failed to get content from URL: " .. url .. "\n" .. tostring(result))
            end
        else
            return Lib.GetCaching[string]
        end
        return nil
    end
    _G.Get = Lib.Get

    local reprUrl = "https://raw.githubusercontent.com/Ozzypig/repr/refs/heads/master/repr.lua"
    local repr = loadstring(Get(reprUrl))()
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

return Lib
