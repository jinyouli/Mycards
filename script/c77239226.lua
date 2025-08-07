--奥利哈刚 炎魔象(ZCG)
function c77239226.initial_effect(c)
    c:EnableReviveLimit()

    --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c77239226.spcon)
	c:RegisterEffect(e2)
end
------------------------------------------------------------------
function c77239226.spfilter(c)
    return c:IsFaceup() and c:IsCode(48179391)
end
function c77239226.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
        Duel.IsExistingMatchingCard(c77239226.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
