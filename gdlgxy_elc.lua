--Github Action 定时推送电量情况
--gdlgxy
--需要库
local json = require "dkjson"
local http = require "socket.http"
local process = require "environ.process"

local room = process.getenv("room")
local url1 = process.getenv('url1')
local pushToken = process.getenv('token')


local date=os.date("%m月%d日")
function all(method,URL,request_body)
  local response_body = {}
  local res, code, response_headers = http.request
   {
      url = URL,
      method = method,
      headers =
        {
            ["Content-Type"] = "application/json; charset=UTF-8";
			["Content-Length"] = #request_body;
        },
		source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body),
   }
  if type(response_body) == "table" then
    backa = table.concat(response_body)   --返回值backa
	return backa
	end
end
all("GET",url1..room,"")
local aa = backa   --print(aa)
-- 创建并打开临时文件
local myfile = io.tmpfile()
--------------------------------------------rule
local se = '<h4 style="color: #ffffff;">(.-)</label>'
--获取网页内容
for a in string.gmatch(aa,se) do
	a1 = string.gsub(a,"</h4>","")
	a2 = string.gsub(a1,"<h4>","")
	a3 = string.gsub(a2,"</(.+)>","")
	a4 = string.gsub(a3,"\n","#")
	a5 = string.gsub(a4,'#(%s+)#',"|")
	a6 = string.gsub(a5,'#(%s+)',"")
	a7 = string.gsub(a6,'#','')
    a8 = string.gsub(a7,'|','| #')
	a9 = string.gsub(a8,"\r","")
	a10 =string.gsub(a9,"|%s+","")
	a11 = string.gsub(a10,"#%s+","|")
	myfile:write("  \n"..a11)
	--print(a11)
	end
--------------------------------------------rule
myfile:write("\n\n")
myfile:write("  \n >消息推送时间："..date)
myfile:write("  \n点击[查询电费使用情况]("..url1..room..")")
myfile:seek("set")
local sy = ""   local cb = ""
for i in myfile:lines() do
	if string.match(i,"剩余") then
	sy = i
	elseif string.match(i,"抄表") then
	cb = i
	end
end
local title = date.."："..sy.." |"..cb  --print(title)
myfile:seek("set")
local content = myfile:read("*a");
local a = {}
	a["token"] = pushToken
	a["title"] = title
	a["content"] = content
	--a["topic"] = room
	a["template"] = "markdown"
local pushjson = json.encode(a)
--print(pushjson)
all("POST","http://www.pushplus.plus/send",pushjson)
print(backa)

