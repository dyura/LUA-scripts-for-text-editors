glob1='a'
glob2='b'
glob3='c'
glob4='d'
buf={}
--buf[0]='a'
-- mark/clean  selection
-- to clean we can revert if the file is saved. If it's unsaved buffer, just to copy to another one

function clean_mark()
	str=editor:LineFromPosition(editor.SelectionStart)
	end1=editor:LineFromPosition(editor.SelectionEnd)
	editor:MarkerDefine(1,2)
	print (str)
	print (end1)
	local n = str
	while  end1 +1 > n do
		editor:MarkerDelete(n,10)
		n=n+1
	end
end

function set_mark()
	str=editor:LineFromPosition(editor.SelectionStart)
	end1=editor:LineFromPosition(editor.SelectionEnd)
	editor:MarkerDefine(1,2)
	print (str)
	print (end1)
	local n = str
	while  end1 +1 > n do
		editor:MarkerAdd(n,10)
		n=n+1
	end
end

function hide_lines(parm)
-- hide marked/unmarked lines
-- This mechanism is not really correct for this operation and as the result 
-- the first line cannot be processed. I should switch to SCI_STYLESETVISIBLE
-- but ,it's still very useful, just need to keep in mind the first line
--local keep=props['highlight.current.word']
--dostring('highlight_current_word()')
--highlight_current_word()
--print(props['highlight.current.word'])
        if parm~='marked' and parm~='unmarked' then
           print(" parameter could be either: marked or unmarked")
           return
        end   
        --- completely unfold 
        local last_line=editor.LineCount
        local lines_on_screen=editor.LinesOnScreen
        if last_line >  lines_on_screen then 
                editor:GotoLine(last_line)
                local first_visible_line=editor.FirstVisibleLine
                local diff=last_line-first_visible_line
                while diff ~= lines_on_screen do
                        scite.MenuCommand(IDM_TOGGLE_FOLDALL)
                        editor:GotoLine(last_line)
                        first_visible_line=editor.FirstVisibleLine
                        diff=last_line-first_visible_line
                end
        end
        
--~         local props1=props['line.margin.visible']
--~         print (editor.MarginWidthN[0])
--[[       if props['line.margin.visible'] == '0'    
        then
                scite.MenuCommand(IDM_LINENUMBERMARGIN)
                props['line.margin.visible']=1
        end ]]--
        if editor.MarginWidthN[0] == 0    
        then
                scite.MenuCommand(IDM_LINENUMBERMARGIN)
        end
        local screen_pos=editor.FirstVisibleLine  
	local n = 0
	while editor.LineCount > n do
		editor:GotoLine(n)
		if (editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos))> 0 and  parm=='marked') 
                  or 
                  (editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos))== 0 and  parm=='unmarked')
                then
			if n > 0 then
                                editor:HideLines(n,n)
                        elseif editor:GetLine(0) ~=nil then
 -----------                            local   len1=string.len(editor:GetLine(0))
                                scite.SendEditor(SCI_INDICSETFORE, 0, 255)
                                scite.SendEditor(SCI_INDICSETSTYLE, 0, INDIC_ROUNDBOX)
                                scite.SendEditor(SCI_INDICATORFILLRANGE, 0,string.len(editor:GetLine(0))-1)
                        end
		end
		n = n +1
	end
        editor:GotoLine(screen_pos)
   --     props['highlight.current.word']=1
   --     dostring('toggle_highlight_current_word()')
end
function copy_marked()
-- copy marked lines
        local screen_pos=editor.FirstVisibleLine + 1  
	local n = 0
	all=""
	while editor.LineCount > n do
		editor:GotoLine(n)
	--print (editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)))
	--print(editor:GetLine(n))
		if editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)) > 0 then
			local line=editor:GetLine(n)
			 all=all..line
			 --editor:HideLines(n,n)
			--print ( string.gsub(line, "[\r\n]+$", ""))
			--editor:LineDelete()
		end
		n = n +1
	end
        editor:GotoLine(screen_pos)
	print ("START-MARKED "..props.FileNameExt)
	 all=all.."END-MARKET"
	print(all)
end

function cut_marked()
-- copy marked lines
        local screen_pos=editor.FirstVisibleLine + 1 
	local n = 0
	all=""
        n=editor.LineCount -1
--~       do return end    -- for debug
	while n >=0 do
		editor:GotoLine(n)
--~         print (n," <<")        
--~ 	print(editor:GetLine(n))
--~ 	print (editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)))
		---if editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)) > 0 then
		if editor:MarkerGet(n) > 0 then
			local line=editor:GetLine(n)
			 all=line..all
			editor:LineDelete()
--~                         print ("deleted")
		end
		n = n -1
--~       do return end   -- DEBUG !!
	end
        editor:GotoLine(screen_pos)
	print ("START-MARKED "..props.FileNameExt)
	 all=all.."END-MARKET"
	print(all)
        scite.MenuCommand(IDM_BOOKMARK_CLEARALL)
end

function copy_lines_marked()
-- copy marked lines
        local screen_pos=editor.FirstVisibleLine +1 
	local n = 0
	all=""
	while editor.LineCount > n do
		editor:GotoLine(n)
	--print (editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)))
	--print(editor:GetLine(n))
		if editor:MarkerGet(editor:LineFromPosition(editor.CurrentPos)) > 0 then
			local line=editor:GetLine(n)
			str1=props.FileNameExt..":"..(n+1)..":"
			all=all..str1
			 all=all..line
			 --editor:HideLines(n,n)
			--print ( string.gsub(line, "[\r\n]+$", ""))
			--editor:LineDelete()
		end
		n = n +1
	end
        editor:GotoLine(screen_pos)
	print ("START-MARKED")
        print ("START-MARKED "..props.FileNameExt)        
	 all=all.."END-MARKET"
	print(all)
end
function lines(str)
  local t = {}
  local i, lstr = 1, #str
  while i <= lstr do
    local x, y = string.find(str, "\r?\n", i)
    if x then t[#t + 1] = string.sub(str, i, x - 1)
    else break
    end
    i = y + 1
  end
  if i <= lstr then t[#t + 1] = string.sub(str, i) end
  return t
end

function sort_text()
  local sel = editor:GetSelText()
  if #sel == 0 then return end
  local eol = string.match(sel, "\n$")
  local buf = lines(sel)
  --table.foreach(buf, print) --used for debugging
  table.sort(buf)
  local out = table.concat(buf, "\n")
  if eol then out = out.."\n" end
  editor:ReplaceSel(out)
end

function sort_text_reverse()
  local sel = editor:GetSelText()
  if #sel == 0 then return end
  local eol = string.match(sel, "\n$")
  local buf = lines(sel)
  --table.foreach(buf, print) --used for debugging
  table.sort(buf, function(a, b) return a > b end)
  local out = table.concat(buf, "\n")
  if eol then out = out.."\n" end
  editor:ReplaceSel(out)
end

function titlecase(str)
    --os.setlocale('pt_BR','ctype') -- set a locale as needed
    buf ={}
    local sel = editor:GetSelText()   
    for word in string.gfind(sel, "%S+") do         
        local first = string.sub(word,1,1)       
        table.insert(buf,string.upper(first) ..
            string.lower(string.sub(word,2)))
    end   
    editor:ReplaceSel(table.concat(buf," "))
end
function WordCount()
    local whiteSpace = 0;   --number of whitespace chars
    local nonEmptyLine = 0; --number of non blank lines
    local wordCount = 0;    --total number of words
    local compoundWordsCount = 0;    --total number of dashes inside words
    local apostropheCount = 0;    --total number of 's inside words    
   
    --Calculate whitespace control
    for m in editor:match("\n") do
        whiteSpace = whiteSpace + 1;
    end
    for m in editor:match("\r") do
        whiteSpace = whiteSpace + 1;
    end
    for m in editor:match("\t") do --count tabs
        whiteSpace = whiteSpace + 1;
    end
   
    --Calculate non-empty lines and word count
    local itt = 0;
    while itt < editor.LineCount do --iterate through each line
        local hasChar, hasNum = 0;
        line = editor:GetLine(itt);
        if line then
            hasAlphaNum = string.find(line,'%w');
        end
       
        if (hasAlphaNum ~= nill) then
            nonEmptyLine = nonEmptyLine + 1;
        end
       
        if line then
            for word in string.gfind(line, "%w+") do wordCount = wordCount + 1 end
        end
       
        if line then
	    for word in string.gfind(line, "%w%-%w") do compoundWordsCount = compoundWordsCount + 1 
	    end
	    	--print ("compoundWordsCount 2 : ",compoundWordsCount);
        end 
--[[added   "right-quotation mark" ]]--
        if line then
		--for word in string.gfind(line, "%w%'%w") do apostropheCount = apostropheCount + 1 
 		for word in string.gfind(line, "%w[']%w") do apostropheCount = apostropheCount + 1 
	    end
        end 		
	
        if line then
	    for word in string.gfind(line, "%w%?%w") do apostropheCount = apostropheCount + 1 
	    end
        end 	

	itt = itt + 1;
    end
   
    print("----------------------------");
    print("Chars: \t\t\t",(editor.Length) - whiteSpace );
    print("Words: \t\t\t",wordCount- compoundWordsCount - apostropheCount);
    print("Lines: \t\t\t",editor.LineCount);
    print("Lines(non-blank): ", nonEmptyLine);
end;

 local colours = {red = "#FF0000", blue = '#0000FF', green = '#00FF00',pink ="#FFAAAA" ,
                    black = '#000000', lightblue = '#AAAAFF',lightgreen = '#AAFFAA'}

  function colour_parse(str)
    if sub(str,1,1) ~= '#' then
      str = colours[str]
    end
    return tonumber(sub(str,6,7)..sub(str,4,5)..sub(str,2,4),16)
  end

  function marker_define(idx,typ,fore,back)
    editor:MarkerDefine(idx,typ)
    if fore then editor:MarkerSetFore(idx,colour_parse(fore)) end
    if back then editor:MarkerSetBack(idx,colour_parse(back)) end
  end
  function clearOccurrences()
    scite.SendEditor(SCI_INDICATORCLEARRANGE, 0, editor.Length)
end

function markOccurrences()
     if editor.SelectionStart == editor.SelectionEnd then
        return
    end
   clearOccurrences()
    scite.SendEditor(SCI_INDICSETSTYLE, 0, INDIC_ROUNDBOX)
    scite.SendEditor(SCI_INDICSETFORE, 0, 255)
    local txt = GetCurrentWord()
    local flags = SCFIND_WHOLEWORD
    local s,e = editor:findtext(txt,flags,0)
    while s do
        scite.SendEditor(SCI_INDICATORFILLRANGE, s, e - s)
        s,e = editor:findtext(txt,flags,e+1)
    end
end

function isWordChar(char)
    local strChar = string.char(char)
    local beginIndex = string.find(strChar, '%w')
    if beginIndex ~= nil then
        return true
    end
    if strChar == '_' or strChar == '$' then
        return true
    end
   
    return false
end

function GetCurrentWord()
    local beginPos = editor.CurrentPos
    local endPos = beginPos
    if editor.SelectionStart ~= editor.SelectionEnd then
        return editor:GetSelText()
    end
    while isWordChar(editor.CharAt[beginPos-1]) do
        beginPos = beginPos - 1
    end
    while isWordChar(editor.CharAt[endPos]) do
        endPos = endPos + 1
    end
    return editor:textrange(beginPos,endPos)
end

function SciteListAllOccurances()
  if props.CurrentSelection ~= "" then
    for m in editor:match( "^.*" .. props.CurrentSelection .. ".*$", SCFIND_REGEXP, 0) do
      print(props.FileNameExt .. ":" .. (editor:LineFromPosition(m.pos)+1) .. ":" .. m.text);
    end
  else
    alert("The InternalGrep script only searchs for selected text");
  end
end

function rem_dup()
print ('lines:', editor.LineCount)
local t = {}
local itt=1
local ind=1
t[ind]=editor:GetLine(0)
while itt < editor.LineCount do --iterate through each line
	local line = editor:GetLine(itt)
	--print ('#',itt,'line',line)
	local sw1=0
	for i,ll in ipairs(t) do
		if ll==line then
			--print('match')
			print ('match: #',itt,'line',line)
			sw1=1
			break
		end
	end
	--print('switch:', sw1)
	if sw1==0 then
		ind=ind+1
		t[ind]=line
		--print('t[',ind,']',t[ind])
		--for j,kk in ipairs(t) do print(j,'::',kk) end
	end
	--print('block``')
	--for j,kk in ipairs(t) do print(j,'::',kk) end
	--print('block,,,')
	itt=itt+1
end
--[[
print('block``')
for j,kk in ipairs(t) do print(j,'::',kk) end
print('block,,,')
]]--
local s='';
for i,ll in ipairs(t) do  s=s..ll end
--print(s)   -- debug
editor:SetText(s)
end
function toggle_highlight_current_word()
        if props['highlight.current.word']=='0' then
                props['highlight.current.word']='1'
        else
                props['highlight.current.word']='0'
        end
        print('highlight.current.word=',props['highlight.current.word'])
end
function dostring_from_output()
        --Don't forget the format : function()   !!
        -- make an option with a strip (???) 
        local str1=output:GetLine(0)     --suppressing the string length in the end. No idea why it appears.
       -- dostring ('toggle_highlight_current()')  -- test example
        dostring (str1)
end
function dofile_from_output()
        --Don't forget the format : function()   !!
        -- make an option with a strip (???) 
        local str1=output:GetLine(1)  -- suppressing the string length in the end. No idea why it appears.
        print (str1)
   --     str1='C:\Users\yury.dubinsky\stuff\wscite\t1.lua'
        dofile (str1)
end
function my_brace_match()
        scite.MenuCommand(IDM_MATCHBRACE)
end
