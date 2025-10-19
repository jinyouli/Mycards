--SNo.0 ホープ・ゼアル
function c900000104.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c900000104.mfilter,c900000104.xyzcheck,3,3,c900000104.ovfilter,aux.Stringid(900000104,0),c900000104.xyzop)

	-- 效果：只要这张卡在场上表侧表示存在，对方不能发动卡的效果
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_MZONE)  -- 场上区域
    e1:SetTargetRange(0, 1)     -- 对方玩家
    e1:SetValue(c900000104.aclimit)
    c:RegisterEffect(e1)

	--cannot disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c900000104.effcon)
	c:RegisterEffect(e2)

	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c900000104.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end

aux.xyz_number[900000104]=0
-- 核心效果过滤函数：阻止所有效果发动
function c900000104.aclimit(e, re, tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)       -- 魔法/陷阱的发动
        or (re:IsActiveType(TYPE_MONSTER)          -- 怪兽效果
        and re:GetHandler():IsLocation(LOCATION_HAND | LOCATION_DECK | LOCATION_GRAVE | LOCATION_REMOVED | LOCATION_EXTRA))
end

function c900000104.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c900000104.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c900000104.cfilter(c)
	return c:IsSetCard(0x95) and c:GetType()==TYPE_SPELL and c:IsDiscardable()
end
function c900000104.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c900000104.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c900000104.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c900000104.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c900000104.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c900000104.chlimit(e,ep,tp)
	return tp==ep
end
function c900000104.atkval(e,c)
	return c:GetOverlayCount()*1000
end
