-- 幻影军团
-- 永续魔法卡
-- 效果：①：1回合1次，以自己或对方场上1只表侧表示怪兽为对象才能发动。在自己场上特殊召唤任意数量的衍生物，这些衍生物的卡名和原本的攻击力·守备力·等级·种族·属性变成和选择的怪兽相同。

local s, id = GetID()
function s.initial_effect(c)
    --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

    -- ①效果：生成衍生物
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_IGNITION) --  ignition 表示是自己的主要阶段发动
    e1:SetRange(LOCATION_SZONE) -- 魔法陷阱区域
    e1:SetCountLimit(1) -- 1回合1次
    e1:SetTarget(s.tktg)
    e1:SetOperation(s.tkop)
    c:RegisterEffect(e1)
end

function s.filter(c)
	return c:IsFaceup()
end

-- 效果的目标处理函数（检查发动条件）
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        -- 检查场上是否有表侧表示怪兽
        return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
               and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 -- 至少有一个可用的主怪兽区域格子
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    -- 选择对方或我方场上一只表侧怪兽作为对象
    local g = Duel.SelectTarget(tp, s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if #g>0 then
        e:SetLabelObject(g:GetFirst())
        Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
    end
end

-- 效果的实际处理函数
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local tc = e:GetLabelObject()
    if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
        return
    end

    local tokenCount = 1

    -- 获取目标怪兽的原始信息
    local code = tc:GetOriginalCode()
    local originalRace = tc:GetOriginalRace()
    local originalAttribute = tc:GetOriginalAttribute()
    local originalLevel = tc:GetOriginalLevel()
    -- local originalAttack = tc:GetOriginalAttack()
    -- local originalDefense = tc:GetOriginalDefense()
    local originalAttack = 1000
    local originalDefense = 1000

    -- 循环特殊召唤每一个衍生物
    for i=1, tokenCount do
        local token = Duel.CreateToken(tp, 900000109) -- 创建指定Code的Token（会复制卡名）
        -- 使用效果设置Token的原始属性（因为Token默认是通常怪兽，需要修改其原始数据）
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(originalAttack)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e1,true)

        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(originalDefense)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e2,true)

        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(originalLevel)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e3,true)

        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CHANGE_RACE)
        e4:SetValue(originalRace)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e4,true)

        local e5 = Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e5:SetValue(originalAttribute)
        e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e5,true)

        -- 将Token特殊召唤到场上
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)

        token:CopyEffect(code, RESET_EVENT+RESETS_STANDARD, 1) 
        -- 复制名字
        local e6=Effect.CreateEffect(c)
        e6:SetType(EFFECT_TYPE_SINGLE)
        e6:SetCode(EFFECT_CHANGE_CODE)
        e6:SetValue(code)
        e6:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e6)
    end
    Duel.SpecialSummonComplete()
end