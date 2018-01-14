local M = {}

local scheme = {{0,0,0,0},{0,0,0,1},{0,0,1,1},{0,1,1,1},{1,1,1,1}}

local pai = {}
pai.__index = pai

local function newPai(t)
	local p = {}
	p = setmetatable(p,pai)
	p.pai = {}
	p.index = {}
	local tt,cc
	table.sort(t,function (l,r) return l < r end)
	for k,v in pairs(t) do
		if tt ~= v then
			if tt then
				table.insert(p.pai,{tt,c})
				p.index[tt] = p.pai[#p.pai]			
			end
			tt = v
			c = 1	
		else
			c = c + 1
		end
	end
	table.insert(p.pai,{tt,c})
	return p	
end

function pai:Copy()
	local p = {}
	p = setmetatable(p,pai)
	p.pai = {}
	p.index = {}
	for k,v in pairs(self.pai) do
		if v[2] > 0 then
			table.insert(p.pai,{v[1],v[2]})
			p.index[v[1]] = p.pai[#p.pai]
		end
	end
	return p
end

--移除一组刻子
function pai:RemoveKe()
	for k,v in pairs(self.pai) do
		if v[2] >= 3 then
			v[2] = v[2] - 3
			return true
		end
	end
	return false
end

--移除一组顺子
function pai:RemoveOrder()	
	for k,v in pairs(self.pai) do
		if v[2] > 0 then
			local n = v[1] + 1
			local nn = n + 1
			local _n = self.index[n]
			local _nn = self.index[nn]
			if _n and _nn and _n[2] > 0 and _nn[2] > 0 then
				v[2] = v[2] - 1
				_n[2] = _n[2] - 1
				_nn[2] = _nn[2] - 1
				return true
			end
		end
	end
	return false
end

function pai:GetPairCount()
	local count = 0
	for k,v in pairs(self.pai) do
		if v[2] >= 2 then
			count = count + 1
		end
	end
	return count
end

function M.CheckScheme(s,p)
	local f ={[0] = p.RemoveKe,[1] = p.RemoveOrder}
	for k,v in pairs(p.pai) do
		--先抽将牌
		if v[2] >= 2 then
			local pp = p:Copy()
			local t = pp.index[v[1]]
			t[2] = t[2] - 2		
			local ok = true
			for i = 1,4 do
				if not f[s[i]](pp) then
					ok = false
					break
				end
			end
			if ok then
				return true
			end	
		end
	end
	return false
end

function M.CheckHu(pai)

	if #pai < 14 then
		return false
	end

	local p = newPai(pai)

	--7个对子
	if 7 == p:GetPairCount() then
		return true
	end

	for k,v in pairs(scheme) do
		if M.CheckScheme(v,p) then
			return true
		end
	end
	return false
end


local now = os.time()

for i = 1,10000 do

	M.CheckHu({1,1,1,2,2,2,3,3,3,4,4,4,5,5})
	M.CheckHu({1,2,3,4,5,6,1,2,3,4,5,6,7,7})
	M.CheckHu({1,1,1,1,2,2,2,2,3,3,3,3,4,4})
	M.CheckHu({1,1,1,2,3,4,5,6,4,5,6,7,8,9})
	M.CheckHu({1,1,1,2,3,2,3,4,3,4,5,7,8,9})
	M.CheckHu({1,1,1,4,5,6,2,3,4,4,5,6,9,9})
	M.CheckHu({1,2,3,6,1,2,3,4,5,5,7,7,9,9})
end

print(os.time() - now)



print(M.CheckHu({1,1,1,2,2,2,3,3,3,4,4,4,5,5}))
print(M.CheckHu({1,2,3,4,5,6,1,2,3,4,5,6,7,7}))
print(M.CheckHu({1,1,1,1,2,2,2,2,3,3,3,3,4,4}))
print(M.CheckHu({1,1,1,2,3,4,5,6,4,5,6,7,8,9}))
print(M.CheckHu({1,1,1,2,3,2,3,4,3,4,5,7,8,9}))
print(M.CheckHu({1,1,1,4,5,6,2,3,4,4,5,6,9,9}))
print(M.CheckHu({1,2,3,4,1,2,3,4,5,5,7,7,9,9}))
print(M.CheckHu({1,1,2,2,3,3,4,4,5,5,7,7,9,9}))

print(M.CheckHu({1,2,3,6,1,2,3,4,5,5,7,7,9,9}))

print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,11}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,12}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,13}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,14}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,15}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,16}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,17}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,18}))
print(M.CheckHu({11,11,11,12,13,14,15,16,17,18,19,19,19,19}))




return M