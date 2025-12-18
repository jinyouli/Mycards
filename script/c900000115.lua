--殉道者 龙宠(ZCG)
function c900000115.initial_effect(c)
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c900000115.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c900000115.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c900000115.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c900000115.disop)
    c:RegisterEffect(e13)

    -- 反转效果
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES) -- 效果分类：特殊召唤、卡组操作
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) -- 类型：单体、诱发效果、强制发动
    e1:SetCode(EVENT_FLIP) -- 发动时点：反转时
    e1:SetTarget(c900000115.target) -- 设置效果目标函数
    e1:SetOperation(c900000115.operation) -- 设置效果处理函数
    c:RegisterEffect(e1)

end
----------------------------------------------------------------------
function c900000115.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c900000115.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c900000115.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
----------------------------------------------------------------------

-- 效果目标处理函数
function c900000115.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end -- 无条件发动，目标在操作中确定
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,10) -- 告知系统将进行卡组操作（翻10张）
end

-- 效果处理函数
function c900000115.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetDecktopGroup(tp,10) -- 获取己方卡组最上方的10张卡
    if g:GetCount()==0 then return end -- 如果卡组不足10张，直接结束

    Duel.ConfirmCards(tp, g) -- 向己方展示这些卡

    -- 分类卡片
    local mg=g:Filter(Card.IsType,nil,TYPE_MONSTER) -- 怪兽卡
    local sg=g:Filter(aux.TRUE,mg) -- 魔法/陷阱卡（非怪兽卡）

    -- 处理怪兽卡：尽可能特殊召唤
    if mg:GetCount()>0 then
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) -- 获取可用的主要怪兽区域格数
        if ft>mg:GetCount() then
            ft=mg:GetCount() -- 最多特殊召唤的怪兽数量不超过格数和翻开的怪兽数
        end
        if ft>0 then
            Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) -- 特殊召唤怪兽
        end
    end

    -- 处理魔法/陷阱卡：直接盖放到场上
    if sg:GetCount()>0 then
        local sft=Duel.GetLocationCount(tp,LOCATION_SZONE) -- 获取可用的魔法与陷阱区域格数
        if sft>sg:GetCount() then
            sft=sg:GetCount()
        end
        if sft>0 then
            local fc=sg:GetFirst()
            while fc do
                Duel.MoveToField(fc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) -- 以里侧表示盖放
                fc=sg:GetNext()
            end
        end
    end

    -- 将剩余卡（主要是没被特殊召唤或盖放的）洗回卡组
    local rg=Group.CreateGroup()
    rg:Merge(g) -- 将最初的10张卡加入剩余组
    rg:Sub(mg) -- 减去已特殊召唤的怪兽
    rg:Sub(sg) -- 减去已盖放的魔法/陷阱

    if rg:GetCount()>0 then
        Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) -- 洗回卡组
    end

    Duel.ShuffleDeck(tp) -- 洗切卡组
end