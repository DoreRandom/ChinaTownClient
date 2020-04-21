--分割字符串
function string.split(str,resp)
    local list = {}
    string.gsub(str,'[^'..resp..']+',function ( w )
        table.insert(list,w)
    end)
    return list

end

