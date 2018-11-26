-- @ACCEL@ <Control><Shift>s
--[[
 save-note.lua
 Copies the current document or selection to another buffer with 
 the generated name: name-base_YYYYMMDD_HHMMS
--]]

--Current enviromental settings
local default_dir="C:\\Users\\329160378\\Documents\\_NOTES\\"
local default_base="note"

local dir
local base
local dlg=dialog.new("Defaults", { "_OK" } )
dlg:text("directory",default_dir,"Default directory:")
dlg:text("base", default_base,  "Default base:")
local button,results = dlg:run()
if (button==1) then
	for key,value in pairs(results)
	  do
		if (key=="directory") then
			dir=value
		else
			base=value
		end
	  end
end

local name=dir..base.."_"..os.date("%Y%m%d_%H%M%S")..".txt"
--~ geany.message(name)
--~ geany.keycmd("FILE_SAVE")
local buf
local s=geany.selection()
if (s) then
	if ( s ~= "" ) then
		buf=s
	else	
		buf=geany.text()
	end    
end    
geany.newfile(name)
geany.text(buf)
