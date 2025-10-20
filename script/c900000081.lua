--naturia bamboo shoot
function c900000081.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c900000081.spcon)
	c:RegisterEffect(e2)

	--不会被战斗破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    -- 永续效果：对方场上魔法·陷阱卡无效并破坏
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0, LOCATION_ONFIELD)  -- 对方场上的所有卡
    e4:SetTarget(c900000081.distg)
    c:RegisterEffect(e4)
    
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0, LOCATION_ONFIELD)
    e5:SetTarget(c900000081.distg)
    c:RegisterEffect(e5)

	--limit spell trap
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetValue(c900000081.aclimit)
	c:RegisterEffect(e7)

	--limit monster
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetValue(c900000081.acmonsterlimit)
	c:RegisterEffect(e8)

	-- 效果1：永续效果 - 对方场上魔法/陷阱卡全部破坏
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS) -- 场地区域+持续效果
    e9:SetCode(EVENT_ADJUST) -- 监听任何可能改变场上的事件
    e9:SetRange(LOCATION_MZONE) -- 效果范围：自己在怪兽区域存在时
    e9:SetCondition(c900000081.mtcon) -- 条件函数
    e9:SetOperation(c900000081.mtop) -- 操作函数
    c:RegisterEffect(e9)

    -- 效果2：入场时发动一次效果，确保立即生效
    local e10 = Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e10:SetCode(EVENT_SPSUMMON_SUCCESS)
    e10:SetOperation(c900000081.mtop) -- 使用同一个操作函数
    c:RegisterEffect(e10)
end

-- 禁用效果的目标筛选（魔法·陷阱区域）
function c900000081.distg(e, c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsLocation(LOCATION_ONFIELD)
end

function c900000081.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c900000081.acmonsterlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end

function c900000081.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

-- 效果条件检查函数
function c900000081.mtcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) -- 自身表侧表示存在于怪兽区域
end

-- 效果操作执行函数
function c900000081.mtop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsFaceup() or not c:IsLocation(LOCATION_MZONE) then return end -- 再次检查自身状态
    
    local g = Duel.GetMatchingGroup(Card.IsType, 1 - tp, LOCATION_SZONE, 0, nil) -- 获取对方场上所有魔法/陷阱区的卡
    if #g > 0 then
        Duel.Destroy(g, REASON_EFFECT) -- 破坏这些卡
    end
end