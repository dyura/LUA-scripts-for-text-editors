--[[
  Trim all trailing whitespace from the current document
--]]


local s=geany.text()
local rep=false

if (s and string.match(s, "[ \t][\r\n]") )
then
  geany.text(string.gsub(s,"([ \t]+)([\r\n]+)", "%2"))
  rep=true
end

if (s and string.match(s, "[ \t]$") )
then
  geany.text(string.gsub(s,"([ \t]+)$", ""))
else
	if not rep 
	then
		geany.message("No trailing whitespace.")
	end
end
