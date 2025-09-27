-- 速攻魔法：连锁爆发
function c900000101.initial_effect(c)
    -- 激活效果
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c900000101.target)
    e1:SetOperation(c900000101.activate)
    c:RegisterEffect(e1)
end

-- 目标选择函数：确定可以发动的卡
function c900000101.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        -- 检查手牌中是否有可发动的陷阱卡
        return Duel.IsExistingMatchingCard(c900000101.filter, tp, LOCATION_HAND, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_ACTIVATE, nil, 0, tp, LOCATION_HAND)
end

-- 过滤函数：筛选手牌中的陷阱卡
function c900000101.filter(c)
    return c:IsType(TYPE_TRAP) and c:CheckActivateEffect(false, false, false) ~= nil
end

-- 效果操作函数：执行发动效果
function c900000101.activate(e, tp, eg, ep, ev, re, r, rp)
    -- 选择手牌中的陷阱卡
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ACTIVATE)
    local g = Duel.SelectMatchingCard(tp, c900000101.filter, tp, LOCATION_HAND, 0, 1, 99, nil)
    
    if #g == 0 then return end
    
    -- 逐一发动选择的陷阱卡
    for tc in aux.Next(g) do
        if Duel.GetLocationCount(tp,LOCATION_SZONE) <= 0 then
            Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(900000101,0)) -- "没有足够的魔法陷阱区！"
            break
        end
        
        -- 关键修正：将陷阱卡表侧表示放置到魔法与陷阱区域
        if Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
            -- 获取陷阱卡的激活效果
            local te = tc:GetActivateEffect()
            if te then
                -- 模拟陷阱卡的正常发动流程
                local cost = te:GetCost()
                local target = te:GetTarget()
                
                if cost then
                    cost(te, tp, eg, ep, ev, re, r, rp, 1)
                end
                -- 设置Target
                if target then
                    target(te, tp, eg, ep, ev, re, r, rp, 1)
                end

                local m=_G["c"..tc:GetCode()]
                if m.activate then
                    m.activate(e,tp,eg,ep,ev,re,r,rp)
                end
                if m.operation then
                    m.operation(e,tp,eg,ep,ev,re,r,rp)   
                end

                if tc:GetType()~=TYPE_TRAP+TYPE_CONTINUOUS then
                    Duel.SendtoGrave(tc, REASON_RULE)
                end 
            end
        end

    end
end