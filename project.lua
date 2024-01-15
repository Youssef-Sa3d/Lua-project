local ui = require "ui"
local sqlite = require "sqlite"
require "webview"


--local sql script data
local db = sqlite.Database(":memory:")
db:exec([[CREATE TABLE members (
            id integer PRIMARY KEY,
            name text NOT NULL,
            age  integer)
          ]]
        )
        
db:exec("INSERT INTO members (id , name , age) VALUES(20101839 , 'Youssef' , 21)")
db:exec("INSERT INTO members (id , name , age) VALUES(20101111 , 'Manzlawy' , 21)")
db:exec("INSERT INTO members (id , name , age) VALUES(20101112 , 'Zeyad' , 22)")
db:exec("INSERT INTO members (id , name , age) VALUES(20101113 , 'Shady' , 21)")

--*********************************************************************************************
 
 win = ui.Window("SQL to FILE", 800, 500)
--start screen
label = ui.Label(win, "Welcome!" )
label:center()
label.y = 0
label.font = "Times New Roman"
label.fontsize = 15
buttonStart = ui.Button(win, "Start", 0 , 0 , 150 , 25)
buttonStart:center()

--main screen
localscript = ui.Button(win, "Local script", 200 , 250 , 150 , 25)
localscript:hide()  
filescript = ui.Button(win, "SQL file script", 600 , 250 , 150 , 25)
filescript:hide()
browser = ui.Button(win, "Browser", 400 , 350 , 150 , 25)
browser:hide()


--export screens
labelfile = ui.Label(win, "Text file name: " , 200 , 100 )
labelfile.font = "Times New Roman"
labelfile.fontsize = 12
filename = ui.Entry(win , "" , 300 , 100 , 150 , 25)
labelsql = ui.Label(win, "SQL file name: " , 200 , 150 )
labelsql.font = "Times New Roman"
labelsql.fontsize = 12
sqlname = ui.Entry(win , "" , 300 , 150 , 150 , 25)
back = ui.Button(win, "<-- Back <--", 10 , 400 , 100 , 25)
export = ui.Button(win, "Export", 300 , 200 , 150 , 25)
labelfile:hide()
filename:hide()
labelsql:hide()
sqlname:hide()
back:hide()
export:hide()

--browse screen
browselabel = ui.Label(win, "Website name:  " , 200 , 100 )
browselabel.font = "Times New Roman"
browselabel.fontsize = 12
searchbar = ui.Entry(win , "" , 300 , 100 , 150 , 25)
search = ui.Button(win, "Search", 300 , 200 , 150 , 25)
note = ui.Label(win, "strat with 'https://www.'    ex: 'https://www.facebook.com'" , 460 , 100 )
note.font = "Times New Roman"
note.fontsize = 10
searchbar:hide()
browselabel:hide()
search:hide()
note:hide()


--*********************************************************************************************

--desktop app browser
function www()
  label.text = browselabel.text
  localscript:hide()
  filescript:hide()
  browser:hide()
  browselabel:show()
  searchbar:show()
  search:show()
  back:show()
  note:show()
  function back:onClick()
    browselabel:hide()
    searchbar:hide()
    search:hide()
    back:hide()
    note:hide()
    mainScreen()
  end
  function search:onClick()
    win.width = 1500
    win.height = 1000
    Webview = ui.Webview(win, searchbar.text)
    Webview.align = "all"
  end
end


--*********************************************************************************************




--sql file to text file (script)
function sqlFile()
  label.text = filescript.text
  localscript:hide()
  filescript:hide()
  browser:hide()
  labelfile:show()
  filename:show()
  labelsql:show()
  sqlname:show()
  back:show()
  export:show()
  function back:onClick()
    labelfile:hide()
    filename:hide()
    labelsql:hide()
    sqlname:hide()
    back:hide()
    export:hide()
    mainScreen()
  end
  function export:onClick()
    labelfile:hide()
    filename:hide()
    sqlname:hide()
    labelsql:hide()
    export:hide()
    local message = ui.Label(win, "")
    message:center()
    local sqlFilePath =  sqlname.text .. ".sql"
    local sqlFile = io.open(sqlFilePath, "r")
    if sqlFile then
      local filename = filename.text .. ".text"
      local file, err = io.open(filename, "w")
      local sqlContent = sqlFile:read("*a")
      sqlFile:close()
      local queries = {}
      for query in sqlContent:gmatch("[^;]+") do
        table.insert(queries, query)
      end
      print("SQL Queries:")
      for _, query in ipairs(queries) do
        file:write(query)
      end
      file:close()
      message.text = "File created successfully."
      back:hide()

    else
      message.text = "Error!"
    end
  end
end



--*********************************************************************************************



--local sql script data to text file
function sqlLocal()
  label.text = localscript.text
  localscript:hide()
  filescript:hide()
  browser:hide()
  labelfile:show()
  filename:show()
  export:show()
  back:show()
  function back:onClick()
    labelfile:hide()
    filename:hide()
    back:hide()
    export:hide()
    mainScreen()
  end
  function export:onClick()
    labelfile:hide()
    filename:hide()
    export:hide()
    message = ui.Label(win, "")
    message:center()
    filename = filename.text .. ".text"
    file = io.open(filename, "w")
    if file then
      for member in db:query("SELECT * FROM members") do
        file:write(member.id .. " , " .. member.name .. " , " .. member.age .. ". \n")
      end
      file:close()
      message.text = "File created successfully."
      back:hide()
      

      
    else
      message.text = "Error!"
    end
  end
end


--*********************************************************************************************



--home screen function
function mainScreen()
  buttonStart:hide()
  label.text = buttonStart.text
  localscript:show()
  filescript:show()
  browser:show()


  function localscript:onClick()
    sqlLocal()
  end
  
  function filescript:onClick()
    sqlFile()
  end
  
  function browser:onClick()
    www()
  end

end



--*********************************************************************************************



function buttonStart:onClick()
  mainScreen()
end


--*********************************************************************************************



win:show()
repeat
	ui.update()
until not win.visible